//
//  ConnectedDeviceTableHeaderViewModelTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 12/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class ConnectedDeviceTableHeaderViewModelTest: XCTestCase {
  
    func testInit() {
        let viewModel = ConnectedDeviceTableHeaderViewModel(withConnectedDeviceCount: 5, isExpanded: true)
        XCTAssertNotNil(viewModel)
    }
}
