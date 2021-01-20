//
//  PaymentDetailCellViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 16/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class PaymentDetailCellViewModelTest: XCTestCase {

    func testInitMethod() {
        let viewModel = PaymentDetailCellViewModel(with: Invoice(id: "748363", paymentName: "Modem", planName: "Discussed", planPrice: "756211", salesTaxAmount: 344.4, totalCost: 678.8, processedDate: "29/12/20", billingAddress: "Washington", email: "biwf@test.com", promoCode: "86730938", promoCodeValue: 0, promoCodeDescription: nil))
        XCTAssertNotNil(viewModel)
    }

}

