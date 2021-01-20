//
//  DashboardNotificationsCell.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/21/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
/*
 DashboardNotificationsCell show the notification on dashboard
 */
class DashboardNotificationsCell: UITableViewCell {
    /// reuse identifier
    static let identifier = "DashboardNotificationsCell"

    private var topNotificationView = DashboardNotificationView.createFromNib()
    private var secondNotificationView = DashboardNotificationView.createFromNib()
    private var thirdNotificationView = DashboardNotificationView.createFromNib()

    /// Holds DashboardNotificationsCellViewModel with strong reference
    var viewModel: DashboardNotificationsCellViewModel!
    private let disposeBag = DisposeBag()
    
    /// Initial UI setup
    func initialSetup() {
        backgroundColor = .clear

        contentView.addSubview(topNotificationView)
        topNotificationView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        topNotificationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        topNotificationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true

        contentView.addSubview(secondNotificationView)
        contentView.sendSubviewToBack(secondNotificationView)
        secondNotificationView.bottomAnchor.constraint(equalTo: topNotificationView.bottomAnchor, constant: 8).isActive = true
        secondNotificationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28).isActive = true
        secondNotificationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28).isActive = true

        contentView.addSubview(thirdNotificationView)
        contentView.sendSubviewToBack(thirdNotificationView)
        thirdNotificationView.bottomAnchor.constraint(equalTo: secondNotificationView.bottomAnchor, constant: 8).isActive = true
        thirdNotificationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44).isActive = true
        thirdNotificationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -44).isActive = true
        
    }
}

/// DashboardNotificationsCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension DashboardNotificationsCell: Bindable {
    
    /// Binding all the output observers from viewmodel to get the  values
    func bindViewModel() {
        viewModel.output.topViewModelObservable.subscribe(onNext: { [weak self] notificationViewModel in
            guard let self = self else { return }
            guard let notificationViewModel = notificationViewModel else { return }
            self.topNotificationView.setViewModel(to: notificationViewModel)
        }).disposed(by: disposeBag)

        viewModel.output.hideViewObservable
            .bind(to: self.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.output.hideSecondViewObservable
        .bind(to: secondNotificationView.rx.isHidden)
        .disposed(by: disposeBag)

        viewModel.output.hideThirdViewObservable
        .bind(to: thirdNotificationView.rx.isHidden)
        .disposed(by: disposeBag)
    }
}
