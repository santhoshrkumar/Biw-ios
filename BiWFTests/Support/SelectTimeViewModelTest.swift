//
//  SelectTimeViewModelTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 22/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//


import XCTest
import RxSwift
@testable import BiWF

class SelectTimeViewModelTest: XCTestCase {
    
    var  scheduleCallback = ScheduleCallback(phone: "", asap: true, customerCareOption: "", handleOption: true, callbackTime: "", callbackReason: "")
    let disposeBag = DisposeBag()
    
    func testInitMethod() {
        let viewModel = SelectTimeViewModel(with: SupportRepository(), scheduleCallbackInfo: scheduleCallback)
        XCTAssertNotNil(viewModel)
        viewModel.input.callMeTapObserver.onNext(())
    }
    
    func testCancelEvent() {
        let testExpectation = expectation(description: "Dismiss view and go back to tabview")
        let viewModel = SelectTimeViewModel(with: SupportRepository(), scheduleCallbackInfo: scheduleCallback)
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
        let testExpectation = expectation(description: "Dismiss view and go back")
        let viewModel = SelectTimeViewModel(with: SupportRepository(), scheduleCallbackInfo: scheduleCallback)
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
    
    func testScheduleCallBack() {
        let support = SupportRepository()
        let viewModel = SelectTimeViewModel(with: support, scheduleCallbackInfo: scheduleCallback)
        XCTAssertNotNil(viewModel.scheduleCallBack(with: scheduleCallback))
        support.scheduleCallbackResult.onNext(ScheduleCallbackResponse(status: "Done", message: "No Message"))
        support.errorMessage.onNext("No Error")
    }
}
