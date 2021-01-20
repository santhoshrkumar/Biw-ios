//
//  DashboardNotificationsCellViewModelTest.swift
//  BiWFTests
//
//  Created by nicholas.a.klacik on 4/21/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class DashboardNotificationsCellViewModelTest: XCTestCase {

    let disposeBag = DisposeBag()
    let notification1 = Notification(id: 1,
                                    name: "CenturyLink Extends Employee Benefits",
                                    description: "As the COVID-19 outbreak continues to spread across the United States — affecting the livelihoods of millions of workers — CenturyLink is taking an immediate, aggressive, and industry-leading",
                                    imageUrl: "https://news.centurylink.com/images/ctl-logo-black.svg",
                                    isUnRead: true,
                                    detailUrl: "https://news.centurylink.com/news?category=801&l=10")
    
    let notification2 = Notification(id: 2,
                                    name: "CenturyLink Simplifies Cloud Networking",
                                    description: "Businesses have a new, secure option for integrating cloud infrastructure via IBM Cloud Direct Link services",
                                    imageUrl: "https://news.centurylink.com/images/ctl-logo-black.svg",
                                    isUnRead: true,
                                    detailUrl: "https://news.centurylink.com/2020-03-10-CenturyLink-Simplifies-Cloud-Networking-with-Self-Service-Connectivity-to-IBM-Cloud")
    let notification3 = Notification(id: 3,
                                    name: "CenturyLink Celebrations of International Women's Day",
                                    description: "CenturyLink (NYSE: CTL) is dedicated to celebrating diversity in the workplace. ",
                                    imageUrl: "https://news.centurylink.com/images/ctl-logo-black.svg",
                                    isUnRead: true,
                                    detailUrl: "https://news.centurylink.com/2020-03-06-CenturyLink-Expands-Its-Celebrations-of-International-Womens-Day-and-Womens-History-Month")

    let notification4 = Notification(id: 4,
                                    name: "Sumter County, Fla., Selects CenturyLink to Deliver",
                                    description: "Sumter County, Fla., recently selected CenturyLink to deliver a faster, more resilient 911 system",
                                    imageUrl: "https://news.centurylink.com/images/ctl-logo-black.svg",
                                    isUnRead: true,
                                    detailUrl: "https://news.centurylink.com/2020-03-05-Sumter-County-Fla-Selects-CenturyLink-to-Deliver-Next-Gen-911-System")

    func testTopViewModel() {
        let testExpectation = expectation(description: "Receive first notification as top viewModel")
        let notifications = [notification1, notification2, notification3, notification4]
        let viewModel = DashboardNotificationsCellViewModel(notifications: notifications)
        viewModel.output.topViewModelObservable.subscribe(onNext: { [weak self] topViewModel in
                guard let self = self else { return }
                guard let topViewModel = topViewModel else { return }
                topViewModel.output.nameTextDriver.drive(onNext: { [weak self] name in
                    guard let self = self else { return }
                    XCTAssertEqual(name, self.notification1.name)
                    testExpectation.fulfill()
                }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)

        wait(for: [testExpectation], timeout: 5)
    }

    func testHideViewTrue() {
        let testExpectation = expectation(description: "Receive event to hide the cell")
        let notifications = [notification1]
        let viewModel = DashboardNotificationsCellViewModel(notifications: notifications)
        
        viewModel.output.hideViewObservable.subscribe(onNext: { hideView in
                XCTAssertTrue(hideView)
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        viewModel.output.topViewModelObservable.take(1).subscribe(onNext: { topViewModel in
                guard let topViewModel = topViewModel else { return }
                topViewModel.input.closeTappedObvserver.onNext(())
            }).disposed(by: disposeBag)

        wait(for: [testExpectation], timeout: 5)
    }

    func testHideViewFalse() {
        let testExpectation = expectation(description: "Receive event to not hide the cell")
        let notifications = [notification1, notification2]
        let viewModel = DashboardNotificationsCellViewModel(notifications: notifications)
        viewModel.output.hideViewObservable.subscribe(onNext: { hideView in
                XCTAssertFalse(hideView)
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        viewModel.output.topViewModelObservable.take(1).subscribe(onNext: { topViewModel in
                guard let topViewModel = topViewModel else { return }
                topViewModel.input.closeTappedObvserver.onNext(())
            }).disposed(by: disposeBag)

        wait(for: [testExpectation], timeout: 5)
    }

    func testHideSecondViewTrue() {
        let testExpectation = expectation(description: "Receive event to hide the second view")
        let notifications = [notification1, notification2]
        let viewModel = DashboardNotificationsCellViewModel(notifications: notifications)
        
        viewModel.output.hideSecondViewObservable.subscribe(onNext: { hideView in
                XCTAssertTrue(hideView)
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        viewModel.output.topViewModelObservable.take(1).subscribe(onNext: { topViewModel in
                guard let topViewModel = topViewModel else { return }
                topViewModel.input.closeTappedObvserver.onNext(())
            }).disposed(by: disposeBag)

        wait(for: [testExpectation], timeout: 5)
    }

    func testHideSecondViewFalse() {
        let testExpectation = expectation(description: "Receive event to not hide the second view")
        let notifications = [notification1, notification2, notification3]
        let viewModel = DashboardNotificationsCellViewModel(notifications: notifications)
        
        viewModel.output.hideSecondViewObservable.subscribe(onNext: { hideView in
                XCTAssertFalse(hideView)
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        viewModel.output.topViewModelObservable.take(1).subscribe(onNext: { topViewModel in
                guard let topViewModel = topViewModel else { return }
                topViewModel.input.closeTappedObvserver.onNext(())
            }).disposed(by: disposeBag)

        wait(for: [testExpectation], timeout: 5)
    }

    func testHideThirdViewTrue() {
        let testExpectation = expectation(description: "Receive event to hide the third view")
        let notifications = [notification1, notification2, notification3]
        let viewModel = DashboardNotificationsCellViewModel(notifications: notifications)
        
        viewModel.output.hideThirdViewObservable.subscribe(onNext: { hideView in
                XCTAssertTrue(hideView)
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        viewModel.output.topViewModelObservable.take(1).subscribe(onNext: { topViewModel in
                guard let topViewModel = topViewModel else { return }
                topViewModel.input.closeTappedObvserver.onNext(())
            }).disposed(by: disposeBag)

        wait(for: [testExpectation], timeout: 5)
    }

    func testHideThirdViewFalse() {
        let testExpectation = expectation(description: "Receive event to not hide the third view")
        let notifications = [notification1, notification2, notification3, notification4]
        let viewModel = DashboardNotificationsCellViewModel(notifications: notifications)
        
        viewModel.output.hideThirdViewObservable.subscribe(onNext: { hideView in
                XCTAssertFalse(hideView)
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        viewModel.output.topViewModelObservable.take(1).subscribe(onNext: { topViewModel in
                guard let topViewModel = topViewModel else { return }
                topViewModel.input.closeTappedObvserver.onNext(())
            }).disposed(by: disposeBag)

        wait(for: [testExpectation], timeout: 5)
    }

    func testOpenNotificationEvent() {
        let testExpectation = expectation(description: "Receive event to open top notification")
        let notifications = [notification1, notification2, notification3, notification4]
        let viewModel = DashboardNotificationsCellViewModel(notifications: notifications)
        
        viewModel.output.openNotificationDetailObservable.debug().subscribe(onNext: { [weak self] url in
            guard let self = self else { return }
            XCTAssertEqual(url, self.notification1.detailUrl)
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        viewModel.output.topViewModelObservable.take(1).subscribe(onNext: { topViewModel in
                guard let topViewModel = topViewModel else { return }
                topViewModel.input.openNotificationDetailsObserver.onNext(())
            }).disposed(by: disposeBag)

        wait(for: [testExpectation], timeout: 5)
    }

    func testCloseNotification() {
        let testExpectation = expectation(description: "TopViewModel updated after closing top notification")
        let notifications = [notification1, notification2, notification3, notification4]
        let viewModel = DashboardNotificationsCellViewModel(notifications: notifications)
        
        var eventCount = 0
        viewModel.output.topViewModelObservable.take(2).subscribe(onNext: { [weak self] topViewModel in
            guard let self = self else { return }
            guard let topViewModel = topViewModel else { return }
            eventCount += 1
            if eventCount == 1 {
                topViewModel.input.closeTappedObvserver.onNext(())
            } else if eventCount == 2 {
                topViewModel.output.nameTextDriver.drive(onNext: { [weak self] name in
                    guard let self = self else { return }
                    XCTAssertEqual(name, self.notification2.name)
                    testExpectation.fulfill()
                }).disposed(by: self.disposeBag)
            }
        }).disposed(by: disposeBag)

        wait(for: [testExpectation], timeout: 5)
    }
}
