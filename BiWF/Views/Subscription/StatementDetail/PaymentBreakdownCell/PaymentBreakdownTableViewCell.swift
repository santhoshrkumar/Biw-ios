//
//  PaymentBreakdownTableViewCell.swift
//  BiWF
//
//  Created by pooja.q.gupta on 11/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import DPProtocols
/*
 PaymentBreakdownTableViewCell to show Breakdown payment
 */
class PaymentBreakdownTableViewCell: UITableViewCell {
    /// reuse identifier
    static let identifier = "PaymentBreakdownTableViewCell"
    
    /// Outlets
    @IBOutlet weak var paymentBreakdownLabel: UILabel! {
        didSet {
            paymentBreakdownLabel.font = .bold(ofSize: UIFont.font20)
            paymentBreakdownLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var planNameLabel: UILabel! {
        didSet {
            planNameLabel.font = .bold(ofSize: UIFont.font16)
            planNameLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var planPriceLabel: UILabel! {
        didSet {
            planPriceLabel.font = .regular(ofSize: UIFont.font18)
            planPriceLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var salesTaxLabel: UILabel! {
        didSet {
            salesTaxLabel.font = .bold(ofSize: UIFont.font16)
            salesTaxLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var salesTaxValueLabel: UILabel! {
        didSet {
            salesTaxValueLabel.font = .regular(ofSize: UIFont.font18)
            salesTaxValueLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var promoCodeLabel: UILabel! {
        didSet {
            promoCodeLabel.font = .bold(ofSize: UIFont.font16)
            promoCodeLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var promoCodePercentageLabel: UILabel! {
        didSet {
            promoCodePercentageLabel.font = .regular(ofSize: UIFont.font12)
            promoCodePercentageLabel.textColor = UIColor.BiWFColors.med_grey
        }
    }
    @IBOutlet weak var promoCodeValueLabel: UILabel! {
        didSet {
            promoCodeValueLabel.font = .regular(ofSize: UIFont.font18)
            promoCodeValueLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var totalLabel: UILabel! {
        didSet {
            totalLabel.font = .bold(ofSize: UIFont.font16)
            totalLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var totalPriceLabel: UILabel! {
        didSet {
            totalPriceLabel.font = .regular(ofSize: UIFont.font18)
            totalPriceLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    
    /// Vairables/Constants
    private let disposeBag = DisposeBag()
    
    /// PaymentBreakdownCellViewModel with strong reference
    var viewModel: PaymentBreakdownCellViewModel!
    
    @IBOutlet weak var constraintPromoStackViewTop: NSLayoutConstraint!
    @IBOutlet weak var constraintPromoStackViewHeight: NSLayoutConstraint!
}

/// PaymentBreakdownTableViewCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension PaymentBreakdownTableViewCell: Bindable {
    
    /// Binding all the drivers from viewmodel to get the values
    func bindViewModel() {
        
        viewModel.paymentBreakdown
            .drive(paymentBreakdownLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.planName
            .drive(planNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.planPrice
            .drive(planPriceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.salesTax
            .drive(salesTaxLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.salesTaxValue
            .drive(salesTaxValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.promoCode?
            .drive(promoCodeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.salesTax
            .drive(salesTaxLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.salesTaxValue
            .drive(salesTaxValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.promoCode?
            .drive(promoCodeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.promoCodeValue?
            .drive(promoCodeValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.promoCodeOffer?
            .drive(promoCodePercentageLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.total
            .drive(totalLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.totalPrice
            .drive(totalPriceLabel.rx.text)
            .disposed(by: disposeBag)
        
        if promoCodeLabel.text?.isEmpty ?? false {
            constraintPromoStackViewTop.constant = 0
            constraintPromoStackViewHeight.constant = 0
        }
    }
}
