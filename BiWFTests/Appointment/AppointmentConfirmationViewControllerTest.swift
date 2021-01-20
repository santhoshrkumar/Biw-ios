//
//  AppointmentConfirmationViewControllerTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 13/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//
import RxSwift
import XCTest
@testable import BiWF

class AppointmentConfirmationViewControllerTest: XCTestCase {

    /// Instance for AppointmentConfirmationViewController
    var appointmentConfirmationViewController : AppointmentConfirmationViewController?
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "NewUserDashboard", bundle: nil)
        appointmentConfirmationViewController = storyboard.instantiateViewController(withIdentifier: "AppointmentConfirmationViewController")
            as? AppointmentConfirmationViewController
        _ = appointmentConfirmationViewController?.view
        let viewModel = AppointmentConfirmationViewModel(with: ArrivalTime(startTime: Date(), endTime: Date()), appointmentType: AppointmentType.installation)
        appointmentConfirmationViewController?.setViewModel(to: viewModel)
        appointmentConfirmationViewController?.viewWillAppear(true)
    }
    
    override func tearDown() {
           super.tearDown()
           appointmentConfirmationViewController = nil
       }
    
    /// Tests if is AppointmentConfirmationViewController initialized
    func testSanity() {
        XCTAssertNotNil(appointmentConfirmationViewController)
    }

}
