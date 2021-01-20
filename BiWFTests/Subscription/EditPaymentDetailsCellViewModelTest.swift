//
//  EditPaymentDetailsCellViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 16/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class EditPaymentDetailsCellViewModelTest: XCTestCase {

    func testInitMethod() {
        let viewModel = EditPaymentDetailsCellViewModel()
        XCTAssertNotNil(viewModel)
        
        let userId = ServiceManager.shared.userID
        ServiceManager.shared.set(userID: nil)
        let viewModel2 = EditPaymentDetailsCellViewModel()
        XCTAssertNotNil(viewModel2)
        ServiceManager.shared.set(userID: userId)
    }
}
