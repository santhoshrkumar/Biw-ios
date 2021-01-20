//
//  AvailableSlotHeaderView.swift
//  BiWF
//
//  Created by pooja.q.gupta on 06/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/*
 AvailableSlotHeaderView to show available slot to book appointment
 */
class AvailableSlotHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .regular(ofSize: UIFont.font18)
            titleLabel.textColor = UIColor.BiWFColors.dark_grey
            titleLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var errorLabel: UILabel! {
        didSet {
            errorLabel.font = .regular(ofSize: UIFont.font12)
            errorLabel.textColor = UIColor.BiWFColors.strawberry
            errorLabel.text = Constants.ModifyAppointment.unselectedSlotError
        }
    }
    
    @IBOutlet weak var bottomSeperatorView: UIView!
    
    /// Header reuse identifier
    static let identifier = "AvailableSlotHeaderView"
    
    /// Holds AvailableSlotHeaderViewModel with strong reference
    var viewModel: AvailableSlotHeaderViewModel!
    let disposeBag = DisposeBag()
    
}

/// AvailableSlotHeaderView extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension AvailableSlotHeaderView: Bindable {
    /// Binding all the input and output observers from viewmodel to get the events and values
    func bindViewModel() {
        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.hideBottomSeperator
            .drive(bottomSeperatorView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.showErrorMessage
            .drive(errorLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
