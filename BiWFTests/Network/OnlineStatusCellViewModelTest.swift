//
//  OnlineStatusCellViewModelTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 12/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class OnlineStatusCellViewModelTest: XCTestCase {

    func testInit() {
        let viewModel = OnlineStatusCellViewModel(networkRepository: NetworkRepository(), type: OnlineStatusViewModel.StatusType.internet)
        XCTAssertNotNil(viewModel)
    }

    func testInitWithModem() {
        let viewModel = OnlineStatusCellViewModel(networkRepository: NetworkRepository(), type: OnlineStatusViewModel.StatusType.modem)
        XCTAssertNotNil(viewModel)
    }
}
