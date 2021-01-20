//
//  DashboardNotificationView.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/20/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
/*
DashboardNotificationView to show notification on dashboard
**/
class DashboardNotificationView: UIView {

    /// Outlets
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var closeButton: UIButton!
    
    var viewModel: DashboardNotificationViewModel!
    private let viewTapGesture = UITapGestureRecognizer()
    private var disposeBag = DisposeBag()
    
    /// Create DashboardNotificationView object from xib view
    ///- returns: DashboardNotificationView view object
    static func createFromNib() -> DashboardNotificationView {
        let nib = UINib(nibName: String(describing: DashboardNotificationView.self), bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil).first as! DashboardNotificationView
        view.initialSetup()
        return view
    }

    ///Initial view setup
    func initialSetup() {
        nameLabel.font = .bold(ofSize: UIFont.font16)
        nameLabel.textColor = UIColor.BiWFColors.purple
        descriptionLabel.font = .regular(ofSize: UIFont.font12)
        descriptionLabel.textColor = UIColor.BiWFColors.dark_grey

        addGestureRecognizer(viewTapGesture)
    }
}

/// DashboardNotificationView extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension DashboardNotificationView: Bindable {
    ///Binding view model to DashboardNotificationView to handle event and UI data
    func bindViewModel() {
        disposeBag = DisposeBag()

        closeButton.rx.tap
            .bind(to: viewModel.input.closeTappedObvserver)
            .disposed(by: disposeBag)

        viewTapGesture.rx.event.map { _ in return () }
            .bind(to: viewModel.input.openNotificationDetailsObserver)
            .disposed(by: disposeBag)

        viewModel.output.nameTextDriver
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.descriptionTextDriver
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
