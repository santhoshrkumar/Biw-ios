//
//  ViewController.swift
//  BiWF
//
//  Created by pooja.q.gupta on 27/03/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
import RxDataSources
/*
 NewUserDashboardViewController to show new user on dashboard
 */
class NewUserDashboardViewController: UIViewController, Storyboardable {
    @IBOutlet weak var tableView: UITableView!
    
    /// Holds NewUserDashboardViewModel with strong reference
    var viewModel: CommonDashboardViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindInitials()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindDataSource()
        viewModel.getServiceAppointment()
        viewModel.checkForArrivalTimeAndAddTimer()
    }
    
    /// Initial tableview setup
    private func bindInitials() {
        tableView.delegate = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.NewUserDashboard.estimatedRowHeight
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        registerCells()
    }
    
    /// Register all the table cells into table
    private func registerCells() {
        tableView.register(UINib(nibName: InRouteTableViewCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: InRouteTableViewCell.identifier)
        tableView.register(UINib(nibName: InstallationCompletedTableViewCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: InstallationCompletedTableViewCell.identifier)
        tableView.register(UINib(nibName: AppointmentCancelledTableViewCell.identifier,
                                 bundle: nil),
                           forCellReuseIdentifier: AppointmentCancelledTableViewCell.identifier)
    }
    
    /// Alert to show cancellation of appointment
    private func showCancelAppointmentAlert() {
        self.showAlert(with: Constants.NewUserDashboard.cancelAppointmentConfirmationTitle,
                       message: Constants.NewUserDashboard.cancelAppointmentAlertDescription,
                       leftButtonTitle: Constants.NewUserDashboard.keepIt,
                       rightButtonTitle: Constants.NewUserDashboard.cancelIt,
                       rightButtonStyle: .cancel,
                       rightButtonDidTap: {[weak self] in
                        self?.viewModel.input.cancelAppointmentObserver.onNext(())
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
}

//MARK: - Bindable
/// NewUserDashboardViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension NewUserDashboardViewController: Bindable {
    
    /// Binding all the input and output observers from viewmodel to get the events and values
    func bindViewModel() {
        
        viewModel.output.showCancelAppointmentAlertObservable
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.showCancelAppointmentAlert()
            }).disposed(by: disposeBag)
        
        viewModel.output.viewStatusObservable.subscribe(onNext: { [weak self] viewStatus in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch viewStatus{
                case .loading(let loadingText):
                    self.view.showLoaderView(with: loadingText)
                    
                case .loaded:
                    self.view.removeSubView()
                    
                case .error(errorMsg: let errorMsg, retryButtonHandler: _):
                    self.view.removeSubView()
                    self.showCancelAppointmentError(with: errorMsg ?? Constants.Common.anErrorOccurred)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    /// Binding all the table data sources
    func bindDataSource() {
        if tableView.dataSource == nil {
            viewModel.sections.asObserver()
                .bind(to: tableView.rx.items(dataSource: dataSource()))
                .disposed(by: disposeBag)
        }
    }
}


