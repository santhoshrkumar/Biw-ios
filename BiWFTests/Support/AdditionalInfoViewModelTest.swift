//
//  AdditionalInfoViewModelTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 16/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class AdditionalInfoViewModelTest: XCTestCase {
    
    let disposeBag = DisposeBag()
    
    func testBackEvent() {
        
        let testExpectation = expectation(description: "Recieve event to back from additional info page")
        let viewModel = AdditionalInfoViewModel(scheduleCallBack: ScheduleCallback(phone: "111-111-1111",
                                                                                    asap: true,
                                                                                    customerCareOption: "I want to know more about Fiber Internet",
                                                                                    handleOption: true,
                                                                                    callbackTime: "2020-11-28 02:00:00",
                                                                                    callbackReason: "Test"))
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goBack = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.backTapObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testCancelEvent() {
        
        let testExpectation = expectation(description: "Recieve event to cancel")
        let viewModel = AdditionalInfoViewModel(scheduleCallBack: ScheduleCallback(phone: "111-111-1111",
                                                                                   asap: true,
                                                                                   customerCareOption: "I want to know more about Fiber Internet",
                                                                                   handleOption: true,
                                                                                   callbackTime: "2020-11-28 02:00:00",
                                                                                   callbackReason: "Test"))
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goBackToTabView = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.cancelTapObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
}

