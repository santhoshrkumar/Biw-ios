//
//  FiberPlanDetailCellViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 16/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class FiberPlanDetailCellViewModelTest: XCTestCase {
    
    func testInitMethod() {
        let viewModel = FiberPlanDetailCellViewModel(fiberPlanInfo: FiberPlanInfo(internetSpeed: "Speeds up to 940Mbps", productName: "Fiber Internet", id: "a1Yf0000002hH8iEAE", zuoraPrice: 65.0, extendedAmount: 65.0))
        XCTAssertNotNil(viewModel)
    }
}
