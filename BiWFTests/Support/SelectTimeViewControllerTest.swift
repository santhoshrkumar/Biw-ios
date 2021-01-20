//
//  SelectTimeViewControllerTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 22/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//


import XCTest
import RxSwift
@testable import BiWF

class SelectTimeViewControllerTest: XCTestCase {
    
    var selectTimeViewController: SelectTimeViewController?
    var  scheduleCallback = ScheduleCallback(phone: "", asap: true, customerCareOption: "", handleOption: true, callbackTime: "", callbackReason: "")
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Support", bundle: nil)
        selectTimeViewController = storyboard.instantiateViewController(withIdentifier: "SelectTimeViewController")
            as? SelectTimeViewController
        let viewModel = SelectTimeViewModel(with: SupportRepository(), scheduleCallbackInfo: scheduleCallback)
        selectTimeViewController?.setViewModel(to: viewModel)
        _ = selectTimeViewController?.view
        selectTimeViewController?.viewWillAppear(true)
    }
    
    override func tearDown() {
        super.tearDown()
        selectTimeViewController = nil
    }
    
    func testSanity() {
        XCTAssertNotNil(selectTimeViewController)
    }

    func testEvent() {
        XCTAssertNotNil(selectTimeViewController?.datePicker.sendActions(for: UIControl.Event.valueChanged))
        XCTAssertNotNil(selectTimeViewController?.dateTextComponent.leftButton?.sendActions(for: .touchUpInside))
        XCTAssertNotNil(selectTimeViewController?.timePicker.sendActions(for: UIControl.Event.valueChanged))
        XCTAssertNil(selectTimeViewController?.timeTextComponent.leftButton?.sendActions(for:.touchUpInside))
    }
    
    func testShouldEnableDateTimeView() {
        XCTAssertNotNil(selectTimeViewController?.shouldEnableDateTimeView(true))
        XCTAssertNotNil(selectTimeViewController?.shouldEnableDateTimeView(false))
    }
}

