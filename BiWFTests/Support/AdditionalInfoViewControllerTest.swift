//
//  AdditionalInfoViewControllerTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 17/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF
/**
 Executes unit test cases for the AdditionalInfoViewController
 */
class AdditionalInfoViewControllerTest: XCTestCase {

    // instance for AdditionalInfoViewController
    var additionalInfoViewController: AdditionalInfoViewController?

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Support", bundle: nil)
        additionalInfoViewController = storyboard.instantiateViewController(withIdentifier: "AdditionalInfoViewController")
            as? AdditionalInfoViewController
        let viewModel = AdditionalInfoViewModel(scheduleCallBack: ScheduleCallback(phone: "111-111-1111",
                                                                                   asap: true,
                                                                                   customerCareOption: "I want to know more about Fiber Internet",
                                                                                   handleOption: true,
                                                                                   callbackTime: "2020-11-28 02:00:00",
                                                                                   callbackReason: "Test"))
        additionalInfoViewController?.setViewModel(to: viewModel)
        _ = additionalInfoViewController?.view
        additionalInfoViewController?.viewWillAppear(true)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        additionalInfoViewController = nil
    }

    // tests if AdditionalInfoViewController initialized
    func testSanity() {
        XCTAssertNotNil(additionalInfoViewController)
    }
    
    func testButtonTap() {
        additionalInfoViewController?.moreInfoNextButton.sendActions(for: .touchUpInside)
    }
}


