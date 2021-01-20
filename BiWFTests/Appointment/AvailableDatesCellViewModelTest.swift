//
//  AvailableDatesCellViewModelTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 22/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
@testable import BiWF

class AvailableDatesCellViewModelTest: XCTestCase {
    
    let mockAppoinmentService = MockAppointmentServiceManager()
    
    func testInitMethod() {
        let slots = mockAppoinmentService.getAppointmentSlots()
        let viewModel = AvailableDatesCellViewModel(with: slots, appointmentType: AppointmentType.installation)
        XCTAssertNotNil(viewModel)
    }
}
