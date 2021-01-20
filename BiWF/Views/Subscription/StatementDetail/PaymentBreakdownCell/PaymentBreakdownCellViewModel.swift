//
//  PaymentBreakdownCellViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 11/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
/*
 PaymentBreakdownCellViewModel to handle Breakdown payment
 */
class PaymentBreakdownCellViewModel {
    
    /// Variables/Constants
    let paymentBreakdown: Driver<String>
    
    let planName: Driver<String>
    let planPrice: Driver<String>
    
    let salesTax: Driver<String>
    let salesTaxValue: Driver<String>
    
    var promoCode: Driver<String>?
    var promoCodeOffer: Driver<String>?
    var promoCodeValue: Driver<String>?
    
    let total: Driver<String>
    let totalPrice: Driver<String>
    
    /// Initializes a new instance of Invoice
    /// - Parameter receiptDetail : Invoice for the payment
    init(with receiptDetail: Invoice) {
        self.paymentBreakdown = .just(Constants.PaymentBreakdown.paymentBreakdown)
        
        self.planName = .just(receiptDetail.planName ?? Constants.PaymentBreakdown.defaultPaymentName)
        self.planPrice = .just(receiptDetail.planPrice ?? Constants.PaymentBreakdown.emptyDollarValue)
        
        self.salesTax = .just(Constants.PaymentBreakdown.salesTax)
        self.salesTaxValue = .just(String(format: "$%.2f", "\(Constants.Common.currency)\(receiptDetail.salesTaxAmount ?? 0)"))

        self.total = .just(Constants.PaymentBreakdown.total)

        let priceWithoutDollar = receiptDetail.planPrice?.replacingOccurrences(of: Constants.Common.currency,
                                                                               with: "",
                                                                               options: NSString.CompareOptions.literal,
                                                                               range: nil)
        let amount: Float = (priceWithoutDollar as NSString?)?.floatValue ?? 0.00
        let totalPriceToPay = String(format: "%.2f", (amount) + (receiptDetail.salesTaxAmount ?? 0) - Float(receiptDetail.promoCodeValue ?? 0.00))

        self.totalPrice = .just("\(Constants.Common.currency)\(totalPriceToPay)")
        self.updatePromoValues(withDetails: receiptDetail)
    }
    
    /// updates if any promo code is exist
    /// - Parameter details : with payment invoice
    func updatePromoValues(withDetails details: Invoice) {
        if let planPromoCode = details.promoCode {
            self.promoCode = .just("\(Constants.PaymentBreakdown.promoCode) - \(planPromoCode )")
            self.promoCodeOffer = .just(details.promoCodeDescription ?? "")
            self.promoCodeValue = .just(String(format: "%@%.2f", Constants.Common.currency, details.promoCodeValue ?? 0.00))
        } else {
            self.promoCode = .just("")
            self.promoCodeOffer = .just("")
            self.promoCodeValue = .just("")
        }
    }
}
