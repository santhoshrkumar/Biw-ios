//
//  PickerViewModelTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 22/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//


import XCTest
@testable import BiWF

class PickerViewModelTest: XCTestCase {
    
    func testItems() {
        let subject = PickerViewModel(with: [Constants.CancelSubscription.sureWantToCancel, Constants.CancelSubscription.serviceEndOn])
        XCTAssertNotNil(subject)

        //XCTAssertEqual(try subject.items.toBlocking().first(), [Constants.CancelSubscription.sureWantToCancel, Constants.CancelSubscription.serviceEndOn])
    }
}
