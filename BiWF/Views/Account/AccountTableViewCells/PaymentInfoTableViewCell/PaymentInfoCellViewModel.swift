//
//  PaymentInfoCellViewModel.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 09/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
/*
  PaymentInfoCellViewModel set the values for payment information
*/
class PaymentInfoCellViewModel {

    /// Constants/Variables
    let header: Driver<String>
    var speedUpToValue: Driver<String>
    let paymentInfoHeader: Driver<String>
    let nextPaymentDate: Driver<String>
    let nextPaymentDateValue: Driver<String>
    let cardNumberValue: Driver<String>
    
    /// Initialize a new instance of Account
    /// - Parameter Account: Contains all the varable and constants of personal info
    /// PaymentInfo : Contains all the varable and constants of PaymentInfo
    init(withAccountInfo accountInfo: Account, andPaymentInfo paymentInfo: PaymentInfo, andFiberPlanInformation fiberPlanInfo:FiberPlanInfo) {
        header = .just(accountInfo.productName ?? "")
        paymentInfoHeader = .just(Constants.Account.paymentInfoText)
        nextPaymentDate = .just(Constants.Account.nextPaymentDateText)
        nextPaymentDateValue = .just(paymentInfo.formattedPaymentDate)
        cardNumberValue = .just(paymentInfo.card)
        speedUpToValue = fiberPlanInfo.internetSpeed != nil && ((fiberPlanInfo.internetSpeed?.isEmpty) == false) ? .just("Speeds \(fiberPlanInfo.internetSpeed?.firstLowercased ?? "")") : .just("")
    }
}

