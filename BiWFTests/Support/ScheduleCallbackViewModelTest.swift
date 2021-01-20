//
//  ScheduleCallbackViewModelTest.swift
//  BiWFTests
//
//  Created by pooja.q.gupta on 30/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class ScheduleCallbackViewModelTest: XCTestCase {
    
    let disposeBag = DisposeBag()
    
    func testBackEvent() {
        
        let testExpectation = expectation(description: "Recieve event to back from schedule callback page")
        let viewModel = ScheduleCallbackViewModel(with: SupportRepository())
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
        let viewModel = ScheduleCallbackViewModel(with: SupportRepository())
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
    
    func testMoveToAdditionalInfoEvent() {
        
        let testExpectation = expectation(description: "Recieve event to move to additonal info")
        let viewModel = ScheduleCallbackViewModel(with: SupportRepository())
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goToAdditionalInfo = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.moveToAdditionalInfoObserver.onNext(ScheduleCallback(phone: "111-111-1111", asap: true, customerCareOption: "I want to know more about Fiber Internet", handleOption: true, callbackTime: "2020-11-28 02:00:00", callbackReason: "Test"))
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testCellSelection() {
        let viewModel = ScheduleCallbackViewModel(with: SupportRepository())
        XCTAssertNotNil(viewModel.input.cellSelectionObserver.onNext(IndexPath(item: 0, section: 0)))
        
    }
}
