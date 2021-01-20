//
//  DashboardContainerViewModelTest.swift
//  BiWFTests
//
//  Created by pooja.q.gupta on 15/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class DashboardContainerViewModelTest: XCTestCase {
    
    let disposeBag = DisposeBag()
    let viewModel = DashboardContainerViewModel(accountRepository:
        AccountRepository(accountServiceManager: MockAccountServiceManager()),
                                                appointmentRepository: AppointmentRepository(appointmentServiceManager: MockAppointmentServiceManager()),
                                                notificationRepository: NotificationRepository(),
                                                networkRepository: NetworkRepository(),
                                                deviceRepository: DeviceRepository())
    
    func testShowNewUserDahboardEvent() {
        let testExpectation = expectation(description: "Receive event to show new user dashboard")

        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goToNewUserDashboard = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)

        viewModel.input.showNewUserDashboardWithDevicesTabObserver.onNext((true))
        wait(for: [testExpectation], timeout: 5)
    }
        
    func testGetAccountInformation() {
        XCTAssertNotNil(viewModel.getAccountInformation(forAccountId:"12345") )
    }
    
    func testGetServiceAppointment() {
         let account = Account(accountId: "12335", name: "Scott", firstName: "Hayden", billingAddress: BillingAddress(street: "Lakers", city: "USA", state: "Washington", postalCode: "5674-746"), marketingEmailOptIn: true, marketingCallOptIn: true, cellPhoneOptIn: false, productName: "Mynk", productPlanName: "Asar", email: "asar@centurylink.com", accountStatus: "passed", contactId: "0958", subscriptionEndDate: "12/10/2020", phone: "7758637292", serviceAddress: "Home", lineId: "86683-5873-876", serviceCity: "Washington", servicrCountry: "USA", serviceState: "30/12/2020", serviceStreet: "houston", serviceZipCode: "5772-928", serviceUnit: "450", nextPaymentDate: "12/01/2021")
        XCTAssertNotNil(viewModel.getServiceAppointment(with: account) )
        
        let serviceAppoinntment = ServiceAppointmentList(records: [ServiceAppointment(arrivalStartTime: "2020-07-14T22:00:00.000+0000", arrivalEndTime: "2020-07-14T20:00:00.000+0000", status: "Dispatched", workTypeId: "08qf00000008QgpAAE", jobType: "Fiber Repair - No Service", appointmentId: "08pf00000008dTjAAI", latitude: 39.852448, longitude: -104.97592, appointmentNumber: "SA-1234", serviceTerritory: nil, serviceResources: ServiceResourceList(records: [ServiceResource(serviceResource: ResourceDetail(name: "Technician 2"))]))])
        viewModel.appointmentRepository.serviceAppointment.onNext(serviceAppoinntment)
        
         let insatllationAppoinntment = ServiceAppointmentList(records: [ServiceAppointment(arrivalStartTime: "2020-07-14T22:00:00.000+0000", arrivalEndTime: "2020-07-14T20:00:00.000+0000", status: "Dispatched", workTypeId: "08qf00000008QgpAAE", jobType: "Fiber Install - For Installations", appointmentId: "08pf00000008dTjAAI", latitude: 39.852448, longitude: -104.97592, appointmentNumber: "SA-1234", serviceTerritory: nil, serviceResources: ServiceResourceList(records: [ServiceResource(serviceResource: ResourceDetail(name: "Technician 2"))]))])
        viewModel.appointmentRepository.serviceAppointment.onNext(insatllationAppoinntment)

        let serviceAppoinntmentWithCompleteState = ServiceAppointmentList(records: [ServiceAppointment(arrivalStartTime: "2020-07-14T22:00:00.000+0000", arrivalEndTime: "2020-07-14T20:00:00.000+0000", status: "Completed", workTypeId: "08qf00000008QgpAAE", jobType: "Fiber Repair - No Service", appointmentId: "08pf00000008dTjAAI", latitude: 39.852448, longitude: -104.97592, appointmentNumber: "SA-1234", serviceTerritory: nil, serviceResources: ServiceResourceList(records: [ServiceResource(serviceResource: ResourceDetail(name: "Technician 2"))]))])
        viewModel.appointmentRepository.serviceAppointment.onNext(serviceAppoinntmentWithCompleteState)
        
        let insatllationAppoinntmentWithCompleteState = ServiceAppointmentList(records: [ServiceAppointment(arrivalStartTime: "2020-07-14T22:00:00.000+0000", arrivalEndTime: "2020-07-14T20:00:00.000+0000", status: "Completed", workTypeId: "08qf00000008QgpAAE", jobType: "Fiber Install - For Installations", appointmentId: "08pf00000008dTjAAI", latitude: 39.852448, longitude: -104.97592, appointmentNumber: "SA-1234", serviceTerritory: nil, serviceResources: ServiceResourceList(records: [ServiceResource(serviceResource: ResourceDetail(name: "Technician 2"))]))])
        viewModel.appointmentRepository.serviceAppointment.onNext(insatllationAppoinntmentWithCompleteState)
        
        let noAppoinntment = ServiceAppointmentList(records: [])
        viewModel.appointmentRepository.serviceAppointment.onNext(noAppoinntment)
                
       }
    
    func testMoveToNewUserDashboard() {
        let account = Account(accountId: "12335", name: "Scott", firstName: "Hayden", billingAddress: BillingAddress(street: "Lakers", city: "USA", state: "Washington", postalCode: "5674-746"), marketingEmailOptIn: true, marketingCallOptIn: true, cellPhoneOptIn: false, productName: "Mynk", productPlanName: "Asar", email: "asar@centurylink.com", accountStatus: "passed", contactId: "0958", subscriptionEndDate: "12/10/2020", phone: "7758637292", serviceAddress: "Home", lineId: "86683-5873-876", serviceCity: "Washington", servicrCountry: "USA", serviceState: "30/12/2020", serviceStreet: "houston", serviceZipCode: "5772-928", serviceUnit: "450", nextPaymentDate: "12/01/2021")
        
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
        
        XCTAssertNotNil(viewModel.moveToNewUserDashboard(with: account, appointment: serviceAppointment) )
    }
    
    func testGetError() {
        XCTAssertNotNil(viewModel.getError())
    }
}
