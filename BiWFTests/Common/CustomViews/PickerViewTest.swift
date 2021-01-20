//
//  PickerViewTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 22/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
@testable import BiWF

class PickerViewTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let pickerView = PickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        XCTAssertNotNil(pickerView)
    }

       override func tearDown() {
           super.tearDown()
       }
}
