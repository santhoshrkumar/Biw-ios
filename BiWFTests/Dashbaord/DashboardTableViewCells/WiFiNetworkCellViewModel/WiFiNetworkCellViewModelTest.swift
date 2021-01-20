//
//  WiFiNetworkCellViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 20/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class WiFiNetworkCellViewModelTest: XCTestCase {

    func testInitMethod() {
        let viewModel = WiFiNetworkCellViewModel(with: WiFiNetwork(name: "Varun", password: "1234", isGuestNetwork: true), and: WiFiNetwork(name: "Varun", password: "1234", isGuestNetwork: true))
        XCTAssertNotNil(viewModel)
    }

}
