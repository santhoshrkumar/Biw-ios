//
//  ModifyAppointmentViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 13/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class ModifyAppointmentViewModelTest: XCTestCase {
    
    let oldSlots = ["2020-7-20": [
      "08:00 AM - 10:00 AM",
      "10:00 AM - 12:00 PM",
      "12:00 PM - 02:00 PM",
      "02:00 PM - 04:00 PM"
    ]]
    let newSlots = ["2020-7-21": [
      "08:00 AM - 10:00 AM",
      "10:00 AM - 12:00 PM",
      "12:00 PM - 02:00 PM",
      "02:00 PM - 04:00 PM"
    ]]

    let disposeBag = DisposeBag()
    
    /// Instacne for ModifyAppointmentViewModel
    var viewModel = ModifyAppointmentViewModel(with: ServiceAppointment(arrivalStartTime: "2020-07-30T16:00:00.000+0000", arrivalEndTime: "2020-07-30T16:00:00.000+0000", status: "Booked", workTypeId: "Home", jobType: "Develop", appointmentId: "20200-30T160", latitude: 32.2, longitude: 43.3, appointmentNumber: "202007", serviceTerritory: ServiceTerritory(operatingHours: OperatingHours(timeZone: "OperatingHours")), serviceResources: ServiceResourceList(records: [ServiceResource(serviceResource: ResourceDetail.init(name: "Appointment"))])), and: AppointmentRepository())
    
    /// Testcase for back button event
    func testBackEvent() {
        let testExpectation = expectation(description: "Go back to dashboard after tapping on done")
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goBackToDashboard = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.backTapObserver.onNext(Void())
        wait(for: [testExpectation], timeout: 5)
    }

    /// Testcase for Confirmation on appointment
    func testAppointmentConfirm() {
        let testExpectation = expectation(description: "Go to appointment booking")
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goToAppointmentBookingConfirmation = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.appointmentConfirmationObserver.onNext((ArrivalTime(startTime: Date(), endTime: Date()), .installation))
        wait(for: [testExpectation], timeout: 5)
    }
    
    /// Testcase for SetSection method
    func testSetSections() {
        XCTAssertNotNil(viewModel.setSections())
    }
    
    /// Testcase for SetSection method
    func testCreateSubscription() {
        XCTAssertNotNil(viewModel.createSubscription())
        viewModel.repository.errorMessage.onNext("No error")
        viewModel.repository.rescheduleAppointmentErrorMsg.onNext("No error")
        viewModel.repository.appointmentSlots.onNext(AvailableSlotsResponse(slotsValue: oldSlots, appointmentId: "20200-30T160"))
    }
    
    /// Testcase for GetAvailableSlots method
    func testGetAvailableSlots() {
        XCTAssertNotNil(viewModel.getAvailableSlots(for: Date()))
    }
    
    /// Testcase for RescheduleAppointment method
    func testRescheduleAppointment() {
        XCTAssertNotNil(viewModel.rescheduleAppointment(with: Date(), endTime: Date()))
        viewModel.repository.rescheduleAppointmentStatus.onNext(RescheduleAppointmentResponse(status: "Reshedule"))
    }
    
    /// Testcase for CheckForAvailableSlots method
    func testCheckForAvailableSlots() {
        XCTAssertNotNil(viewModel.checkForAvailableSlots(shouldClearData: true))
    }
    
    /// Testcase for CheckForAvailableSlots method
    func testMergeSlots() {
        XCTAssertNotNil(viewModel.mergeSlots(oldSlots: oldSlots, newSlots: newSlots))
    }
}
