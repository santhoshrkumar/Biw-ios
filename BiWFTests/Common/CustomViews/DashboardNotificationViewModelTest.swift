//
//  DashboardNotificationViewModelTest.swift
//  BiWFTests
//
//  Created by nicholas.a.klacik on 4/21/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class DashboardNotificationViewModelTest: XCTestCase {
    var subject: DashboardNotificationViewModel!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        let notification = Notification(id: 1,
        name: "CenturyLink Extends Employee Benefits",
        description: "As the COVID-19 outbreak continues to spread across the United States — affecting the livelihoods of millions of workers — CenturyLink is taking an immediate, aggressive, and industry-leading",
        imageUrl: "https://news.centurylink.com/images/ctl-logo-black.svg",
        isUnRead: true,
        detailUrl: "https://news.centurylink.com/news?category=801&l=10")

        disposeBag = DisposeBag()
        subject = DashboardNotificationViewModel(notification: notification)
    }

    override func tearDown() {
        super.tearDown()

        subject = nil
        disposeBag = nil
    }

    func testCloseEvent() {
        let testExpectation = expectation(description: "Receive event to close view")
        subject.output.closeViewObservable.subscribe(onNext: { _ in
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        subject.input.closeTappedObvserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }

    func testOpenNotificationEvent() {
        let testExpectation = expectation(description: "Receive event to open Notification")
        subject.output.openNotificationDetailsObservable.subscribe(onNext: { url in
                XCTAssertEqual(url, "https://news.centurylink.com/news?category=801&l=10")
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        subject.input.openNotificationDetailsObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }

    func testNameText() {
        let testExpectation = expectation(description: "Receive correct notification text from driver")
        subject.output.nameTextDriver.drive(onNext: { name in
                XCTAssertEqual(name, "CenturyLink Extends Employee Benefits")
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        wait(for: [testExpectation], timeout: 5)
    }

    func testDescriptionText() {
        let testExpectation = expectation(description: "Receive correct description text from driver")
        subject.output.descriptionTextDriver.drive(onNext: { description in
                XCTAssertEqual(description, "As the COVID-19 outbreak continues to spread across the United States — affecting the livelihoods of millions of workers — CenturyLink is taking an immediate, aggressive, and industry-leading")
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        wait(for: [testExpectation], timeout: 5)
    }
}
