//
//  InstallationStatusViewModelTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 22/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
@testable import BiWF

class InstallationStatusViewModelTest: XCTestCase {
    
    func testInitMethod() {
        let viewModel = InstallationStatusViewModel(with: "Test", status: "Start", state: InstallationState.inProgress)
        XCTAssertNotNil(viewModel)
    }
}
