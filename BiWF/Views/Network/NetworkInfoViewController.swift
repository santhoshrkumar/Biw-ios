//
//  NetworkViewController.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 6/25/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
import RxDataSources

/*
 NetworkInfoViewController to show network information of my network and guest network
 **/
class NetworkInfoViewController: UIViewController, Storyboardable {
    
    /// Outlets
    @IBOutlet private var tableView: UITableView!
    
    /// Constants/Variables
    var viewModel: NetworkInfoViewModel!
    private var doneButton: UIBarButtonItem!
    private let disposeBag = DisposeBag()
        
    // MARK: View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bindInitials()
        setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindDataSource()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        hideKeyboard()
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Initial UI setup
    private func bindInitials() {
        tableView.backgroundColor = UIColor.BiWFColors.white
        tableView.delegate = nil
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.NetworkInfo.rowHeight
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        registerCells()
    }
    
    private func setNavigationBar() {
        self.title = Constants.NetworkInfo.networkInformation
        doneButton = UIBarButtonItem.init(title: Constants.Common.done,
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        doneButton.defaultSetup()
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    /// This will register cell
    private func registerCells() {
        tableView.register(OnlineStatusCell.self, forCellReuseIdentifier: OnlineStatusCell.identifier)
    }
    
    /// binding viewmodel to the tableview
    private func bindDataSource() {
        if tableView.dataSource == nil {
            viewModel.sections.asObserver()
                .bind(to: tableView.rx.items(dataSource: dataSource()))
                .disposed(by: disposeBag)
        }
    }
    
    /// This will show save changes confirmation alert
    private func showSaveChangesAlert() {
        self.showAlert(with: Constants.Common.wantToSaveChanges,
                       message: "",
                       leftButtonTitle: Constants.Common.discard,
                       rightButtonTitle: Constants.Common.save,
                       rightButtonStyle: .cancel,
                       leftButtonDidTap: {[weak self] in
                        self?.viewModel.input.doneObserver.onNext(())
                       }) {[weak self] in
            self?.viewModel.input.saveChangesTapObserver.onNext(())
        }
    }
    
    /// This will show error alert
    private func showErrorAlert(isForEnable enable: Bool, forInterface interface: String) {
        self.showAlert(with: Constants.Common.errorDisabling,
                       message: Constants.Common.pleaseTryAgainLater,
                       leftButtonTitle: Constants.Common.cancel.capitalized,
                       rightButtonTitle: Constants.Common.retry,
                       rightButtonStyle: .default,
                       leftButtonDidTap: { }) {[weak self] in
            if enable {
                self?.viewModel.enableNetwork(forInterface: interface)
            } else {
                self?.viewModel.disableNetwork(forInterface: interface)
            }
        }
    }
}

/// Network info ViewController Extension confirm Bindable protocol. This is provide a standard interface to all it's internal elements to be bound to a view model
extension NetworkInfoViewController: Bindable {
    func bindViewModel() {
        
        doneButton.rx.tap.subscribe({[weak self] _ in
            guard let self = self else {return}
            self.hideKeyboard()
            if self.viewModel.validateFields() {
                if self.viewModel.shouldShowSaveChangesAlert() {
                    self.showSaveChangesAlert()
                } else {
                    self.viewModel.input.doneObserver.onNext(())
                }
            }
        }).disposed(by: disposeBag)
        
        viewModel.output.setInsetObservable
            .subscribe(onNext: {[weak self] (inset) in
                self?.tableView.contentInset = inset
            }).disposed(by: disposeBag)
        
        ///This will show or hide loading indicator and error depends on view status.
        viewModel.output.viewStatusObservable.subscribe(onNext: { [weak self] viewStatus in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch viewStatus{
                case .loading( let loadingText):
                    self.view.showLoaderView(with: loadingText)
                    
                case .loaded:
                    self.view.removeSubView()
                    
                case .error(errorMsg: _, retryButtonHandler: _):
                    self.view.removeSubView()
                    self.viewModel.errorSavingChangesSubject.onNext(())
                }
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
        
        ///Show error alert with retry and cancel
        viewModel.showErrorAlertSubject.subscribe(onNext: { [weak self] (forEnable, interface) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showErrorAlert(isForEnable: forEnable, forInterface: interface)
            }
        }).disposed(by: disposeBag)
    }
}
