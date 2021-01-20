//
//  SupportViewController.swift
//  BiWF
//
//  Created by pooja.q.gupta on 08/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
import RxDataSources
/*
 SupportViewController to provide the support about FAQ's and call back
 */
class SupportViewController: UIViewController, Storyboardable {
    
    /// SectionType to select a perticular section in tableview
    enum SectionType: Int {
        case faq
        case speedTest
        case contactUs
    }
    
    ///Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableFooterView: UIView!
    
    /// Bar buttons
    var doneButton: UIBarButtonItem!
    
    /// Holds the SupportViewModel with strong reference
    var viewModel: SupportViewModel!
    
    let disposeBag = DisposeBag()
    
    let dataSource = SupportViewController.dataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setNavigationBar()
        showLoaderView()
        AnalyticsEvents.trackScreenVisitEvent(with: AnalyticsConstants.EventScreenName.support)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindDataSource()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    /// Binding all the tableview values
    private func initialSetup() {
        tableView.delegate = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.Support.cellEstimatedHeight
        tableView.separatorColor = UIColor.BiWFColors.light_grey
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        registerNib()
    }

    /// Navigationbar setup
    private func setNavigationBar() {
        self.title = viewModel.title
        doneButton = UIBarButtonItem.init(title: Constants.Common.done,
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        doneButton.defaultSetup()
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    /// Registers the xib files into tableview
    private func registerNib() {
        tableView.register(UINib(nibName: TitleTableViewCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: TitleTableViewCell.identifier)
        tableView.register(UINib(nibName: ContactUsTableViewCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: ContactUsTableViewCell.identifier)
        tableView.register(
            UINib(nibName: TitleHeaderview.identifier,
                  bundle: nil),
            forHeaderFooterViewReuseIdentifier: TitleHeaderview.identifier)
    }
    
    /// Binding  the table view data sources from viewmodel
    private func bindDataSource() {
        if tableView.dataSource == nil {
            viewModel.sections.asObserver()
                .bind(to: tableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        }
    }
    
    /// datasource to configure  tableViewCell and return single tableview cell
    static func dataSource() -> RxTableViewSectionedReloadDataSource<TableDataSource> {
        return RxTableViewSectionedReloadDataSource<TableDataSource>(
            
            configureCell: { dataSource, tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier) else { return UITableViewCell()}
                cell.selectionStyle = .none
                
                //Check for the cell type & viewmodel, then set the viewModel of cell
                if var cell = cell as? TitleTableViewCell, let viewModel = item.viewModel as? TitleTableViewCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                
                if var cell = cell as? ContactUsTableViewCell, let viewModel = item.viewModel as? ContactUsCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                
                if var cell = cell as? SpeedTestTableViewCell, let viewModel = item.viewModel as? SpeedTestCellViewModel {
                    cell.setViewModel(to: viewModel)
                }
                
                if var cell = cell as? RestartModemTableViewCell, let viewModel = item.viewModel as? RestartModemViewModel {
                    cell.setViewModel(to: viewModel)
                }
                return cell
        })
    }

    /// Shows the loading option to the user with button being disabled  while loading
    func showLoaderView() {
        self.view.showLoaderView(with: Constants.Common.loading)
    }
}

/// SupportViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension SupportViewController: Bindable {
    func bindViewModel() {
        bindInputs()
        bindOutputs()
    }
    
    /// Binding all the input observers from viewmodel to get the events
    func bindInputs() {
        
        self.doneButton.rx.tap
            .bind(onNext: {[weak self] _ in
                AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.supportDone)
                self?.viewModel.input.closeObserver.onNext(())
            })
            .disposed(by: self.disposeBag)
        
        /// Tableview item selected binding with openDetailsObserver
        tableView.rx.itemSelected
            .subscribe(viewModel.input.cellSelectionObserver)
            .disposed(by: disposeBag)
    }
    
    /// Binding all the output drivers from viewmodel to get the values
    func bindOutputs() {
        
        viewModel.output.viewStatusObservable.subscribe(onNext: { [weak self] viewStatus in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch viewStatus{
                case .loading(_):
                    self.showLoaderView()
                    
                case .loaded:
                    self.view.removeSubView()
                    
                case .error(errorMsg: let errorMsg, retryButtonHandler: let retryButtonHandler):
                    self.view.showErrorView(with: errorMsg, reloadHandler: retryButtonHandler)
                }
            }
        }).disposed(by: disposeBag)
    }
}

/// SupportViewController extension confirming to Tableview delegate
extension SupportViewController: UITableViewDelegate {
    
    /// Used to give the custom height for the view inside the table which returns a UIView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard var headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TitleHeaderview.identifier)
            as? TitleHeaderview
            else { return UITableViewHeaderFooterView() }
        let hideTopBottomSeperaor = viewModel.handleSeperator(for: section)
        var viewModel :TitleHeaderViewModel
        viewModel = TitleHeaderViewModel(title: self.dataSource[section].header ?? "",
                                         subtitle: self.dataSource[section].subHeader ?? NSMutableAttributedString(),
                                         hideTopSeperator: hideTopBottomSeperaor.0,
                                         hideBottomSeperator: hideTopBottomSeperaor.1)
        headerView.setViewModel(to: viewModel)
        return headerView
    }
        
    /// Used to give custom height for each cell in a tableview which returns a float
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section = indexPath.section == SectionType.speedTest.rawValue && (AppointmentRepository.isInsatllationAppointment ?? false) ? indexPath.section+1 : indexPath.section
        
        switch section {
        case SectionType.faq.rawValue:
            return Constants.Support.faqCellHeight
        case SectionType.speedTest.rawValue:
            return viewModel.shouldShowSpeeedTest ? Constants.Support.speedTestCellHeight :  Constants.Support.restartModemCellHeight
        case SectionType.contactUs.rawValue:
            return Constants.Support.contactUsCellHeight
        default:
            return UITableView.automaticDimension
        }
    }
    
    /// Used to give custom height for header section in a tableview which returns a float
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionIndex = section == SectionType.speedTest.rawValue && (AppointmentRepository.isInsatllationAppointment ?? false) ? section+1 : section
        
        switch sectionIndex {
        case SectionType.faq.rawValue, SectionType.contactUs.rawValue:
            return Constants.Support.headerWithOutSubtitleHeight
        case SectionType.speedTest.rawValue:
            return Constants.Support.headerWithSubtitleHeight
        default:
            return UITableView.automaticDimension
        }
    }
}
