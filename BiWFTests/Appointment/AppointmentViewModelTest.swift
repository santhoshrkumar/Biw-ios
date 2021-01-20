//
//  AppointmentViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 09/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class AppointmentViewModelTest: XCTestCase {

    let disposeBag = DisposeBag()
    
    /// Instance for AppointmentConfirmationViewModel
    var viewModel : AppointmentConfirmationViewModel!
    
    /// Testcase for done button tap event
    func testDoneEvent() {
        let testExpectation = expectation(description: "Go back to dashboard after tapping on done")
        let viewModel = AppointmentConfirmationViewModel(with: ArrivalTime(startTime: Date(), endTime: Date()), appointmentType: .installation)
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goBackToDashboard = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.doneTapObserver.onNext(Void())
        wait(for: [testExpectation], timeout: 5)
    }
    
    /// Testcase for viewing the dashboard
    func testViewDashboard() {
        let testExpectation = expectation(description: "Go back to dashboard after viewing the appointment")
        let viewModel = AppointmentConfirmationViewModel(with: ArrivalTime(startTime: Date(), endTime: Date()), appointmentType: .installation)
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goBackToDashboard = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.viewDashboardTapObserver.onNext(Void())
        wait(for: [testExpectation], timeout: 5)
    }
    
}
