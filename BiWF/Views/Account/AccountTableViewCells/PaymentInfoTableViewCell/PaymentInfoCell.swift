//
//  PaymentInfoCell.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 09/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/**
 A TableView cell representing the payment information
 */
class PaymentInfoCell: UITableViewCell {
    
    /// reuse identifier
    static let identifier = "PaymentInfoCell"
    
    /// Outlets
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var speedUptoValueLabel: UILabel!
    @IBOutlet weak var paymentInfoHeaderLabel: UILabel!
    @IBOutlet weak var nextPaymentDateLabel: UILabel!
    @IBOutlet weak var nextPaymentDateValueLabel: UILabel!
    @IBOutlet weak var cardLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    
    // Holds the PaymentInfoCellViewModel with a strong reference
    var viewModel: PaymentInfoCellViewModel!
    
    /// Setting different attributes for the labels
    private func initialSetup() {
        self.headerLabel.font = .bold(ofSize: UIFont.font24)
        self.headerLabel.textColor = UIColor.BiWFColors.purple
        self.paymentInfoHeaderLabel.font = .bold(ofSize: UIFont.font16)
        self.paymentInfoHeaderLabel.textColor = UIColor.BiWFColors.purple
        self.speedUptoValueLabel.font = .regular(ofSize: UIFont.font16)
        self.speedUptoValueLabel.textColor = UIColor.BiWFColors.dark_grey
        self.nextPaymentDateLabel.font = .regular(ofSize: UIFont.font16)
        self.nextPaymentDateLabel.textColor = UIColor.BiWFColors.dark_grey
        self.nextPaymentDateValueLabel.font = .regular(ofSize: UIFont.font16)
        self.nextPaymentDateValueLabel.textColor = UIColor.BiWFColors.dark_grey
        self.cardLabel.font = .regular(ofSize: UIFont.font16)
        self.cardLabel.textColor = UIColor.BiWFColors.dark_grey
        self.backgroundColor = UIColor.BiWFColors.white
        
        /// Setting tableview selection background to clear color
        let selectionBackgroundView = UIView()
        selectionBackgroundView.backgroundColor = .clear
        UITableViewCell.appearance().selectedBackgroundView = selectionBackgroundView

    }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

/// PaymentInfoCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension PaymentInfoCell: Bindable {
    /// Binding all the drivers from viewmodel to get the values
    func bindViewModel() {
        initialSetup()
        viewModel.header
            .drive(headerLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.speedUpToValue
            .drive(speedUptoValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.paymentInfoHeader
            .drive(paymentInfoHeaderLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.nextPaymentDate
            .drive(nextPaymentDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.nextPaymentDateValue
            .drive(nextPaymentDateValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.cardNumberValue
            .drive(cardLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

