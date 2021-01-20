//
//  SupportSpeedTestViewModelTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 22/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
@testable import BiWF

class SupportSpeedTestViewModelTest: XCTestCase {
    
    let viewModel = SupportSpeedTestViewModel(with: SpeedTest(uploadSpeed: "123", downloadSpeed: "456", timeStamp: "03/02/2020 at 8:52pm"))
    func testInitMethod() {
        XCTAssertNotNil(viewModel)
    }
    
    
    func testRestartModem() {
        XCTAssertNotNil(viewModel.restartModem())
    }
    
    func testCheckModemStatus() {
        XCTAssertNotNil(viewModel.checkModemStatus())
    }
    
    func testSuscriber() {
        viewModel.restartModemSubject.onNext(Void())
    }
}
