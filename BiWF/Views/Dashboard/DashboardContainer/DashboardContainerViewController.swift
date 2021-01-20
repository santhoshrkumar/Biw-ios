//
//  DashboardContainerViewController.swift
//  BiWF
//
//  Created by pooja.q.gupta on 27/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/*
 DashboardContainerViewController to show contents on Dashboard
 */
class DashboardContainerViewController: UIViewController, Storyboardable {
    
    /// Holds DashboardContainerViewModel with strong reference
    var viewModel: DashboardContainerViewModel!
    private let disposeBag = DisposeBag()
    
    var newUserDashboardViewController: NewUserDashboardViewController = NewUserDashboardViewController.instantiate(fromStoryboardNamed: "NewUserDashboard")
    var dashboardViewController: DashboardViewController = DashboardViewController.instantiate(fromStoryboardNamed: String(describing: DashboardViewController.self))

    private var embeddedViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.BiWFColors.light_lavender
        showLoaderView()
    }

    override var childForStatusBarStyle: UIViewController? {
        return embeddedViewController
    }
    
    /// Adds contents to the view controller
    private func addContentController(_ child: UIViewController) {
        child.view.frame = self.view.frame
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)

        embeddedViewController = child
        setNeedsStatusBarAppearanceUpdate()
    }
    
    /// Removes the currenct child
    private func removeCurrentChild() {
        guard let child = children.first else { return }
        child.removeFromParent()
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()

        embeddedViewController = nil
    }
    
    ///Removes the child and displays Dashboard controller
    func displayDashboard() {
        removeCurrentChild()
        addContentController(dashboardViewController)
    }
    
    ///Removes the child and displays  New Dashboard controller
    func displayNewUserDashboard() {
        removeCurrentChild()
        addContentController(newUserDashboardViewController)
    }
    
    /// Shows the loader view
    func showLoaderView() {
        self.view.showLoaderView(with: Constants.Common.loading)
    }
}

/// DashboardContainerViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension DashboardContainerViewController: Bindable {
    
    /// Binding all the input and output observers from viewmodel to get the events and values
    func bindViewModel() {
        viewModel.output.dashboardViewModelObservable.subscribe(onNext: { [weak self] dashboardViewModel in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.dashboardViewController.setViewModel(to: dashboardViewModel)
            }
        }).disposed(by: disposeBag)
        
        viewModel.output.newUserDashboaedViewModelObservable.subscribe(onNext: { [weak self] newUserDashboradViewModel in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.newUserDashboardViewController.setViewModel(to: newUserDashboradViewModel)
            }
        }).disposed(by: disposeBag)
        
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
