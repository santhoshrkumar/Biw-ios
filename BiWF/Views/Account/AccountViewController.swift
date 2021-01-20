//
//  AccountViewController.swift
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
import LocalAuthentication
import FirebaseAnalytics
/*
 AccountViewController contains full account information about user
 */
class AccountViewController: UIViewController, Storyboardable {
    
    /// Outlets
    @IBOutlet weak var tableView: UITableView!
    
    /// Holds the AccountViewModel with a strong reference
    var viewModel: AccountViewModel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoaderView()
        bindInitials()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindDataSource()
        AnalyticsEvents.trackScreenVisitEvent(with: AnalyticsConstants.EventScreenName.account)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// Used to bind the tableview delegates
    private func bindInitials() {
        tableView.delegate = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        registerNib()
    }
    
    /// Used to register all the tableview cell to which are part of AccountviewController
    private func registerNib() {
        tableView.register(UINib(nibName: AccountOwnerDetailsCell.identifier, bundle: nil),
                           forCellReuseIdentifier: AccountOwnerDetailsCell.identifier)
        tableView.register(UINib(nibName: PaymentInfoCell.identifier, bundle: nil),
                           forCellReuseIdentifier: PaymentInfoCell.identifier)
        tableView.register(UINib(nibName: PersonalInfoCell.identifier, bundle: nil),
                           forCellReuseIdentifier: PersonalInfoCell.identifier)
        tableView.register(UINib(nibName: PreferenceAndSettingsCell.identifier, bundle: nil),
                           forCellReuseIdentifier: PreferenceAndSettingsCell.identifier)
        tableView.register(UINib(nibName: LogoutCell.identifier, bundle: nil), forCellReuseIdentifier: LogoutCell.identifier)
    }
    
    /// Used to bind the tableview datasource
    private func bindDataSource() {
        if tableView.dataSource == nil {
            viewModel.sections.asObserver()
                .bind(to: tableView.rx.items(dataSource: dataSource()))
                .disposed(by: disposeBag)
        }
        if !viewModel.isErrorState {
            updateSections()
        }
        viewModel.updateContactNumber()
    }
    
    /// Shows the loading option to the user
    func showLoaderView() {
        self.view.showLoaderView(with: Constants.Common.loading)
    }
}

/// AccountViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension AccountViewController: Bindable {
    func bindViewModel() {
        bindActions()
    }
    
    /// Updates the tableview section
    func updateSections() {
        viewModel.setSections()
    }
    
    /// selects the perticular item from tableview
    private func bindActions() {
        guard let cellSelectionObserver = self.viewModel?.input.cellSelectionObserver else {
            return
        }
        /// Tableview item selected binding with cellSelectionObserver
        tableView.rx.itemSelected
            .subscribe(cellSelectionObserver).disposed(by: disposeBag)
        
        viewModel.output.viewStatusObservable.subscribe(onNext: { [weak self] viewStatus in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch viewStatus{
                    /// case execute if the loaderview is still loading
                case .loading(_):
                    self.showLoaderView()
                    
                    ///  case execute once the loaderview is completly loaded
                case .loaded:
                    self.view.removeSubView()
                    
                    /// case execute when there is some problem on loaderview to get load
                    /// - Parameter errorMsg: to show the error message why it hasn't loaded
                    /// retryButtonHandler : to retry again the loaderview
                case .error(errorMsg: let errorMsg, retryButtonHandler: let retryButtonHandler):
                    self.view.showErrorView(with: errorMsg, reloadHandler: retryButtonHandler)
                }
            }
        }).disposed(by: disposeBag)
    }
}
