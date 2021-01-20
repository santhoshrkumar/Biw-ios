//
//  DashboardViewController.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/2/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
import RxDataSources
/*
DashboardViewController to show Dashboard
*/
class DashboardViewController: UIViewController, Storyboardable {
    
    /// Outlets
    @IBOutlet private var tableView: UITableView!
    
    /// Holds DashboardViewModel with strong reference
    var viewModel: DashboardViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindInitials()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindDataSource()
        viewModel.getNetworkDetails()
        viewModel.getServiceAppoinment()
        viewModel.addCheckForArrivalTimeAndAddTime()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// Shows the loader view
    func showLoaderView() {
        self.view.showLoaderView(with: Constants.Common.loading)
    }
    
    /// Initial setup for the tableview
    private func bindInitials() {
        // Adds some padding at the bottom so the last row does not go behind the support button
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 75, right: 0)
        tableView.contentInset = insets
        tableView.backgroundColor = UIColor.BiWFColors.lavender.withAlphaComponent(0.06)
        tableView.delegate = nil
        tableView.estimatedRowHeight = Constants.DashboardTableView.estimatedRowHeight
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        registerCells()
    }
    
    /// Registers all the tableview cells into table
    private func registerCells() {
        tableView.register(UINib(nibName: InstallationScheduledCell.identifier, bundle: nil), forCellReuseIdentifier: InstallationScheduledCell.identifier)
        tableView.register(UINib(nibName: WelcomeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: WelcomeTableViewCell.identifier)
        tableView.register(UINib(nibName: InRouteTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: InRouteTableViewCell.identifier)
        tableView.register(UINib(nibName: InstallationCompletedTableViewCell.identifier,  bundle: nil), forCellReuseIdentifier: InstallationCompletedTableViewCell.identifier)
        tableView.register(UINib(nibName: AppointmentCancelledTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: AppointmentCancelledTableViewCell.identifier)
        
        tableView.register(UINib(nibName: ConnectedDevicesCell.identifier, bundle: nil), forCellReuseIdentifier: ConnectedDevicesCell.identifier)
        //TODO: For now hidding notification functionality as will be implementated in future.
        tableView.register(DashboardNotificationsCell.self, forCellReuseIdentifier: DashboardNotificationsCell.identifier)
        tableView.register(UINib(nibName: DashboardNetworkCell.identifier, bundle: nil), forCellReuseIdentifier: DashboardNetworkCell.identifier)
        tableView.register(UINib(nibName: WiFiNetworkCell.identifier, bundle: nil), forCellReuseIdentifier: WiFiNetworkCell.identifier)
        tableView.register(UINib(nibName: NetworkInfoCardCell.identifier, bundle: nil), forCellReuseIdentifier: NetworkInfoCardCell.identifier)
    }
    
    /// Binding tableview data source
    private func bindDataSource() {
        if tableView.dataSource == nil {
            viewModel.sections.asObserver()
                .bind(to: tableView.rx.items(dataSource: dataSource()))
                .disposed(by: disposeBag)
        }
    }
    
    /// Alert to show cancellation of appointment
    private func showCancelAppointmentAlert() {
        self.showAlert(with: Constants.NewUserDashboard.cancelAppointmentConfirmationTitle,
                       message: "",
                       leftButtonTitle: Constants.NewUserDashboard.keepIt,
                       rightButtonTitle: Constants.NewUserDashboard.cancelIt,
                       rightButtonStyle: .cancel,
                       rightButtonDidTap: {[weak self] in
                        self?.viewModel.commonDashboardViewModel.input.cancelAppointmentObserver.onNext(())
        })
    }
    
    /// Shows error on perticular appointment
    private func showCancelAppointmentError(with errorMsg: String) {
        let alert = SingleButtonAlert.init(title: Constants.NewUserDashboard.cancelAppointment,
                                           message: errorMsg,
                                           action: AlertAction(buttonTitle: Constants.Common.ok,
                                                               handler: nil))
        self.presentSingleAlert(alert: alert)
    }

    /// This will show error alert
    private func showErrorAlert(isForEnable enable: Bool, forInterface interface: String) {
        self.showAlert(with: Constants.Common.errorDisabling,
                       message: Constants.Common.pleaseTryAgainLater,
                       leftButtonTitle: Constants.Common.cancel.capitalized,
                       rightButtonTitle: Constants.Common.retry,
                       rightButtonStyle: .cancel,
                       leftButtonDidTap: { }) {[weak self] in
            if enable {
                self?.viewModel.enableNetwork(forInterface: interface)
            } else {
                self?.viewModel.disableNetwork(forInterface: interface)
            }
        }
    }

}

/// DashboardViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension DashboardViewController: Bindable {
    func bindViewModel() {
        bindInputs()
        bindOutputs()
    }
    
    /// Binding all the input  observers from viewmodel to get the events
    private func bindInputs() {
        tableView.rx.itemSelected.filter { indexPath in
            return self.getSelectedCellIndex(with: indexPath) == SectionType.connectedDevices.rawValue
        }.map { _ in return () }
            .bind(to: viewModel.input.connectedDevicesSelectedObserver)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.filter { indexPath in
            return self.getSelectedCellIndex(with: indexPath) == SectionType.wifiInfo.rawValue
        }.map { _ in return (self.viewModel.myNetwork, self.viewModel.guestNetwork, self.viewModel.bssidInfo) }
            .subscribe(onNext: { [weak self] (myNetwork, guestNetwork, bssidInfo) in
                guard let self = self else { return }
                ///Checking whether all network informations is loaded or not else showing alert.
                if(!myNetwork.name.isEmpty && !myNetwork.password.isEmpty && !guestNetwork.name.isEmpty && !guestNetwork.password.isEmpty) {
                    self.viewModel.input.networkSelectedObserver.onNext((myNetwork, guestNetwork, bssidInfo))
                } else {
                    self.viewModel.showRetryAlertSubject.onNext(())
                }
            }).disposed(by: disposeBag)
    }
    
    /// Binding all the output observers from viewmodel to get the values
    private func bindOutputs() {
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
        viewModel.commonDashboardViewModel.output.showCancelAppointmentAlertObservable
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.showCancelAppointmentAlert()
            }).disposed(by: disposeBag)
        
        ///Show error alert with retry and cancel
        viewModel.showErrorAlertSubject.subscribe(onNext: { [weak self] (forEnable, interface) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showErrorAlert(isForEnable: forEnable, forInterface: interface)
            }
        }).disposed(by: disposeBag)
        
        ///This will show or hide indicator view.
        viewModel.output.indicatorViewObservable.subscribe(onNext: { [weak self] shouldShow in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch shouldShow {
                case true:
                    self.view.showIndicatorView(withTitleText: self.viewModel.isEnableWifiNetwork ? Constants.IndicatorView.enablingWiFiNetwork : Constants.IndicatorView.disablingWiFiNetwork,
                                                messageText: Constants.IndicatorView.disableNetworkAlertMessage)
                case false:
                    self.view.removeSubView()
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func getSelectedCellIndex(with indexPath: IndexPath) -> Int {
        let cell = tableView.cellForRow(at: indexPath)
        return cell?.tag ?? 0
    }
}
