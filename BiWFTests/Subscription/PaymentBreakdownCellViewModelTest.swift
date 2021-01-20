//
//  PaymentBreakdownCellViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 16/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class PaymentBreakdownCellViewModelTest: XCTestCase {

    func testInitMethod() {
        let viewModel = PaymentBreakdownCellViewModel(with: Invoice(id: "748363", paymentName: "Modem", planName: "Discussed", planPrice: "756211", salesTaxAmount: 344.4, totalCost: 678.8, processedDate: "29/12/20", billingAddress: "Washington", email: "biwf@test.com", promoCode: "86730938", promoCodeValue: 0, promoCodeDescription: nil))
        XCTAssertNotNil(viewModel)
        
        let viewModel1 = PaymentBreakdownCellViewModel(with: Invoice(id: "748363", paymentName: nil, planName: "Discussed", planPrice: nil, salesTaxAmount: 344.4, totalCost: 678.8, processedDate: "29/12/20", billingAddress: "Washington", email: "biwf@test.com", promoCode: nil, promoCodeValue: nil, promoCodeDescription: nil))
        XCTAssertNotNil(viewModel1)

    }
}
