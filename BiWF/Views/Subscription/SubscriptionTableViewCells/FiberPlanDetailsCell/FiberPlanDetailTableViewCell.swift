//
//  FiberPlanDetailTableViewCell.swift
//  BiWF
//
//  Created by pooja.q.gupta on 06/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import DPProtocols
/*
FiberPlanDetailTableViewCell shows FiberPlan details
*/
class FiberPlanDetailTableViewCell: UITableViewCell {
    
    /// reuse identifier
    static let identifier = "FiberPlanDetailTableViewCell"
    
    /// Outlets
    @IBOutlet weak var stackView: UIStackView! {
        didSet {
            stackView.setCustomSpacing(Constants.FiberPlanDetailCell.spacingAfterPlanNameLabel, after: speedLabel)
            stackView.setCustomSpacing(Constants.FiberPlanDetailCell.spacingAfterSpeedLabel, after: speedLabel)
        }
    }
    @IBOutlet weak var planNameLabel: UILabel! {
        didSet {
            planNameLabel.textColor = UIColor.BiWFColors.purple
            planNameLabel.font = .bold(ofSize: UIFont.font24)
        }
    }
    @IBOutlet weak var speedLabel: UILabel! {
        didSet {
            speedLabel.textColor = UIColor.BiWFColors.dark_grey
            speedLabel.font = .regular(ofSize: UIFont.font18)
        }
    }
    @IBOutlet weak var detailLabel: UILabel! {
        didSet {
            detailLabel.textColor = UIColor.BiWFColors.sub_grey
            detailLabel.font = .regular(ofSize: UIFont.font12)
            detailLabel.numberOfLines = 0
        }
    }
    
    /// Constants/Variables
    private let disposeBag = DisposeBag()
    
    /// Holds FiberPlanDetailCellViewModel with strong reference
    var viewModel: FiberPlanDetailCellViewModel!
}

/// FiberPlanDetailTableViewCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension FiberPlanDetailTableViewCell: Bindable {
    
    /// Binding all the drivers from viewmodel to get the values
    func bindViewModel() {
        viewModel.planName
            .drive(planNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.speed
            .drive(speedLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.detail
            .drive(detailLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
