//
//  DevicesViewController.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/2/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
import RxDataSources
/*
   DevicesViewController to show connected and removed devices list.
**/
class DevicesViewController: UIViewController, Storyboardable {
    /// Outlets
    @IBOutlet weak var tableView: UITableView!
    
    /// Constants/Variables
    var viewModel: DevicesViewModel!
    let disposeBag = DisposeBag()
    let dataSource = DevicesViewController.dataSource()
    var refreshHandler: RefreshHandler?
    
    // MARK: View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindDataSource()
        viewModel.getConnectedDevices()
        AnalyticsEvents.trackScreenVisitEvent(with: AnalyticsConstants.EventScreenName.devices)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Initial UI setup
    /// This will setup table view, adding loading indicator and iInitializes RefreshHandler for pull to refresh functionality.
    private func initialSetup() {
        showLoaderView(with: Constants.Common.loading)
        refreshHandler = RefreshHandler.init(view: tableView)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.BiWFColors.purple,
                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        refreshHandler?.refreshControl.attributedTitle = NSAttributedString(string: Constants.Device.pullToRefresh,
                                                                            attributes: attributes)
        refreshHandler?.refreshControl.tintColor = UIColor.BiWFColors.purple
        tableView.delegate = nil
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        registerNib()
    }
    
    /// Registering cell nib for table view - DeviceDetailTableViewCell, ConnectedDeviceTableHeader, RemovedDeviceTableHeader
    private func registerNib() {
        tableView.register(UINib(nibName: DeviceDetailTableViewCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: DeviceDetailTableViewCell.identifier)
        tableView.register(
            UINib(nibName: ConnectedDeviceTableHeader.identifier,
                  bundle: nil),
            forHeaderFooterViewReuseIdentifier: ConnectedDeviceTableHeader.identifier)
        tableView.register(
            UINib(nibName: RemovedDeviceTableHeader.identifier,
                  bundle: nil),
            forHeaderFooterViewReuseIdentifier: RemovedDeviceTableHeader.identifier)
    }
    
    /// binding viewmodel to the tableview
    private func bindDataSource() {
        if tableView.dataSource == nil {
            viewModel.sections.asObserver()
                .bind(to: tableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        }
    }
    
    /// binding viewmodel to the tableview cell
    static func dataSource() -> RxTableViewSectionedReloadDataSource<TableDataSource> {
        return RxTableViewSectionedReloadDataSource<TableDataSource>(
            
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier) else { return UITableViewCell() }
                cell.selectionStyle = .none
                
                //Check for the cell type & viewmodel, then set the viewModel of cell
                if var cell = cell as? DeviceDetailTableViewCell, let viewModel = item.viewModel as? DeviceDetailTableCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                return cell
        })
    }
    
    func showLoaderView(with loadingText: String) {
        self.view.showLoaderView(with: loadingText)
    }
    
    /// Showing restore alert when click on removed device
    /// - Parameter
    ///     - deviceInfo: Device information
    private func showRestoreDeviceAlert(for deviceInfo: DeviceInfo) {
        let title = "\(Constants.ConnectedDevices.wantToRestore) \"\(deviceInfo.hostname ?? "")\"?"
        self.showAlert(with: title,
                       message: Constants.ConnectedDevices.youCanRemove, leftButtonTitle: Constants.Common.restore, rightButtonTitle: Constants.Common.cancelButtonTitle, rightButtonStyle: .cancel, leftButtonDidTap: { [weak self] in
                        AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.restoreAccess)
                        self?.viewModel.input.restoreDeviceObserver.onNext((deviceInfo))
        }) {
            AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.restoreAccessCancel)
        }}
}

/// DevicesViewController Extension confirm Bindable protocol.
/// This is provide a standard interface to all it's internal elements to be bound to a view model
extension DevicesViewController: Bindable {
    func bindViewModel() {
        bindInputs()
        bindOutputs()
    }
    
    /// Binding all the input observers from viewmodel to get the events
    func bindInputs() {
        
        /// Tableview item selected binding with view model cellSelectionObserver
        tableView.rx.itemSelected
            .subscribe(viewModel.input.cellSelectionObserver)
            .disposed(by: disposeBag)
    }
    
    /// Binding all the output from viewmodel to get the events to subscribe
    func bindOutputs() {
        
        viewModel.output.viewStatusObservable.subscribe(onNext: { [weak self] viewStatus in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch viewStatus{
                case .loading(let loadingText):
                    self.showLoaderView(with: loadingText ?? "")
                case .loaded:
                    self.view.removeSubView()
                case .error(errorMsg: let errorMsg, retryButtonHandler: let retryButtonHandler):
                    self.view.showErrorView(with: errorMsg, reloadHandler: retryButtonHandler)
                }
            }
        }).disposed(by: disposeBag)
        
        viewModel.output.restoreDeviceAlertObservable.subscribe(onNext: { [weak self] deviceInfo in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showRestoreDeviceAlert(for: deviceInfo)
            }
        }).disposed(by: disposeBag)
        
        refreshHandler?.refresh.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.tableView.isUserInteractionEnabled = false
            self.tableView.isScrollEnabled = false
            self.viewModel.getConnectedDevices()
        }).disposed(by: disposeBag)
        
        viewModel.endRefreshing.subscribe(onNext: { [weak self] shouldHide in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.isUserInteractionEnabled = true
                self.tableView.isScrollEnabled = true
                self.tableView.isHidden = shouldHide
                self.refreshHandler?.end()
            }
        }).disposed(by: disposeBag)
    }
}

/// DevicesViewController Extension for UITableViwe delegate method
extension DevicesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        ///Header for connected devices
        case DevicesViewModel.SectionType.connectedDevices.rawValue:
            guard var headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: ConnectedDeviceTableHeader.identifier)
                as? ConnectedDeviceTableHeader
                else { return UITableViewHeaderFooterView() }
            
            let viewModel = ConnectedDeviceTableHeaderViewModel(withConnectedDeviceCount: self.viewModel.connectedDevices?.count ?? 0, isExpanded: self.viewModel.showConnectedDevices)
            headerView.setViewModel(to: viewModel)
            
            headerView.viewModel.shouldExpandSubject.subscribe(onNext: {[weak self] bool in
                guard let self = self else { return }
                AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.connectedDevicesExpandCollapseArrow)
                self.viewModel.showConnectedDevices = !viewModel.isExpanded
                self.viewModel.setSections()
            }).disposed(by: disposeBag)
            
            return headerView
        ///Header for removed devices
        case DevicesViewModel.SectionType.removedDevices.rawValue:
            guard var headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: RemovedDeviceTableHeader.identifier)
                as? RemovedDeviceTableHeader
                else { return UITableViewHeaderFooterView() }
            
            let viewModel = RemovedDeviceTableHeaderViewModel()
            headerView.setViewModel(to: viewModel)
            return headerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.Device.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case DevicesViewModel.SectionType.connectedDevices.rawValue:
            return Constants.Device.connectedDeviceHeaderHeight
        case DevicesViewModel.SectionType.removedDevices.rawValue:
            return Constants.Device.removedDeviceHeaderHeight
        default:
            return 0
        }
    }
}
