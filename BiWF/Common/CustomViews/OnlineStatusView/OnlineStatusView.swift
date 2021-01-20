//
//  OnlineStatusView.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 6/24/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
/*
 OnlineStatusView to show online status information
 */
class OnlineStatusView: UIView {
    
    /// Outlets
    @IBOutlet private var statusIndicatorView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!

    /// Holds OnlineStatusViewModel with strong reference
    var viewModel: OnlineStatusViewModel!
    private let disposeBag = DisposeBag()

    static func createFromNib() -> OnlineStatusView {
        let nib = UINib(nibName: String(describing: OnlineStatusView.self), bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! OnlineStatusView
    }
}

/// OnlineStatusView extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension OnlineStatusView: Bindable {
    
    /// Binding all the output observers from viewmodel to get the values
    func bindViewModel() {
        viewModel.output.isOnlineObservable
            .map { isOnline -> UIColor in
                return isOnline ? UIColor.BiWFColors.kale : UIColor.BiWFColors.strawberry
            }.bind(to: statusIndicatorView.rx.backgroundColor)
            .disposed(by: disposeBag)

        viewModel.output.titleTextDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.statusTextDriver
            .drive(statusLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.descriptionTextDriver
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
