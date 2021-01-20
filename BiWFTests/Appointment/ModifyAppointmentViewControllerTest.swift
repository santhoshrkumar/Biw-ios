//
//  ModifyAppointmentViewControllerTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 13/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class ModifyAppointmentViewControllerTest: XCTestCase {

    /// Instance for ModifyAppointmentViewController
    var modifyAppointmentViewController : ModifyAppointmentViewController?
    let disposeBag = DisposeBag()

    override func setUp() {
        let storyboard = UIStoryboard(name: "NewUserDashboard", bundle: nil)
        modifyAppointmentViewController = storyboard.instantiateViewController(withIdentifier: "ModifyAppointmentViewController")
            as? ModifyAppointmentViewController
        _ = modifyAppointmentViewController?.view
        let viewModel = ModifyAppointmentViewModel(with: ServiceAppointment(arrivalStartTime: "2020-07-30T16:00:00.000+0000", arrivalEndTime: "2020-07-30T16:00:00.000+0000", status: "Booked", workTypeId: "Home", jobType: "Develop", appointmentId: "20200-30T160", latitude: 32.2, longitude: 43.3, appointmentNumber: "202007", serviceTerritory: ServiceTerritory(operatingHours: OperatingHours(timeZone: "OperatingHours")), serviceResources: ServiceResourceList(records: [ServiceResource(serviceResource: ResourceDetail.init(name: "Appointment"))])), and: AppointmentRepository())
        modifyAppointmentViewController?.setViewModel(to: viewModel)
        modifyAppointmentViewController?.viewWillAppear(true)
    }
    
    override func tearDown() {
           super.tearDown()
           modifyAppointmentViewController = nil
       }
    
    /// Tests if is ModifyAppointmentViewController initialized
    func testSanity() {
        XCTAssertNotNil(modifyAppointmentViewController)
    }
    
    /// Shows binding datasource is success and have some value
    func testDatasource() {
        XCTAssertNotNil(modifyAppointmentViewController?.dataSource())
    }
    
    func testHeightForHeaderInSection() {
        if let tableView = modifyAppointmentViewController?.tableView {
            XCTAssertEqual(modifyAppointmentViewController?.tableView(tableView, heightForHeaderInSection: Int(UITableView.automaticDimension)), 0)
        }
    }
    
    func testViewForHeaderInSection() {
        if let tableView = modifyAppointmentViewController?.tableView {
            XCTAssertNotNil(modifyAppointmentViewController?.tableView(tableView, viewForHeaderInSection: 0))
            
            var headerView = modifyAppointmentViewController?.tableView(tableView, viewForHeaderInSection: 0) as! AvailableSlotHeaderView
            XCTAssertNotNil(headerView.setViewModel(to: AvailableSlotHeaderViewModel(title: "test", showErrorMessage: false)))
        }
    }    
}
