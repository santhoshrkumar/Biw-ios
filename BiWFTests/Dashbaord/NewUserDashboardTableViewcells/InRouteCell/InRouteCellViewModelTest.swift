//
//  InRouteCellViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 21/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class InRouteCellViewModelTest: XCTestCase {

    let serviceResource = ServiceResource(serviceResource: ResourceDetail(name: "com.centurylink.biwf"))

    func testInitMethod() {
        let viewModel = InRouteCellViewModel(appointment: ServiceAppointment(arrivalStartTime: "16:47:18.650", arrivalEndTime: "16:47:18.650", status: "Welcome", workTypeId: "7247:452138", jobType: "Fibre", appointmentId: "18.347567", latitude: 54.77, longitude: 98.009, appointmentNumber: "760", serviceTerritory: ServiceTerritory(operatingHours: OperatingHours(timeZone: "2020-10-21 16:47:18.650")), serviceResources: ServiceResourceList(records: [serviceResource])))
        XCTAssertNotNil(viewModel)
    }
    
    func testGetTitleAndStatus() {
        let viewModel = InRouteCellViewModel(appointment: ServiceAppointment(arrivalStartTime: "2020-07-30T16:00:00.000+0000",
                                                                             arrivalEndTime: "2020-07-30T18:00:00.000+0000",
                                                                             status: "Scheduled",
                                                                             workTypeId: "08qf00000008QgoAAE",
                                                                             jobType: "Fiber Install - For Installations",
                                                                             appointmentId: "08pf00000008gvCAAQ",
                                                                             latitude: 39.852448,
                                                                             longitude: -104.97592,
                                                                             appointmentNumber: "SA-11704",
                                                                             serviceTerritory: nil,
                                                                             serviceResources: nil))
        XCTAssertNotNil(viewModel)
        
    }
}
