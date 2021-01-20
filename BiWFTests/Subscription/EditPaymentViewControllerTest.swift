//
//  EditPaymentViewControllerTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 16/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class EditPaymentViewControllerTest: XCTestCase {
    
    var editPaymentViewController: EditPaymentViewController?

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
        editPaymentViewController = storyboard.instantiateViewController(withIdentifier: "EditPaymentViewController")
            as? EditPaymentViewController
        _ = editPaymentViewController?.view
        let viewModel = EditPaymentViewModel(
        )
        editPaymentViewController?.setViewModel(to: viewModel)
        editPaymentViewController?.viewWillAppear(true)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        editPaymentViewController = nil
    }

    // tests if AccountViewController initialized
    func testSanity() {
        XCTAssertNotNil(editPaymentViewController)
    }
    
    func testButtonTapEvent() {
        XCTAssertNil(editPaymentViewController?.backButton.target?.perform(editPaymentViewController?.backButton.action, with: nil))
        XCTAssertNil(editPaymentViewController?.doneButton.target?.perform(editPaymentViewController?.doneButton.action, with: nil))
    }

}
