//
//  SupportSpeedTestViewTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 25/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
@testable import BiWF

class SupportSpeedTestViewTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        var speedTestView = SupportSpeedTestView.init()
        let viewModel = SupportSpeedTestViewModel(with: SpeedTest(uploadSpeed: "123", downloadSpeed: "234", timeStamp: "12.30 PM"))
        speedTestView.setViewModel(to: viewModel)
        XCTAssertNotNil(speedTestView)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
}
