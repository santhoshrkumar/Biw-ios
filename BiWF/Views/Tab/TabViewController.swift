//
//  TabViewController.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/5/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
/*
 TabViewController to show tabs to the user
 */
class TabViewController: UIViewController {
    
    /// Constants
    private let containerView = UIScrollView()
    private let accountNavController: UINavigationController
    private let dashboardNavController: UINavigationController
    private let deviceNavController: UINavigationController
    
    /// Holds TabHeaderView with strong reference
    var header: TabHeaderView!
    /// Holds SupportButton with strong reference
    var supportButton: SupportButton!
    
    /// Holds TabViewModel with strong reference
    var viewModel: TabViewModel!
    var isAuthenticatingForFirstTime: Bool = true
    var tabViews = [UINavigationController]()
    
    private var embeddedViewController: UIViewController?
    
    /// Initializes a new instance of UINavigationControllers
    /// - Parameter accountNavController : Navigates to account viewcontroller
    ///dashboardNavController : Navigates to dashboard viewcontroller
    ///deviceNavController : Navigates to device viewcontroller
    init(accountNavController: UINavigationController, dashboardNavController: UINavigationController, deviceNavController: UINavigationController) {
        self.accountNavController = accountNavController
        self.dashboardNavController = dashboardNavController
        self.deviceNavController = deviceNavController
        super.init(nibName: nil, bundle: nil)
        
        tabViews.append(accountNavController)
        tabViews.append(dashboardNavController)
        
        header = TabHeaderView.createFromNib()
        header.addTo(self)
        
        setupContainerView()
        setupStatusBar()
        
        supportButton = SupportButton()
        supportButton.addTo(self)
        
        showTab(.dashboard)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return embeddedViewController
    }
    
    /// Container view setup
    private func setupContainerView() {
        view.addSubview(containerView)
        containerView.delegate = self
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        containerView.isPagingEnabled = true
        setupScrollView()
    }
    
    /// Status bar setup
    private func setupStatusBar() {
        let statusBarView = UIView()
        view.addSubview(statusBarView)
        statusBarView.translatesAutoresizingMaskIntoConstraints = false
        statusBarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        statusBarView.bottomAnchor.constraint(equalTo: header.topAnchor).isActive = true
        statusBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        statusBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        statusBarView.backgroundColor = UIColor.BiWFColors.purple
    }
    
    /// Show tabs
    func showTab(_ selectedTab: TabViewModel.Tabs) {
        
        var contentOffsetX: CGFloat = 0
        view.backgroundColor = UIColor.BiWFColors.light_lavender
        var childViewController: UINavigationController?
        
        switch selectedTab {
        /// Displays account screen
        case .account:
            childViewController = accountNavController
        /// Displays dashboard screen
        case .dashboard:
            childViewController = dashboardNavController
            contentOffsetX = CGFloat(tabViews[TabViewModel.Tabs.dashboard.rawValue].view.frame.origin.x)
        /// Displays device screen
        case .device:
            childViewController = deviceNavController
            view.backgroundColor = UIColor.BiWFColors.white
            contentOffsetX = CGFloat(tabViews[TabViewModel.Tabs.device.rawValue].view.frame.origin.x)
        }
        if let childController = childViewController {
            display(child: childController)
        }
        containerView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: true)
    }
    
    /// Display the perticular viewcontroller by removing the current child
    /// - Parameter child : vewcontroller that is to be removed
    private func display(child: UIViewController) {
        embeddedViewController = child
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showWelcomeBiometricAlert()
    }
    
    /// Shows biometric alert
    func showWelcomeBiometricAlert() {
        if Biometrics.showWelcomeAlert() {
            showAlert(with: Constants.Biometric.welcomeAlertTitle,
                      message: viewModel.biometricTypeString,
                      leftButtonTitle: Constants.PersonalInformation.buttonText,
                      rightButtonTitle: Constants.Biometric.welcomeRightButtonTitle,
                      rightButtonStyle: .cancel,
                      leftButtonDidTap: {[weak self] in
                        guard let self = self else { return }
                        self.viewModel.checkBiometricAuthSubject.onNext(())
                      })
        } else if (Biometrics.isBiometricEnabled() && isAuthenticatingForFirstTime) {
            self.viewModel.checkBiometricAuthSubject.onNext(())
            isAuthenticatingForFirstTime = false
        }
    }

    /// Show Devices Tab
    /// - Parameter shouldShown : whether to show/not device tab
    internal func showDevicesTab(_ shouldShown: Bool) {
        header.showDevicesTab(shouldShown)
        if shouldShown {
            if tabViews.count < Constants.Tab.totalNumberOfTabs {
                tabViews.append(deviceNavController)
                containerView.subviews.forEach({ $0.removeFromSuperview() })
                setupScrollView()
            }
        }
    }
}

/// TabViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension TabViewController: Bindable {
    
    /// Binding all the input and output observers from viewmodel to get the events and values
    func bindViewModel() {
        viewModel.output.headerViewModelObservable.subscribe(onNext: { [weak self] headerViewModel in
            guard let self = self else { return }
            self.header.setViewModel(to: headerViewModel)
            self.header.showDevicesTab(false) //Initially hide the devices tab
        }).dispose()
        
        viewModel.output.supportButtonViewModelObservable.subscribe(onNext: { [weak self] supportButtonViewModel in
            guard let self = self else { return }
            self.supportButton.setViewModel(to: supportButtonViewModel)
        }).dispose()
    }
}

/// TabViewController extension for scrollview methids
extension TabViewController: UIScrollViewDelegate {

    /// scrollViewDidEndDecelerating delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if containerView.contentOffset.x == 0 {
            header.viewModel.input.accountTapObserver.onNext(())
        } else if containerView.contentOffset.x == CGFloat(tabViews[TabViewModel.Tabs.dashboard.rawValue].view.frame.origin.x) {
            header.viewModel.input.dashboardTapObserver.onNext(())
        } else if tabViews.count == Constants.Tab.totalNumberOfTabs {
            if containerView.contentOffset.x == CGFloat(tabViews[TabViewModel.Tabs.device.rawValue].view.frame.origin.x) {
               header.viewModel.input.devicesTapObserver.onNext(())
           }
        }
    }

    /// Setting up scrollview
    func setupScrollView() {
        containerView.frame = tabViews[TabViewModel.Tabs.account.rawValue].view.frame
        containerView.contentSize = CGSize(width: CGFloat(tabViews.count) * UIScreen.main.bounds.width, height: 0)
        containerView.delegate = self
        _ = tabViews.map({ addViewToScrollView($0) })
        _ = tabViews.map({ $0.view.frame.origin =  CGPoint(x: CGFloat(tabViews.firstIndex(of: $0)!) * UIScreen.main.bounds.width, y: 0) })
    }
    
    /// Add tab views in scrollview
    /// - Parameter viewController : viewcontroller that needs to be added
    func addViewToScrollView(_ viewController: UIViewController) {
        containerView.addSubview(viewController.view)
        viewController.willMove(toParent: self)
        addChild(viewController)
    }
}
