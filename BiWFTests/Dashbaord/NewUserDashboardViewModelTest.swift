//
//  NewUserDashboardViewModelTest.swift
//  BiWFTests
//
//  Created by pooja.q.gupta on 06/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class NewUserDashboardViewModelTest: XCTestCase {
    
    let disposeBag = DisposeBag()
    
    func testChangeAppointmentEvent() {
        let testExpectation = expectation(description: "Receive event to navigate to change appointment view")
        let serviceAppointment = ServiceAppointment(arrivalStartTime: "2020-07-30T16:00:00.000+0000",
                                                    arrivalEndTime: "2020-07-30T18:00:00.000+0000",
                                                    status: "Scheduled",
                                                    workTypeId: "08qf00000008QgoAAE",
                                                    jobType: "Fiber Repair - No Service",
                                                    appointmentId: "08pf00000008gvCAAQ",
                                                    latitude: 39.852448,
                                                    longitude: -104.97592,
                                                    appointmentNumber: "SA-11704",
                                                    serviceTerritory: nil,
                                                    serviceResources: nil)
        let viewModel = CommonDashboardViewModel(with: AppointmentRepository.init(appointmentServiceManager:  MockAppointmentServiceManager()))
        
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goToChangeAppointment = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.changeAppointmentObserver.onNext((serviceAppointment))
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testGetStartedEvent() {
        let testExpectation = expectation(description: "Receive event to get started")
        let viewModel = CommonDashboardViewModel(with: AppointmentRepository.init(appointmentServiceManager:  MockAppointmentServiceManager()))
        
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goToStandardDashboard = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.getStartedTapObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testMoveToStandardDashboardEvent() {
        let testExpectation = expectation(description: "Receive event to move to standard dashboard")
        let viewModel = CommonDashboardViewModel(with: AppointmentRepository.init(appointmentServiceManager:  MockAppointmentServiceManager()))
        
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goToStandardDashboard = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.moveToStandardDashboardObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testSection() {
        let testExpectation = expectation(description: "Receive sections from view model")
        let viewModel = CommonDashboardViewModel(with: AppointmentRepository.init(appointmentServiceManager:  MockAppointmentServiceManager()))
        viewModel.currentAppointment = ServiceAppointment(arrivalStartTime: "2020-07-30T16:00:00.000+0000",
                                                          arrivalEndTime: "2020-07-30T18:00:00.000+0000",
                                                          status: "Completed",
                                                          workTypeId: "08qf00000008QgoAAE",
                                                          jobType: "Fiber Repair - No Service",
                                                          appointmentId: "08pf00000008gvCAAQ",
                                                          latitude: 39.852448,
                                                          longitude: -104.97592,
                                                          appointmentNumber: "SA-11704",
                                                          serviceTerritory: nil,
                                                          serviceResources: nil)
        viewModel.sections.subscribe(onNext: { sections in
            if !sections.isEmpty {
                testExpectation.fulfill()
            }
        }).disposed(by: disposeBag)
        
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testCreateSubscription() {
        let viewModel = CommonDashboardViewModel(with: AppointmentRepository.init(appointmentServiceManager:  MockAppointmentServiceManager()))
        XCTAssertNotNil(viewModel.createSubscription())
    }
    
    func testCancelAppointment() {
        let viewModel = CommonDashboardViewModel(with: AppointmentRepository.init(appointmentServiceManager:  MockAppointmentServiceManager()))
        XCTAssertNotNil(viewModel.cancelAppointment())
    }
    
    func testCheckForArrivalTimeAndAddTimer() {
        let viewModel = CommonDashboardViewModel(with: AppointmentRepository.init(appointmentServiceManager:  MockAppointmentServiceManager()))
        viewModel.currentAppointment = ServiceAppointment(arrivalStartTime: "2020-07-30T16:00:00.000+0000",
                                                          arrivalEndTime: "2020-07-30T18:00:00.000+0000",
                                                          status: "Completed",
                                                          workTypeId: "08qf00000008QgoAAE",
                                                          jobType: "Fiber Repair - No Service",
                                                          appointmentId: "08pf00000008gvCAAQ",
                                                          latitude: 39.852448,
                                                          longitude: -104.97592,
                                                          appointmentNumber: "SA-11704",
                                                          serviceTerritory: nil,
                                                          serviceResources: nil)
        XCTAssertNotNil(viewModel.checkForArrivalTimeAndAddTimer())
    }
    
    func testAddTimer() {
        let viewModel = CommonDashboardViewModel(with: AppointmentRepository.init(appointmentServiceManager:  MockAppointmentServiceManager()))
        XCTAssertNotNil(viewModel.addTimer())
        
    }
    
    func testWelcomeCellWithViewModel() {
        let viewModel = CommonDashboardViewModel(with: AppointmentRepository.init(appointmentServiceManager:  MockAppointmentServiceManager()))
        let serviceAppointment = ServiceAppointment(arrivalStartTime: "2020-07-30T16:00:00.000+0000", arrivalEndTime: "2020-07-30T16:00:00.000+0000", status: "Booked", workTypeId: "Home", jobType: "Develop", appointmentId: "20200-30T160", latitude: 32.2, longitude: 43.3, appointmentNumber: "202007", serviceTerritory: ServiceTerritory(operatingHours: OperatingHours(timeZone: "OperatingHours")), serviceResources: ServiceResourceList(records: [ServiceResource(serviceResource: ResourceDetail.init(name: "Appointment"))]))
        let welcomeItem = viewModel.createWelcomeCell(for: serviceAppointment)
        XCTAssertNotNil(welcomeItem)
        (welcomeItem.viewModel as! WelcomeCellViewModel).dismissWelcomeSubject.onNext(())
    }
    
    func testInstallationScheduledCellWithViewModel() {
        let viewModel = CommonDashboardViewModel(with: AppointmentRepository.init(appointmentServiceManager:  MockAppointmentServiceManager()))
        let serviceAppointment = ServiceAppointment(arrivalStartTime: "2020-07-30T16:00:00.000+0000", arrivalEndTime: "2020-07-30T16:00:00.000+0000", status: "Booked", workTypeId: "Home", jobType: "Develop", appointmentId: "20200-30T160", latitude: 32.2, longitude: 43.3, appointmentNumber: "202007", serviceTerritory: ServiceTerritory(operatingHours: OperatingHours(timeZone: "OperatingHours")), serviceResources: ServiceResourceList(records: [ServiceResource(serviceResource: ResourceDetail.init(name: "Appointment"))]))
        viewModel.currentAppointment = serviceAppointment
        
        let createInstallationScheduledItem = viewModel.createInstallationScheduledCell(for: serviceAppointment)
        XCTAssertNotNil(createInstallationScheduledItem)
        XCTAssertNotNil((createInstallationScheduledItem.viewModel as! InstallationScheduledCellViewModel).input.changeAppointmentObserver.onNext(()))
        XCTAssertNotNil((createInstallationScheduledItem.viewModel as! InstallationScheduledCellViewModel).input.changeAppointmentObserver.onNext(()))
    }
    
    func testInProgressCellWithViewModel() {
        let viewModel = CommonDashboardViewModel(with: AppointmentRepository.init(appointmentServiceManager:  MockAppointmentServiceManager()))
        let serviceAppointment = ServiceAppointment(arrivalStartTime: "2020-07-30T16:00:00.000+0000", arrivalEndTime: "2020-07-30T16:00:00.000+0000", status: "Booked", workTypeId: "Home", jobType: "Develop", appointmentId: "20200-30T160", latitude: 32.2, longitude: 43.3, appointmentNumber: "202007", serviceTerritory: ServiceTerritory(operatingHours: OperatingHours(timeZone: "OperatingHours")), serviceResources: ServiceResourceList(records: [ServiceResource(serviceResource: ResourceDetail.init(name: "Appointment"))]))
        XCTAssertNotNil(viewModel.createInProgressCell(for: serviceAppointment))
    }
    
    func testInstalltionCell () {
        let viewModel = CommonDashboardViewModel(with: AppointmentRepository.init(appointmentServiceManager:  MockAppointmentServiceManager()))
               let serviceAppointment = ServiceAppointment(arrivalStartTime: "2020-07-30T16:00:00.000+0000", arrivalEndTime: "2020-07-30T16:00:00.000+0000", status: "Booked", workTypeId: "Home", jobType: "Develop", appointmentId: "20200-30T160", latitude: 32.2, longitude: 43.3, appointmentNumber: "202007", serviceTerritory: ServiceTerritory(operatingHours: OperatingHours(timeZone: "OperatingHours")), serviceResources: ServiceResourceList(records: [ServiceResource(serviceResource: ResourceDetail.init(name: "Appointment"))]))
        XCTAssertNotNil(viewModel.createInstallationCompletedCell(for: serviceAppointment))
        XCTAssertNotNil(viewModel.createInstallationCancelledCell(for: serviceAppointment))
        XCTAssertNotNil(viewModel.createInstallationCancelledCell(for: serviceAppointment))
        XCTAssertNotNil(viewModel.createInRouteCell(for: serviceAppointment))
    }
    
    func testGetServiceAppointment() {
        let viewModel = CommonDashboardViewModel(with: AppointmentRepository.init(appointmentServiceManager:  MockAppointmentServiceManager()))
        XCTAssertNotNil(viewModel.getServiceAppointment())
    }

    func testCurrentAppointment() {
        let viewModel = CommonDashboardViewModel(with: AppointmentRepository.init(appointmentServiceManager:  MockAppointmentServiceManager()))
        viewModel.currentAppointment = ServiceAppointment(arrivalStartTime: "2020-07-30T16:00:00.000+0000",
                                                          arrivalEndTime: "2020-07-30T18:00:00.000+0000",
                                                          status: "Completed",
                                                          workTypeId: "08qf00000008QgoAAE",
                                                          jobType: "Fiber Repair - No Service",
                                                          appointmentId: "08pf00000008gvCAAQ",
                                                          latitude: 39.852448,
                                                          longitude: -104.97592,
                                                          appointmentNumber: "SA-11704",
                                                          serviceTerritory: nil,
                                                          serviceResources: nil)
        
        viewModel.currentAppointment = ServiceAppointment(arrivalStartTime: "2020-07-30T16:00:00.000+0000",
                                                          arrivalEndTime: "2020-07-30T18:00:00.000+0000",
                                                          status: "Canceled",
                                                          workTypeId: "08qf00000008QgoAAE",
                                                          jobType: "Fiber Repair - No Service",
                                                          appointmentId: "08pf00000008gvCAAQ",
                                                          latitude: 39.852448,
                                                          longitude: -104.97592,
                                                          appointmentNumber: "SA-11704",
                                                          serviceTerritory: nil,
                                                          serviceResources: nil)
        viewModel.currentAppointment = ServiceAppointment(arrivalStartTime: "2020-07-30T16:00:00.000+0000",
                                                          arrivalEndTime: "2020-07-30T18:00:00.000+0000",
                                                          status: "Scheduled",
                                                          workTypeId: "08qf00000008QgoAAE",
                                                          jobType: "Fiber Repair - No Service",
                                                          appointmentId: "08pf00000008gvCAAQ",
                                                          latitude: 39.852448,
                                                          longitude: -104.97592,
                                                          appointmentNumber: "SA-11704",
                                                          serviceTerritory: nil,
                                                          serviceResources: nil)
        
        viewModel.currentAppointment = ServiceAppointment(arrivalStartTime: "2020-07-30T16:00:00.000+0000",
                                                          arrivalEndTime: "2020-07-30T18:00:00.000+0000",
                                                          status: "Enroute",
                                                          workTypeId: "08qf00000008QgoAAE",
                                                          jobType: "Fiber Repair - No Service",
                                                          appointmentId: "08pf00000008gvCAAQ",
                                                          latitude: 39.852448,
                                                          longitude: -104.97592,
                                                          appointmentNumber: "SA-11704",
                                                          serviceTerritory: nil,
                                                          serviceResources: nil)
        
        viewModel.currentAppointment = ServiceAppointment(arrivalStartTime: "2020-07-30T16:00:00.000+0000",
                                                          arrivalEndTime: "2020-07-30T18:00:00.000+0000",
                                                          status: "Work Begun",
                                                          workTypeId: "08qf00000008QgoAAE",
                                                          jobType: "Fiber Repair - No Service",
                                                          appointmentId: "08pf00000008gvCAAQ",
                                                          latitude: 39.852448,
                                                          longitude: -104.97592,
                                                          appointmentNumber: "SA-11704",
                                                          serviceTerritory: nil,
                                                          serviceResources: nil)
        
    }
    
//    func dismissWelcomeCell() {
//        let viewModel = NewUserDashboardViewModel(with: AppointmentRepository.init(appointmentServiceManager:  MockAppointmentServiceManager()))
//        XCTAssertNotNil(viewModel.))
//    }
}
