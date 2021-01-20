//
//  LogoutCell.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 5/7/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
/**
A TableView cell representing the logout
*/
class LogoutCell: UITableViewCell {

    /// reuse identifier
    static let identifier = "LogoutCell"

    /// Outlets
    @IBOutlet var logoutButton: Button! {
        didSet {
            logoutButton.style = .withoutBorder
        }
    }
    
    /// Holds the LogoutCellViewModel with a strong reference
    var viewModel: LogoutCellViewModel!
    
    var disposeBag = DisposeBag()
    
    ///this is called just before the cell is returned from the table view method
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

/// LogoutCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension LogoutCell: Bindable {
    /// Binding all the drivers from viewmodel to get events and values
    func bindViewModel() {
        logoutButton.rx.tap.bind(onNext: {[weak self] _ in
            AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.logout)
            self?.viewModel.input.logoutTapObserver.onNext(())
        }).disposed(by: disposeBag)
        
        viewModel.output.logoutTitleDriver
            .drive(logoutButton.rx.title())
            .disposed(by: disposeBag)
    }
}
