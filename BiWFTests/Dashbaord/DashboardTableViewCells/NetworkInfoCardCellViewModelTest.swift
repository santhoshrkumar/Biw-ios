//
//  NetworkInfoCardCellViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 11/11/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class NetworkInfoCardCellViewModelTest: XCTestCase {
    
    func testInitMethod() {
        let viewModel = NetworkInfoCardCellViewModel(with: WiFiNetwork(name: "Varun", password: "1234", isGuestNetwork: true), and: WiFiNetwork(name: "Varun", password: "1234", isGuestNetwork: true))
        XCTAssertNotNil(viewModel)
    }
}
