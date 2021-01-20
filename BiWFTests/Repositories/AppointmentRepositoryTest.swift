//
//  AppointmentRepositoryTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 16/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class AppointmentRepositoryTest: XCTestCase {
    
    var appointmentRepository: AppointmentRepository?
    
    func testInitialisationEvent() {
        XCTAssertNotNil(appointmentRepository = AppointmentRepository.init(appointmentServiceManager: MockAppointmentServiceManager()))
    }
    
    func testServiceAppointment() {
        appointmentRepository = AppointmentRepository.init(appointmentServiceManager: MockAppointmentServiceManager())
        XCTAssertNotNil(appointmentRepository?.getServiceAppointment(for: ""))
    }
    
    func testGetAppointmentSlots() {
        appointmentRepository = AppointmentRepository.init(appointmentServiceManager: MockAppointmentServiceManager())
        XCTAssertNotNil(appointmentRepository?.getAppointmentSlots(for: "08pf00000008gvCAAQ",
                                                   earliestPermittedDate: "2020-07-14T22:00:00.000+0000"))
    }
    
    func testRescheduleAppointment() {
        appointmentRepository = AppointmentRepository.init(appointmentServiceManager: MockAppointmentServiceManager())
        XCTAssertNotNil(appointmentRepository?.rescheduleAppointment(with: RescheduleAppointment(serviceAppointmentID: "08pf00000008gvCAAQ",
                                                                                 arrivalWindowStartTime: "2020-07-14T22:00:00.000+0000",
                                                                                 ArrivalWindowEndTime: "2020-07-15T22:00:00.000+0000")))
    }
    
    func testCancelAppointment() {
        appointmentRepository = AppointmentRepository.init(appointmentServiceManager: MockAppointmentServiceManager())
        XCTAssertNotNil(appointmentRepository?.cancelAppointment(mockServiceAppointmentObject()))
    }
    
    func mockServiceAppointmentObject() -> ServiceAppointment {
        return ServiceAppointment(arrivalStartTime: "2020-07-14T22:00:00.000+0000",
                                  arrivalEndTime: "2020-07-14T20:00:00.000+0000",
                                  status: "Completed",
                                  workTypeId: "08qf00000008QgpAAE",
                                  jobType: "Fiber Install - For Installations",
                                  appointmentId: "08pf00000008gvCAAQ",
                                  latitude: 39.852448,
                                  longitude: -104.97592,
                                  appointmentNumber: "08pf00000008dTjAAI",
                                  serviceTerritory: ServiceTerritory(operatingHours: OperatingHours(timeZone: "")),
                                  serviceResources: ServiceResourceList(records: [ServiceResource]()))
    }
    
}
