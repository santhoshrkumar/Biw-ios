//
//  StatementDetailViewController.swift
//  BiWF
//
//  Created by pooja.q.gupta on 11/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
import RxDataSources
/*
 StatementDetailViewController to show Payment statement
 */
class StatementDetailViewController: UIViewController, Storyboardable {
    
    /// Outlets
    @IBOutlet weak var tableView: UITableView!
    
    /// Bar buttons
    var doneButton: UIBarButtonItem!
    var backButton: UIBarButtonItem!
    
    /// Constants/Variables
    var viewModel: StatementDetailViewModel!
    let disposeBag = DisposeBag()
    let dataSource = StatementDetailViewController.dataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        bindInitials()
        showLoaderView()
        AnalyticsEvents.trackScreenVisitEvent(with: AnalyticsConstants.EventScreenName.statement)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindDataSource()
    }
    
    /// Used to bind the tableview delegates
    private func bindInitials() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.PaymentBreakdown.cellEstimatedHeight
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }
    
    /// Used to bind the tableview datasource
    private func bindDataSource() {
        if tableView.dataSource == nil {
            viewModel.sections.asObserver()
                .bind(to: tableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        }
    }
    
    //MARK:- Navigation bar setup
    func setNavigationBar() {
        self.title = Constants.StatementDetail.statement
        setBackButton()
        setDoneButton()
    }
    
    /// Backutton setup
    func setBackButton() {
        backButton = UIBarButtonItem.init(image: UIImage.init(named: Constants.Common.backButtonImageName),
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        backButton.defaultSetup()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    /// Donebutton setup
    func setDoneButton() {
        doneButton = UIBarButtonItem.init(title: Constants.Common.done,
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        doneButton.defaultSetup()
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    /// Shows the loading option to the user
    func showLoaderView() {
        self.view.showLoaderView(with: Constants.Common.loading)
    }
}

//MARK:- Bindable
/// StatementDetailViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension StatementDetailViewController: Bindable {
    func bindViewModel() {
        bindInputs()
    }
    
    /// Binding all the input observers from viewmodel to get the events
    func bindInputs() {
        doneButton.rx.tap.bind(onNext: {[weak self] _ in
            AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.statementDone)
            self?.viewModel.input.doneTapObserver.onNext(())
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.bind(onNext: {[weak self] _ in
            AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.statementBack)
            self?.viewModel.input.backTapObserver.onNext(())
        }).disposed(by: disposeBag)
        
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
