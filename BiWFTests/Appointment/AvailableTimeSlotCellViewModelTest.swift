//
//  AvailableTimeSlotCellViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 13/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class AvailableTimeSlotCellViewModelTest: XCTestCase {
    
    let disposeBag = DisposeBag()
    
    /// Testcase for init method 
    func testInitMethod() {
        let viewModel = AvailableTimeSlotCellViewModel(with: Slot(value: "Exist", index: 2, isSelected: true), isErrorState: false)
        XCTAssertNotNil(viewModel)
    }
}
