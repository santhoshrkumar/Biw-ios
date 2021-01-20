//
//  NetworkDetailCellViewModelTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 12/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class NetworkDetailCellViewModelTest: XCTestCase {

    func testInit() {
        let viewModel = NetworkDetailCellViewModel(with:  WiFiNetwork(name: "varun", password: "1234", isGuestNetwork: true))
        XCTAssertNotNil(viewModel)
    }

}
