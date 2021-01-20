//
//  DashboardSpeedTestCellViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 20/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class DashboardSpeedTestCellViewModelTest: XCTestCase {
    let repository = NetworkRepository()

    func testInitMethod() {
        let viewModel = DashboardSpeedTestCellViewModel(networkRepository: repository)
        XCTAssertNotNil(viewModel)
    }
    
    func testSubcribe() {
        XCTAssertNotNil(repository.speedTestSubject.onNext(SpeedTest(uploadSpeed: "12", downloadSpeed: "234", timeStamp: "1")))
    }
}
