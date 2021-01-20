//
//  DashboardViewModelTest.swift
//  BiWFTests
//
//  Created by pooja.q.gupta on 15/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class DashboardViewModelTest: XCTestCase {
    
    
    let disposeBag = DisposeBag()
    let newWifinetwork = WiFiNetwork(name: "varun", password: "1234", isGuestNetwork: true)
    
    
    func testShowConnectedDevicesEvent() {
        let testExpectation = expectation(description: "Receive event to show connected devices")
        let viewModel = DashboardViewModel.init(commonDashboardViewModel: CommonDashboardViewModel(with: AppointmentRepository()), notificationRepository: NotificationRepository(), networkRepository: NetworkRepository(), deviceRepository: DeviceRepository())
        
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goToDevices = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.connectedDevicesSelectedObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testGotodevices() {
        let testExpectation = expectation(description: "Go to devices")
        let viewModel = DashboardViewModel(commonDashboardViewModel: CommonDashboardViewModel(with: AppointmentRepository()), notificationRepository: NotificationRepository(), networkRepository: NetworkRepository(), deviceRepository: DeviceRepository())
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goToDevices = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.connectedDevicesSelectedObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testGotoNetwork() {
        let testExpectation = expectation(description: "Go to ntwork")
        let viewModel = DashboardViewModel(commonDashboardViewModel: CommonDashboardViewModel(with: AppointmentRepository()), notificationRepository: NotificationRepository(), networkRepository: NetworkRepository(), deviceRepository: DeviceRepository())
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goToNetwork = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.networkSelectedObserver.onNext((newWifinetwork,newWifinetwork,["":""]))
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testGetNetworkDetails() {
        let viewModel = DashboardViewModel(commonDashboardViewModel: CommonDashboardViewModel(with: AppointmentRepository()), notificationRepository: NotificationRepository(), networkRepository: NetworkRepository(), deviceRepository: DeviceRepository())
        XCTAssertNotNil(viewModel.getNetworkDetails())
        XCTAssertNotNil(viewModel.getServiceAppoinment())
        XCTAssertNotNil(viewModel.addCheckForArrivalTimeAndAddTime())
        viewModel.deviceRepository.deviceListCountSubject.onNext(7)
        viewModel.commonDashboardViewModel.serviceAppointmentCompleted.onNext(true)
    }
    
    func testGetPassword() {
        let networRepository = NetworkRepository()
        let viewModel = DashboardViewModel(commonDashboardViewModel: CommonDashboardViewModel(with: AppointmentRepository()), notificationRepository: NotificationRepository(), networkRepository: NetworkRepository(), deviceRepository: DeviceRepository())
        XCTAssertNotNil(viewModel.getPassword(forInterface: "Network", networkRepository: NetworkRepository()))
        networRepository.ssidInfoSubject.onNext(("Band 5G", "Calvin"))
        networRepository.bssidMapSubject.onNext(["Band 5G" : "Calvin"])
    }
}
