//
//  TechnicianDetailViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 22/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class TechnicianDetailViewModelTest: XCTestCase {

    func testInitMethod() {
        let viewModel = TechnicianDetailViewModel(with: "Modem ID", status: "On the way", estimatedArrivalTime: "13:26:24.002")
        XCTAssertNotNil(viewModel)
    }
}
