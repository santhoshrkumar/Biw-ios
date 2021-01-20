//
//  FeedbackCell.swift
//  BiWF
//
//  Created by varun.b.r on 19/11/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
/*
FeedbackCell shows the customer feedback on dashboard
*/
class FeedbackCell: UITableViewCell {
    
    /// Reuse cell identifier
    static let identifier = "FeedBackCell"
    
    /// Outlets
    @IBOutlet weak var customerFeedbackButton: UIButton! {
        didSet {
            customerFeedbackButton.setTitleColor(UIColor.BiWFColors.med_grey, for: .normal)
            customerFeedbackButton.titleLabel?.font = .regular(ofSize: UIFont.font16)
            customerFeedbackButton.cornerRadius = Constants.IndicatorView.cornerRadius
            customerFeedbackButton.tag = Constants.DashboardContainer.feedbackButtonTag
        }
    }
    
    /// Holds FeedBackViewCellViewModel with strong reference
    var viewModel: FeedBackCellViewModel!
    let disposeBag = DisposeBag()
}

/// FeedBackCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension FeedbackCell : Bindable {
    
    /// Binding all the input and output observers from viewmodel to get the events and values
    func bindViewModel() {
        viewModel.output.feedbackTitleDriver
            .drive(customerFeedbackButton.rx.title())
        .disposed(by: disposeBag)
    }
}
