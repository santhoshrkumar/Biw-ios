//
//  SpeedTestCellViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 16/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class SpeedTestCellViewModelTest: XCTestCase {

    func testInitMethod() {
        let viewModel = SpeedTestCellViewModel(with: NetworkRepository())
        XCTAssertNotNil(viewModel)
    }

}
