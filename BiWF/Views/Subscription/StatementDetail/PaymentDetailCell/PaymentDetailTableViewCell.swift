//
//  PaymentDetailTableViewCell.swift
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
 PaymentDetailTableViewCell to show payment info
 */
class PaymentDetailTableViewCell: UITableViewCell {
    /// reuse identifier
    static let identifier = "PaymentDetailTableViewCell"
    
    /// Outlets
    @IBOutlet weak var paymentDetailsLabel: UILabel! {
        didSet {
            paymentDetailsLabel.font = .bold(ofSize: UIFont.font20)
            paymentDetailsLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var paymentDateLabel: UILabel! {
        didSet {
            paymentDateLabel.font = .regular(ofSize: UIFont.font12)
            paymentDateLabel.textColor = UIColor.BiWFColors.med_grey
        }
    }
    @IBOutlet weak var paymentMethodLabel: UILabel! {
        didSet {
            paymentMethodLabel.font = .regular(ofSize: UIFont.font16)
            paymentMethodLabel.textColor = UIColor.BiWFColors.med_grey
        }
    }
    @IBOutlet weak var paymentMethodValueLabel: UILabel! {
        didSet {
            paymentMethodValueLabel.font = .regular(ofSize: UIFont.font16)
            paymentMethodValueLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var emailLabel: UILabel! {
        didSet {
            emailLabel.font = .regular(ofSize: UIFont.font16)
            emailLabel.textColor = UIColor.BiWFColors.med_grey
        }
    }
    @IBOutlet weak var emailValueLabel: UILabel! {
        didSet {
            emailValueLabel.font = .regular(ofSize: UIFont.font16)
            emailValueLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var addressLabel: UILabel! {
        didSet {
            addressLabel.font = .regular(ofSize: UIFont.font16)
            addressLabel.textColor = UIColor.BiWFColors.med_grey
        }
    }
    @IBOutlet weak var addressValueLabel: UILabel! {
        didSet {
            addressValueLabel.font = .regular(ofSize: UIFont.font16)
            addressValueLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    
    /// Vairables/Constants
    private let disposeBag = DisposeBag()
    
    /// Holds the PaymentDetailCellViewModel with strong reference
    var viewModel: PaymentDetailCellViewModel!
}

/// PaymentDetailTableViewCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view mode
extension PaymentDetailTableViewCell: Bindable {
    
    /// Binding all the drivers from viewmodel to get the values
    func bindViewModel() {
        
        viewModel.paymentDetail
            .drive(paymentDetailsLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.paymentDate
            .drive(paymentDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.paymentMethod
            .drive(paymentMethodLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.paymentMethodValue
            .drive(paymentMethodValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.email
            .drive(emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.emailValue
            .drive(emailValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.address
            .drive(addressLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.addressValue
            .drive(addressValueLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
