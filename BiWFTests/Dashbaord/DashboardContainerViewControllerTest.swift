//
//  DashboardContainerViewControllerTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 20/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class DashboardContainerViewControllerTest: XCTestCase {
    
    let viewModel = DashboardContainerViewController()
    
    func testDisplayDashboard() {
        XCTAssertNotNil(viewModel.displayDashboard())
    }
     
    func testDisplayNewUserDashboard() {
        XCTAssertNotNil(viewModel.displayNewUserDashboard())
    }
    
    func testShowLoaderView() {
        XCTAssertNotNil(viewModel.showLoaderView())
    }
}
