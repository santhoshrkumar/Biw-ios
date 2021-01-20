//
//  TitleHeaderview.swift
//  BiWF
//
//  Created by pooja.q.gupta on 10/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/*
 TitleHeaderview to show title header to the tableview
 */
class TitleHeaderview: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .bold(ofSize: UIFont.font16)
            titleLabel.textColor = UIColor.BiWFColors.purple
            titleLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var bottomSeperatorView: UIView!
    @IBOutlet weak var topSeperatorView: UIView!
    @IBOutlet weak var subTitleLabel: UILabel! {
        didSet {
            subTitleLabel.font = .bold(ofSize: UIFont.font16)
            subTitleLabel.textColor = UIColor.BiWFColors.purple
            subTitleLabel.numberOfLines = 0
            subTitleLabel.isHidden = true
        }
    }
    /// Header reuse identifier
    static let identifier = "TitleHeaderview"
    
    /// Holds TitleHeaderViewModel with strong reference
    var viewModel: TitleHeaderViewModel!
    let disposeBag = DisposeBag()
    
}

/// TitleHeaderview extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension TitleHeaderview: Bindable {
    /// Binding all the input and output observers from viewmodel to get the events and values
    func bindViewModel() {
        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.subtitle
            .drive(subTitleLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.hideSubtitle
            .drive(subTitleLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.hideTopSeperator
            .drive(topSeperatorView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.hideBottomSeperator
            .drive(bottomSeperatorView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
