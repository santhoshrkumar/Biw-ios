//
//  ScheduleCallbackViewController.swift
//  BiWF
//
//  Created by pooja.q.gupta on 30/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
import RxDataSources
/*
 ScheduleCallbackViewController to the user to shcedule a call
 */
class ScheduleCallbackViewController: UIViewController, Storyboardable {
    
    /// Outlet
    @IBOutlet weak var tableView: UITableView!
    
    /// Bar buttons
    var cancelButton: UIBarButtonItem!
    var backButton: UIBarButtonItem!
    
    /// Holds the ScheduleCallbackViewModel with strong reference
    var viewModel: ScheduleCallbackViewModel!
    
    let disposeBag = DisposeBag()
    let dataSource = ScheduleCallbackViewController.dataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        AnalyticsEvents.trackScreenVisitEvent(with: AnalyticsConstants.EventScreenName.scheduleCallbackSupport)
        showLoaderView()
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
    
    /// Binding all the tableview values
    private func bindInitials() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor.BiWFColors.light_grey
        tableView.tableFooterView = UIView()
        tableView.delegate = nil
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        self.tableView.estimatedSectionHeaderHeight = Constants.ScheduleCallback.callUsNowHeaderHeight;
        registerCells()
    }
    
    /// Registers the xib files into tableview 
    private func registerCells() {
        tableView.register(
            UINib(nibName: TitleTableViewCell.identifier,
                  bundle: nil),
            forCellReuseIdentifier: TitleTableViewCell.identifier)
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
    
    //MARK:- Navigation bar setup
    func setNavigationBar() {
        self.title = Constants.ScheduleCallback.scheduleCallback
        setBackButton()
        setCancelButton()
    }
    
    /// Backbutton setup
    func setBackButton() {
        backButton = UIBarButtonItem.init(image: UIImage.init(named: Constants.Common.backButtonImageName),
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        backButton.defaultSetup()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    /// Cancelbutton setup
    func setCancelButton() {
        cancelButton = UIBarButtonItem.init(title: Constants.Common.done,
                                            style: .plain,
                                            target: nil,
                                            action: nil)
        cancelButton.defaultSetup()
        self.navigationItem.rightBarButtonItem = cancelButton
    }
}

//MARK:- Bindable
/// ScheduleCallbackViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension ScheduleCallbackViewController: Bindable {
    func bindViewModel() {
        bindInputs()
        bindOutputs()
    }
    
    /// Binding all the input observers from viewmodel to get the events
    func bindInputs() {
        cancelButton.rx.tap
            .bind(onNext: {[weak self] _ in
                AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.cancelScheduleCallback)
                self?.viewModel.input.cancelTapObserver.onNext(())
            })
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind(onNext: {[weak self] _ in
                AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.backScheduleCallback)
                self?.viewModel.input.backTapObserver.onNext(())
            })
            .disposed(by: disposeBag)
        
        /// Tableview item selected binding with cellSelectionObserver
        tableView.rx.itemSelected
            .subscribe(viewModel.input.cellSelectionObserver)
            .disposed(by: disposeBag)
    }
    
    /// Binding all the output drivers from viewmodel to get the values
    func bindOutputs() {
        viewModel.output.callUsNowObservable.subscribe(onNext: {[weak self] _ in
            AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.callUsNowScheduleCallback)
            self?.openUrl(with: "tel:\(Constants.Common.biwfServiceNumber)")
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
