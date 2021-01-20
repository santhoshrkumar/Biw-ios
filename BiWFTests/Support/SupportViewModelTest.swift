//
//  SupportViewModelTest.swift
//  BiWFTests
//
//  Created by pooja.q.gupta on 14/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class SupportViewModelTest: XCTestCase {
    let disposeBag = DisposeBag()
    
    func testVisitWebsiteEvent() {
        let testExpectation = expectation(description: "Receive event to navigate to website")
        
        let viewModel = SupportViewModel(
            with: SupportRepository(supportServiceManager: MockSupportServiceManager()), and: NetworkRepository())
        
        viewModel.output.viewComplete.subscribe(onNext: { event in
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.visitWebsiteObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testLiveChatEvent() {
        let testExpectation = expectation(description: "Receive event to navigate to live chat")
        
        let viewModel = SupportViewModel(
            with: SupportRepository(supportServiceManager: MockSupportServiceManager()), and: NetworkRepository())
        
        viewModel.output.viewComplete.subscribe({ event in
            XCTAssertNotNil(event)
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.liveChatObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testScheduleCallbackEvent() {
        let testExpectation = expectation(description: "Receive event to schedule callback")
        
        let viewModel = SupportViewModel(
            with: SupportRepository(supportServiceManager: MockSupportServiceManager()), and: NetworkRepository())
        
        viewModel.output.viewComplete.subscribe({ (event) in
            XCTAssertNotNil(event)
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.scheduleCallbackObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testCloseEvent() {
        let testExpectation = expectation(description: "Receive event close view")
        
        let viewModel = SupportViewModel(
            with: SupportRepository(supportServiceManager: MockSupportServiceManager()), and: NetworkRepository())
        
        viewModel.output.viewComplete.subscribe({ (event) in
            XCTAssertNotNil(event)
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.closeObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    ///TODO: check later
    func testGoToFaqEvent() {
//        let testExpectation = expectation(description: "Receive event to navigate to Faq view")
//        let viewModel = SupportViewModel(with: SupportRepository(), and: NetworkRepository())
//
//        viewModel.output.viewComplete.subscribe({ (event) in
//            XCTAssertNotNil(event)
//            testExpectation.fulfill()
//        }).disposed(by: disposeBag)
//
//        viewModel.input.goToFaqObserver.onNext(([FaqRecord]()))
//        wait(for: [testExpectation], timeout: 5)
    }
    
    func testHandleCellSelectionEvent() {
        let testExpectation = expectation(description: "Cell selection")
        let viewModel = SupportViewModel(with: SupportRepository(), and: NetworkRepository())
        
        viewModel.output.viewComplete.subscribe({ (event) in
            XCTAssertNotNil(event)
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        let repository = SupportRepository()
        repository.getFaqTopics(forRecordID: "012f0000000l1hsAAA")
        repository.faqListResult
            .subscribe(onNext: { details in
                viewModel.faqRecords = details.getFaqSectionList()
            }).disposed(by: self.disposeBag)
        
        viewModel.setSections()
        _ = viewModel.handleSeperator(for: 0)
        _ = viewModel.handleSeperator(for: 1)
        _ = viewModel.handleSeperator(for: 2)
        _ = viewModel.handleSeperator(for: 3)
        _ = viewModel.createTopicItem(withKey: "How to change my account")
        viewModel.handleCellSelection(for: IndexPath(row: 0, section: 0))
        viewModel.handleCellSelection(for: IndexPath(row: 1, section: 2))
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testCallUsEvent() {
        let testExpectation = expectation(description: "Restart Modem")
        let viewModel = SupportViewModel(with: SupportRepository(), and: NetworkRepository())
        viewModel.output.callUsAtTextDriver.drive(onNext: { value in
            XCTAssertNotNil(value)
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.handleCellSelection(for: IndexPath(row: 1, section: 2))
        viewModel.handleCellSelection(for: IndexPath(row: 0, section: 3))
        viewModel.input.restartModem.onNext(())
        viewModel.input.runSpeedTestObserver.onNext(())
        viewModel.input.callUsObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testGetFaqList() {
        let viewModel = SupportViewModel(
            with: SupportRepository(supportServiceManager: MockSupportServiceManager()), and: NetworkRepository())
        viewModel.repository.recordIDResult.onNext("012f0000000l0wrAAA")
        let mockSupportServiceManager = MockSupportServiceManager()
        viewModel.repository.faqListResult.onNext(mockSupportServiceManager.getFAQList())
        
    }
    
    func testErrorResponse() {
        let viewModel = SupportViewModel(
            with: SupportRepository(supportServiceManager: MockSupportServiceManager()), and: NetworkRepository())
        viewModel.repository.errorMessage.onNext("Error occured")
    }
}
