//
//  ContactInfoViewModelTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 22/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class ContactInfoViewModelTest: XCTestCase {
    var  scheduleCallback = ScheduleCallback(phone: "", asap: true, customerCareOption: "", handleOption: true, callbackTime: "", callbackReason: "")
    let disposeBag = DisposeBag()

    func testInitMethod() {
           let viewModel = ContactInfoViewModel(scheduleCallBack: scheduleCallback)
           XCTAssertNotNil(viewModel)
       }

    func testCancelEvent() {
        let testExpectation = expectation(description: "Done call Api and dismiss view")
        let viewModel = ContactInfoViewModel(scheduleCallBack: scheduleCallback)
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case SupportCoordinator.Event.goBackToTabView = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.cancelTapObserver.onNext(Void())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testBackEvent() {
        let testExpectation = expectation(description: "Done call Api and dismiss view")
        let viewModel = ContactInfoViewModel(scheduleCallBack: scheduleCallback)
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case SupportCoordinator.Event.goBack = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.backTapObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testNextEvent() {
        let testExpectation = expectation(description: "Done call Api and dismiss view")
        let viewModel = ContactInfoViewModel(scheduleCallBack: scheduleCallback)
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case SupportCoordinator.Event.goToSelectTimeScheduleCallback(_) = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.nextContactInfoTapObserver.onNext(scheduleCallback)
        wait(for: [testExpectation], timeout: 5)
    }
}
