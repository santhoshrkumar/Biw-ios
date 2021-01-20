//
//  DashboardNetworkCell.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 6/25/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
/*
DashboardNetworkCell shows the wifi network
*/
class DashboardNetworkCell: UITableViewCell {

    /// Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.cornerRadius = 16
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tapToEditButton: UIButton! {
        didSet {
            tapToEditButton.setTitleColor(UIColor.BiWFColors.med_grey, for: .normal)
            tapToEditButton.titleLabel?.font = .regular(ofSize: 12)
        }
    }
    
    
    /// reuse identifier
    static let identifier = "DashboardNetworkCell"

    /// Holds DashboardNetworkCellViewModel with strong reference
    var viewModel: DashboardNetworkCellViewModel!
    private let disposeBag = DisposeBag()
    
    private func initialSetup() {
        titleLabel.font = .bold(ofSize: UIFont.font16)
        titleLabel.textColor = UIColor.BiWFColors.purple
    }
}

/// DashboardNetworkCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension DashboardNetworkCell: Bindable {
    func bindViewModel() {
        initialSetup()
        bindOutputs()
    }

    /// Binding all the output observers from viewmodel to get the values
    private func bindOutputs() {
        viewModel.output.titleLabelTextDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.tapToEditButtonTextDriver
            .drive(tapToEditButton.rx.title())
            .disposed(by: disposeBag)
    }
}
