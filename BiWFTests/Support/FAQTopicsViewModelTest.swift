//
//  FAQTopicsViewModelTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 20/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class FAQTopicsViewModelTest: XCTestCase {
    
    let disposeBag = DisposeBag()
    let faqTopics = SupportRepository.getFaqTopics(SupportRepository())
    
    func testGoToSupportEvent() {
        let manager = MockSupportServiceManager()
        let testExpectation = expectation(description: "Recieve back event and go to support")
        let viewModel = FAQTopicsViewModel(withRepository: SupportRepository(supportServiceManager: manager),
                                           faqTopics: [FaqRecord]())
        viewModel.output.viewComplete.subscribe(onNext: { event in
            XCTAssertNotNil(event)
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.backObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testDoneEvent() {
        let testExpectation = expectation(description: "Receive done event and go to dashboard")
        let viewModel = FAQTopicsViewModel(withRepository: SupportRepository(supportServiceManager: MockSupportServiceManager()),
                                           faqTopics: [FaqRecord]())
        viewModel.output.viewComplete.subscribe(onNext: { event in
            XCTAssertNotNil(event)
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.doneObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testLiveChatEvent() {
        let testExpectation = expectation(description: "Receive event to navigate to live chat")
        let viewModel = FAQTopicsViewModel(withRepository: SupportRepository(supportServiceManager: MockSupportServiceManager()),
                                           faqTopics: [FaqRecord]())
        viewModel.output.viewComplete.subscribe({ (event) in
            XCTAssertNotNil(event)
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.liveChatObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testScheduleCallbackEvent() {
        let testExpectation = expectation(description: "Receive event to schedule callback")
        let viewModel = FAQTopicsViewModel(withRepository: SupportRepository(supportServiceManager: MockSupportServiceManager()),
                                           faqTopics: [FaqRecord]())
        viewModel.output.viewComplete.subscribe({ (event) in
            XCTAssertNotNil(event)
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.scheduleCallbackObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }

    func testHandleCellSelectionEvent() {
        let testExpectation = expectation(description: "Cell selection")
        let viewModel = FAQTopicsViewModel(withRepository: SupportRepository(supportServiceManager: MockSupportServiceManager()),
        faqTopics: [FaqRecord]())
        
        viewModel.output.viewComplete.subscribe({ (event) in
            XCTAssertNotNil(event)
            testExpectation.fulfill()
        }).disposed(by: disposeBag)

        viewModel.input.cellSelectionObserver.onNext(IndexPath(row: 0, section: 1))
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testUpdateFAQSection() {
        let viewModel = FAQTopicsViewModel(withRepository: SupportRepository(supportServiceManager: MockSupportServiceManager()),
        faqTopics: [FaqRecord(attributes: FaqRecordAttributes(type: "Modem", url: "https://app.zeplin.io/project/5e727d8f615283b2933b424c"), articleNumber: "86730938", articleTotalViewCount: 7, articleContent: "Discussed", articleUrl:  "https://app.zeplin.io/project/5e727d8f615283b2933b424c", Id: "756211", language: "English", sectionC: "", title: "Faq", isAnswerExpanded: true)])
        
        viewModel.updateFAQSection(forIndexpath: IndexPath(item: 0, section: 0), isExpanded: true)
        XCTAssertEqual(viewModel.faqTopicData[0].isAnswerExpanded, false)
        
        viewModel.updateFAQSection(forIndexpath: IndexPath(item: 0, section: 0), isExpanded: false)
        XCTAssertEqual(viewModel.faqTopicData[0].isAnswerExpanded, true)

    }
    
}

