//
//  BuyFlowViewControllerTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 23/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class BuyFlowViewControllerTest: XCTestCase {

     // instance for AccountViewController
       var buyFlowViewController: BuyFlowViewController?

       override func setUp() {
           super.setUp()
           buyFlowViewController = BuyFlowViewController()
       }

       override func tearDown() {
           // Put teardown code here. This method is called after the invocation of each test method in the class.
           super.tearDown()
           buyFlowViewController = nil
       }

       // tests if AccountViewController initialized
       func testSanity() {
           XCTAssertNotNil(buyFlowViewController)
       }

}
