//
//  NotificationViewModelTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 02/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class NotificationViewModelTest: XCTestCase {

    let disposeBag = DisposeBag()
    let notification = Notification(id: 1, name: "CenturyLink Extends Employee Benefits", description: "As the COVID-19 outbreak continues to spread across the United States — affecting the livelihoods of millions of workers — CenturyLink is taking an immediate, aggressive, and industry-leading", imageUrl: "https://news.centurylink.com/images/ctl-logo-black.svg", isUnRead: true, detailUrl: "https://news.centurylink.com/news?category=801&l=10")

    func testNotificationEvent() {
        let testExpectation = expectation(description: "Receive event to open navigation details")
        let viewModel = NotificationViewModel(withRepository: NotificationRepository())
        
        viewModel.output.viewComplete.subscribe({ (event) in
            XCTAssertNotNil(event)
            testExpectation.fulfill()
        }).disposed(by: disposeBag)

        viewModel.input.openDetailsObserver?.onNext(notification.detailUrl)
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testCloseEvent() {
        let testExpectation = expectation(description: "Receive event to close navigation details")
        let viewModel = NotificationViewModel(withRepository: NotificationRepository())
        
        viewModel.output.viewComplete.subscribe({ (event) in
            XCTAssertNotNil(event)
            testExpectation.fulfill()
        }).disposed(by: disposeBag)

        viewModel.input.closeObserver.onNext(Void())
        wait(for: [testExpectation], timeout: 5)
    }

    func testDataSourceEvent() {
        let testExpectation = expectation(description: "Receive event to store datasource")
        let viewModel = NotificationViewModel(withRepository: NotificationRepository())
        
        viewModel.output.viewComplete.subscribe({ (event) in
            XCTAssertNotNil(event)
            testExpectation.fulfill()
        }).disposed(by: disposeBag)

        viewModel.input.dataSourceObserver.onNext([notification])
        wait(for: [testExpectation], timeout: 5)
    }
}

