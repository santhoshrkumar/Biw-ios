//
//  WifiNetworkViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 22/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class WifiNetworkViewModelTest: XCTestCase {

    func testInitMethod() {
        let viewModel = WifiNetworkViewModel(with: WiFiNetwork(name: "Varun", password: "1234", isGuestNetwork: true))
        XCTAssertNotNil(viewModel)
    }
}
