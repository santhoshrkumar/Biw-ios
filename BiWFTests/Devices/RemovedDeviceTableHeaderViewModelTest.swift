//
//  RemovedDeviceTableHeaderViewModelTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 12/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class RemovedDeviceTableHeaderViewModelTest: XCTestCase {

    func testInit() {
        let viewModel = RemovedDeviceTableHeaderViewModel()
        XCTAssertNotNil(viewModel)
    }

}
