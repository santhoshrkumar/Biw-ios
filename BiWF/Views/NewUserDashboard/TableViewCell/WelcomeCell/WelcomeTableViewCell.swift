//
//  WelcomeTableViewCell.swift
//  BiWF
//
//  Created by pooja.q.gupta on 03/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/*
 WelcomeTableViewCell to show welcome note
 */
class WelcomeTableViewCell: UITableViewCell {
    
    /// reuse identifier
    static let identifier = "WelcomeTableViewCell"
    
    /// Outlets
    @IBOutlet weak var leftview: UIView! {
        didSet {
            leftview.backgroundColor = UIColor.BiWFColors.light_blue
            leftview.cornerRadius = Constants.WelcomeTableviewCell.leftViewCornerRadius
        }
    }
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.backgroundColor = UIColor.BiWFColors.lavender.withAlphaComponent(0.1)
            button.cornerRadius = Constants.WelcomeTableviewCell.closeButtonCornerRadius
        }
    }
    @IBOutlet weak var cellBackgroundView: UIView! {
        didSet {
            cellBackgroundView.backgroundColor = UIColor.BiWFColors.white
            cellBackgroundView.cornerRadius = Constants.WelcomeTableviewCell.contentViewCornerRadius
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .bold(ofSize: UIFont.font16)
            titleLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = .regular(ofSize: UIFont.font12)
            descriptionLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    
    private let disposeBag = DisposeBag()
    
    /// Holds WelcomeCellViewModel with strong reference
    var viewModel: WelcomeCellViewModel!
}

/// WelcomeTableViewCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension WelcomeTableViewCell: Bindable {
    
    /// Binding all the output observers from viewmodel to get the values
    func bindViewModel() {
        viewModel.output.titleTextDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.descriptionTextDriver
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        button.rx.tap
            .bind(to: viewModel.input.dismissWelcomeObserver)
            .disposed(by: disposeBag)
    }
}
