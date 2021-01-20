//
//  ModifyAppointmentViewController.swift
//  BiWF
//
//  Created by pooja.q.gupta on 04/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/*
ModifyAppointmentViewController to modify once the appointment is modified by user
*/
class ModifyAppointmentViewController: UIViewController, Storyboardable {
    
    /// Outlets
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    /// Bar buttons
    var nextButton: UIBarButtonItem!
    var backButton: UIBarButtonItem!
    
    /// Constants/Variables
    var viewModel: ModifyAppointmentViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavbar()
        bindInitials()
        registerHeader()
        showLoaderView(with: Constants.Common.loading)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindDataSource()
    }
    
    /// Binding all the tableview values
    private func bindInitials() {
        tableView.delegate = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.ModifyAppointment.estimatedRowHeight
        tableView.tableFooterView = UIView()
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    /// To register an header in tableview
    private func registerHeader() {
        tableView.register(
            UINib(nibName: AvailableSlotHeaderView.identifier,
                  bundle: nil),
            forHeaderFooterViewReuseIdentifier: AvailableSlotHeaderView.identifier)
    }
    
    /// Binding  the table view data sources from viewmodel
    private func bindDataSource() {
        if tableView.dataSource == nil {
            viewModel.sections.asObserver()
                .bind(to: tableView.rx.items(dataSource: dataSource()))
                .disposed(by: disposeBag)
        }
    }
    
    /// NavigationBar Setup
    func setNavbar() {
        self.title = Constants.ModifyAppointment.title
        setBackButton()
        setCancelButton()
    }
    
    /// Backbutton Setup
    func setBackButton() {
        backButton = UIBarButtonItem.init(image: UIImage.init(named: Constants.Common.backButtonImageName),
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        backButton.defaultSetup()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    /// Cancel Button setup
    func setCancelButton() {
        nextButton = UIBarButtonItem.init(title: Constants.Common.next,
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        nextButton.defaultSetup()
        self.navigationItem.rightBarButtonItem = nextButton
    }
    
    /// Shows the loading option to the user with button being disabled  while loading
    /// - Parameter Loading text : text to be shown while loading
    func showLoaderView(with loadingText: String) {
        self.view.showLoaderView(with: loadingText)
        self.nextButton.isEnabled = false
    }
}

/// ModifyAppointmentViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension ModifyAppointmentViewController: Bindable {
    func bindViewModel() {
        
        bindInputs()
        bindOutputs()
    }
    
    /// Shows the loading indicator to the user
    func bindOutputs() {
        viewModel.output.viewStatusObservable.subscribe(onNext: { [weak self] viewStatus in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch viewStatus{
                    /// case execute if the loaderview is still loading
                case .loading(let loadingText):
                    self.showLoaderView(with: loadingText ?? "")
                    
                    ///  case execute once the loaderview is completly loaded
                case .loaded:
                    self.view.removeSubView()
                    self.nextButton.isEnabled = true
                    
                    /// case execute when there is some problem on loaderview to get load
                    /// - Parameter errorMsg: to show the error message why it hasn't loaded
                    /// retryButtonHandler : to retry again the loaderview
                case .error(errorMsg: let errorMsg, retryButtonHandler: let retryButtonHandler):
                    if self.viewModel.isRescheduleAppointementError {
                        self.view.removeSubView()
                        self.nextButton.isEnabled = true
                        self.viewModel.isRescheduleAppointementError = false
                    } else {
                        self.view.showErrorView(with: errorMsg, reloadHandler: retryButtonHandler)
                    }
                }
            }
        }).disposed(by: disposeBag)
        
        /// Alert presenter to show the user with appropriate title and message
        viewModel.output.showAlertObservable
            .subscribe(onNext: { message in
                DispatchQueue.main.async {
                    AlertPresenter.showCustomAlertViewController(title: Constants.ModifyAppointment.title, message: message.attributedString(), buttonText: Constants.Common.ok)
                }
            }).disposed(by: disposeBag)
    }
    
    /// Binding all the input observers from viewmodel to get the events
    func bindInputs() {
        nextButton.rx.tap.subscribe({[weak self] _ in
            guard let self = self else {return}
            
            do {
                let selectedDate = try self.viewModel.selectedDateSubject.value()
                let selectedSlot = try self.viewModel.selectedSlotSubject.value()
                
                if selectedDate != nil, selectedSlot != nil {
                    self.viewModel.input.nextTapObserver.onNext(())
                } else if selectedDate != nil,selectedSlot == nil {
                    self.viewModel.selectedSlotErrorSubject.onNext(true)
                } else {
                    let singleButtonAlert = SingleButtonAlert(title: Constants.ModifyAppointment.title,
                                                              message: Constants.ModifyAppointment.selectDateAndSlot,
                                                              action: AlertAction(buttonTitle: Constants.Common.ok,
                                                                                  handler: nil))
                    self.presentSingleAlert(alert: singleButtonAlert)
                }
            } catch {}
            
        }).disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(to: (viewModel.input.backTapObserver))
            .disposed(by: disposeBag)
    }
}
