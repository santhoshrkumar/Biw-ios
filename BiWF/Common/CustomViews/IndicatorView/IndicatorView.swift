//
//  IndicatorView.swift
//  BiWF
//
//  Created by varun.b.r on 11/11/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
/*
 IndicatorView to show loader view
 */
class IndicatorView: UIView {
    
    /// Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.cornerRadius = Constants.IndicatorView.cornerRadius
        }
    }
    
    @IBOutlet weak var mainView: UIView! {
        didSet {
            mainView.backgroundColor = UIColor.BiWFColors.translucentBlack
        }
    }
    
    @IBOutlet weak var networkDisableIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var networkDisableHeader: UILabel! {
        didSet {
            networkDisableHeader.textColor = UIColor.BiWFColors.purple
            networkDisableHeader.font = .bold(ofSize: UIFont.font16)
        }
    }
    
    @IBOutlet weak var networkDisableMessage: UILabel! {
        didSet {
            networkDisableMessage.textColor = UIColor.BiWFColors.dark_grey
            networkDisableMessage.font = .regular(ofSize: UIFont.font16)
        }
    }
    
    /// Holds IndicatorViewModel  strong reference
    var viewModel: IndicatorViewModel!
    /// Contained disposables disposal
    let disposeBag = DisposeBag()
    
    /// Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
        initialSetup()
    }
    
    private func initialSetup() {
        self.tag = Constants.IndicatorView.viewTag
        self.backgroundColor = .clear
        networkDisableIndicator.startAnimating()
    }
}

/// IndicatorView extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension IndicatorView: Bindable {
    /// Binding all the output observers from viewmodel to get the values
    func bindViewModel() {

        viewModel.output.titleTextDriver
            .drive(networkDisableHeader.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.messageTextDriver
            .drive(networkDisableMessage.rx.text)
            .disposed(by: disposeBag)
    }
}
