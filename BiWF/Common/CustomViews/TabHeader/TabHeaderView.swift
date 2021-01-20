//
//  TabHeaderView.swift
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
    TabHeaderView is custom view showing on dashobard
**/
class TabHeaderView: UIView {
    // MARK: Outlet
    @IBOutlet private var accountButton: UIButton!
    @IBOutlet private var dashboardButton: UIButton!
    @IBOutlet private var devicesButton: UIButton!
    @IBOutlet private var notificationButton: UIButton!
    @IBOutlet private var statusView: UIView!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var statusIndicatorView: UIView!
    @IBOutlet private var tabContainerView: UIView!
    @IBOutlet private var notificationBadgeView: UIView!
    @IBOutlet private var notificationBadgeLabel: UILabel!
    @IBOutlet private var statusVerticalSpacingConstraint: NSLayoutConstraint!
    @IBOutlet private var notificationCenterYAlignmentConstraint: NSLayoutConstraint!
    @IBOutlet private var tabContainerViewTrailingConstraint: NSLayoutConstraint!
    
    // MARK: Variables
    private var newUserNotificationCenterYAlignmentConstraint: NSLayoutConstraint {
        let constraint = notificationButton.centerYAnchor.constraint(equalTo: tabContainerView.centerYAnchor)
        constraint.priority = UILayoutPriority(999)
        return constraint
    }

    var viewModel: TabHeaderViewModel!
    let disposeBag = DisposeBag()
    
    /// Create TabHeaderView object from xib view
    ///- returns: TabHeaderView view object
    static func createFromNib() -> TabHeaderView {
        let nib = UINib(nibName: String(describing: TabHeaderView.self), bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! TabHeaderView
    }
    
    ///Adding contarints to view
    ///- Parameters:
    ///     - superView: super is view where need to add TabHeaderView view
    private func addSelfConstraints(with superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    internal func addTo(_ viewController: UIViewController) {
        viewController.view.addSubview(self)
        addSelfConstraints(with: viewController.view)
    }
    
    internal func showDevicesTab(_ isShown: Bool) {
        viewModel.showDevicesTabSubject.onNext((isShown))
    }
}

/// TabHeaderView extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension TabHeaderView: Bindable {
    
    ///Binding view model to SpeedTestView to handle event and UI data
    func bindViewModel() {
        bindInputs()
        bindOutputs()
        //TODO: For now hidding notification functionality as will be implementated in future.
        notificationButton.isHidden = true
        notificationBadgeView.isHidden = true
    }
    
    /// Binding all the input observers from viewmodel to get the events
    private func bindInputs() {
        accountButton.rx.tap
            .bind(to: viewModel.input.accountTapObserver)
            .disposed(by: disposeBag)
        
        dashboardButton.rx.tap
            .bind(to: viewModel.input.dashboardTapObserver)
            .disposed(by: disposeBag)
        
        devicesButton.rx.tap
            .bind(to: viewModel.input.devicesTapObserver)
            .disposed(by: disposeBag)
        
        notificationButton.rx.tap
            .bind(to: viewModel.input.notificationTapObserver)
            .disposed(by: disposeBag)
    }
    
    /// Binding all the output from viewmodel to get the values
    private func bindOutputs() {
        bindText()
        bindButtonFont()
        bindButtonBackgroundColor()
        
        viewModel.output.showDevicesTabObservable
            .subscribe(onNext: {[weak self] showDevicesTab in
                self?.statusView.isHidden = !showDevicesTab
                self?.statusVerticalSpacingConstraint.isActive = showDevicesTab
                self?.notificationCenterYAlignmentConstraint.isActive = showDevicesTab
                self?.tabContainerViewTrailingConstraint.isActive = showDevicesTab
                self?.newUserNotificationCenterYAlignmentConstraint.isActive = !showDevicesTab
            }).disposed(by: disposeBag)
        
        viewModel.output.showDevicesTabObservable.map { didShow -> Bool in
            return didShow ? false : true
        }.bind(to: devicesButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.hideNotificationBadgeObservable
            .bind(to: notificationBadgeView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.isOnlineObservable.map { isOnline -> UIColor in
            DispatchQueue.main.async {
                self.statusIndicatorView.borderWidth = isOnline ? 0.0 : 2.0
                self.statusIndicatorView.borderColor = isOnline ? UIColor.clear : UIColor.BiWFColors.white
            }
            return isOnline ? UIColor.BiWFColors.kale : UIColor.BiWFColors.strawberry
        }.bind(to: statusIndicatorView.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
    private func bindText() {
        viewModel.output.accountTitleDriver
            .drive(accountButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.output.dashboardTitleDriver
            .drive(dashboardButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.output.devicesTitleDriver
            .drive(devicesButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.output.statusTextDriver
            .drive(statusLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.notificationBadgeTextDriver
            .drive(notificationBadgeLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    /// Setting/managing font on tab(button)  change
    private func bindButtonFont() {
        viewModel.output.accountSelectedObservable.map { isSelected -> UIFont in
            return isSelected ? .bold(ofSize: 16) : .regular(ofSize: 16)
        }.subscribe(onNext: {[weak self] font in
            self?.accountButton.titleLabel?.font = font
        }).disposed(by: disposeBag)
        
        viewModel.output.dashboardSelectedObservable.map { isSelected -> UIFont in
            return isSelected ? .bold(ofSize: 16) : .regular(ofSize: 16)
        }.subscribe(onNext: {[weak self] font in
            self?.dashboardButton.titleLabel?.font = font
        }).disposed(by: disposeBag)
        
        viewModel.output.devicesSelectedObservable.map { isSelected -> UIFont in
            return isSelected ? .bold(ofSize: 16) : .regular(ofSize: 16)
        }.subscribe(onNext: {[weak self] font in
            self?.devicesButton.titleLabel?.font = font
        }).disposed(by: disposeBag)
    }
    
    /// Setting/changing background color of tab(button)  on tab change
    private func bindButtonBackgroundColor() {
        viewModel.output.accountSelectedObservable.map { isSelected -> UIColor in
            return isSelected ? UIColor.BiWFColors.purple : .clear
        }.bind(to: accountButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.output.dashboardSelectedObservable.map { isSelected -> UIColor in
            return isSelected ? UIColor.BiWFColors.purple : .clear
        }.bind(to: dashboardButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.output.devicesSelectedObservable.map { isSelected -> UIColor in
            return isSelected ? UIColor.BiWFColors.purple : .clear
        }.bind(to: devicesButton.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}
