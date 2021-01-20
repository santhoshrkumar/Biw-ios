//
//  PaymentDetailCellViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 11/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
/*
 PaymentDetailCellViewModel contains details about the payment
 */
class PaymentDetailCellViewModel {
    
     /// Variables/Constants
    let paymentDetail: Driver<String>
    let paymentDate: Driver<String>
    
    let paymentMethod: Driver<String>
    let paymentMethodValue: Driver<String>
    
    let email: Driver<String>
    let emailValue: Driver<String>
    
    let address: Driver<String>
    let addressValue: Driver<String>
    
    /// Initializes a new instance of Invoice
    /// - Parameter receiptDetail : Invoice for the payment
    init(with receiptDetail: Invoice) {
        self.paymentDetail = .just(Constants.PaymentDetail.paymentDetails)
        self.paymentDate = .just("\(Constants.PaymentDetail.processedOn) \( receiptDetail.getProcessedDate())")
        
        self.paymentMethod = .just("\(Constants.PaymentDetail.paymentMethod):")
        self.paymentMethodValue = .just(receiptDetail.paymentName ?? "")
        
        self.email = .just("\(Constants.PaymentDetail.email):")
        self.emailValue = .just(receiptDetail.email ?? "")
        
        self.address = .just("\(Constants.PaymentDetail.billingAddress):")
        self.addressValue = .just(receiptDetail.billingAddress ?? "")
    }
}
