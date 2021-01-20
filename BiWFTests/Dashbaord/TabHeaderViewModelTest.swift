//
//  TabHeaderViewModelTest.swift
//  BiWFTests
//
//  Created by nicholas.a.klacik on 4/8/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class TabHeaderViewModelTest: XCTestCase {

    let disposeBag = DisposeBag()

    func testGoToAccountEvent() {
        let testExpectation = expectation(description: "Receive event to navigate to Account Tab")
        let viewModel = TabHeaderViewModel(appointmentRepository: AppointmentRepository(), networkRepository: NetworkRepository())
        viewModel.output.viewComplete.subscribe(onNext: { event in
                guard case .goToAccount = event else {
                    XCTFail()
                    return
                }
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        viewModel.input.accountTapObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }

    func testGoToDashboardEvent() {
        let testExpectation = expectation(description: "Receive event to navigate to Dashboard Tab")
        let viewModel = TabHeaderViewModel(appointmentRepository: AppointmentRepository(), networkRepository: NetworkRepository())
        viewModel.output.viewComplete.subscribe(onNext: { event in
                guard case .goToDashboard = event else {
                    XCTFail()
                    return
                }
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        viewModel.input.dashboardTapObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }

    func testGoToDevicesEvent() {
        let testExpectation = expectation(description: "Receive event to navigate to Devices Tab")
        let viewModel = TabHeaderViewModel(appointmentRepository: AppointmentRepository(), networkRepository: NetworkRepository())
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goToDevices = event else {
                    XCTFail()
                    return
                }
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        viewModel.input.devicesTapObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }

    func testGoToNotificationsEvent() {
        let testExpectation = expectation(description: "Receive event to navigate to Notification View")
        let viewModel = TabHeaderViewModel(appointmentRepository: AppointmentRepository(), networkRepository: NetworkRepository())
        viewModel.output.viewComplete.subscribe(onNext: { event in
                guard case .goToNotifications = event else {
                    XCTFail()
                    return
                }
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        viewModel.input.notificationTapObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }

    func testSelectedObservables() {
        let accountTestExpectation = expectation(description: "Received correct events for accountSelectedObservable")
        let dashboardTestExpectation = expectation(description: "Received correct events for dashboardSelectedObservable")
        let devicesTestExpectation = expectation(description: "Received correct events for devicesSelectedObservable")
        let viewModel = TabHeaderViewModel(appointmentRepository: AppointmentRepository(), networkRepository: NetworkRepository())
        var accountEventNumber = 0
        viewModel.output.accountSelectedObservable.subscribe(onNext: { isSelected in
                accountEventNumber += 1
                if accountEventNumber == 1 {
                    XCTAssertFalse(isSelected)
                } else if accountEventNumber == 2 {
                    XCTAssertTrue(isSelected)
                } else if accountEventNumber == 3 {
                    XCTAssertFalse(isSelected)
                } else if accountEventNumber == 4 {
                    XCTAssertFalse(isSelected)
                    accountTestExpectation.fulfill()
                }
            }).disposed(by: disposeBag)

        var dashboardEventNumber = 0
        viewModel.output.dashboardSelectedObservable.subscribe(onNext: { isSelected in
                dashboardEventNumber += 1
                if dashboardEventNumber == 1 {
                    XCTAssertTrue(isSelected)
                } else if dashboardEventNumber == 2 {
                    XCTAssertFalse(isSelected)
                } else if dashboardEventNumber == 3 {
                    XCTAssertTrue(isSelected)
                } else if dashboardEventNumber == 4 {
                    XCTAssertFalse(isSelected)
                    dashboardTestExpectation.fulfill()
                }
            }).disposed(by: disposeBag)

        var devicesEventNumber = 0
        viewModel.output.devicesSelectedObservable.subscribe(onNext: { isSelected in
                devicesEventNumber += 1
                if devicesEventNumber == 1 {
                    XCTAssertFalse(isSelected)
                } else if devicesEventNumber == 2 {
                    XCTAssertFalse(isSelected)
                } else if devicesEventNumber == 3 {
                    XCTAssertFalse(isSelected)
                } else if devicesEventNumber == 4 {
                    XCTAssertTrue(isSelected)
                    devicesTestExpectation.fulfill()
                }
            }).disposed(by: disposeBag)

        viewModel.input.accountTapObserver.onNext(())
        viewModel.input.dashboardTapObserver.onNext(())
        viewModel.input.devicesTapObserver.onNext(())
        wait(for: [accountTestExpectation, dashboardTestExpectation, devicesTestExpectation], timeout: 5)
    }
}
