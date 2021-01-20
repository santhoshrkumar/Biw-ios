//
//  SubscriptionViewController.swift
//  BiWF
//
//  Created by pooja.q.gupta on 06/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/*
 SubscriptionViewController to show details about Subscription
 */
class SubscriptionViewController: UIViewController, Storyboardable {
    
    /// Outlets
    @IBOutlet weak var tableView: UITableView!
    
    /// Bar buttons
    var doneButton: UIBarButtonItem!
    
    /// Variables/Constants
    var viewModel: SubscriptionViewModel!
    private let disposeBag = DisposeBag()
    let dataSource = SubscriptionViewController.dataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        showLoaderView()
        AnalyticsEvents.trackScreenVisitEvent(with: AnalyticsConstants.EventScreenName.subscription)
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindInitials()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bindDataSource()
    }
    
    /// Shows the loading option to the user
    func showLoaderView() {
        self.view.showLoaderView(with: Constants.Common.loading)
    }
    
    /// Used to bind the tableview delegates
    private func bindInitials() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.delegate = nil
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        registerCells()
    }
    
    /// Registers the xib's into table
    private func registerCells() {
        tableView.register(
            UINib(nibName: TitleTableViewCell.identifier,
                  bundle: nil),
            forCellReuseIdentifier: TitleTableViewCell.identifier)
        tableView.register(
            UINib(nibName: TitleHeaderview.identifier,
                  bundle: nil),
            forHeaderFooterViewReuseIdentifier: TitleHeaderview.identifier)
        tableView.register(
            UINib(nibName: EditPaymentDetailsCell.identifier,
                  bundle: nil),
            forCellReuseIdentifier: EditPaymentDetailsCell.identifier)
    }
    
    private func bindDataSource() {
        if tableView.dataSource == nil {
            viewModel.sections.asObserver()
                .bind(to: tableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        }
    }
    
    //MARK: - Navigation bar setup
    func setNavigationBar() {
        self.title = Constants.Subscription.subscription
        setDoneButton()
    }
    
    /// Done button setup
    func setDoneButton() {
        doneButton = UIBarButtonItem.init(title: Constants.Common.done,
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        doneButton.defaultSetup()
        self.navigationItem.rightBarButtonItem = doneButton
    }
}

/// SubscriptionViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension SubscriptionViewController: Bindable {
    func bindViewModel() {
        bindInputs()
        bindOutputs()
    }
    
    /// Binding all the input observers from viewmodel to get the events
    func bindInputs() {
        doneButton.rx.tap.bind(onNext: {[weak self] _ in
            AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.subscriptionDone)
            self?.viewModel.input.doneTapObserver.onNext(())
        }).disposed(by: disposeBag)
        
        /// Tableview item selected binding with cellSelectionObserver
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
