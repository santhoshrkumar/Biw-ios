//
//  TitleTableViewCell.swift
//  BiWF
//
//  Created by pooja.q.gupta on 30/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import DPProtocols
/*
 TitleTableViewCell to show title for tableview cell
*/
class TitleTableViewCell: UITableViewCell {
    
    /// reuse identifier
    static let identifier = "TitleTableViewCell"
    
    /// Outlets
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .regular(ofSize: UIFont.font16)
            titleLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var nextImageView: UIImageView!
    @IBOutlet weak var constraintSeperatorviewHeight: NSLayoutConstraint!
    
    /// Vairables/Constants
    private let disposeBag = DisposeBag()
    
    /// Holds TitleTableViewCellViewModel with strong reference
    var viewModel: TitleTableViewCellViewModel!
}

/// TitleTableViewCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension TitleTableViewCell: Bindable {
    /// Binding all the input and output observers from viewmodel to get the events and values
    func bindViewModel() {
        
        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.hideNextImage
            .drive(nextImageView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.hideSeperator.drive(onNext: {[weak self] (isHidden) in
            self?.constraintSeperatorviewHeight.constant = isHidden ? 0 : 1
        }).disposed(by: disposeBag)
    }
}

