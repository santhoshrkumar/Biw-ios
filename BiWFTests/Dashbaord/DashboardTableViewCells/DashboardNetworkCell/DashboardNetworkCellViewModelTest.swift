//
//  DashboardNetworkCellViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 20/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class DashboardNetworkCellViewModelTest: XCTestCase {

    func testInitMethod() {
        let viewModel = DashboardNetworkCellViewModel()
        XCTAssertNotNil(viewModel)
    }

}
