//
//  DeviceViewModelTest.swift
//  BiWFTests
//
//  Created by Varun.b.r on 16/09/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class DeviceViewModelTest: XCTestCase {
    
    let disposeBag = DisposeBag()
    let deviceManager = MockDeviceServiceManager()

    let deviceInfo = DeviceInfo(stationMac: "8C:85:90:AC:B7:15",
                                hostname: "AMAC02W31TBHTD8",
                                vendorName: "APPLE",
                                type: "Apple",
                                lastConnectionDate: "2020-06-24T11:30:34+0000",
                                firstConnectionTime: "2020-05-29T23:27:31+0000",
                                connectedInterface: "Band5G",
                                ipAddress: "192.168.0.2",
                                blocked: false,
                                rssi: 0,
                                txRateKbps: 6000,
                                parent: "C4000XG1950000871",
                                rxRateKbps: 1053000,
                                userDefinedProfile: nil,
                                location: "",
                                deviceId: nil,
                                maxSpeed: nil,
                                maxMode: nil)
    
    let viewModel = DevicesViewModel(withRepository: DeviceRepository(), networkRepository: NetworkRepository())

    
    func testGotoDeviceManagement() {

        let testExpectation = expectation(description: "Open the device management screen")
        viewModel.connectedDevices = [deviceInfo]
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .openDeviceManagement = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)

        viewModel.input.cellSelectionObserver.onNext(IndexPath(row: DevicesViewModel.SectionType.connectedDevices.rawValue, section: 0))
        wait(for: [testExpectation], timeout: 5)
    }
    
    
    func testSetSections() {
        viewModel.deviceList =  deviceManager.getDeviceList()
        XCTAssertNotNil(viewModel.setSections())
    }
    
    func testGetSections() {
        viewModel.deviceList =  deviceManager.getDeviceList()
        XCTAssertNotNil(viewModel.getSections())
    }
    
    func testHandleCellSelection() {
        XCTAssertNotNil(viewModel.handleCellSelection(for: IndexPath(row: 0, section: 0)))
        
        XCTAssertNotNil(viewModel.handleCellSelection(for: IndexPath(row: 1, section: 0)))
    }
    
    func testGetMacDeviceList() {
        XCTAssertNotNil(viewModel.getMacDeviceList(deviceManager.getDeviceList()))
    }
    
    func testGetMacDeviceInfoList() {
        XCTAssertNotNil(viewModel.getMacDeviceInfoList(deviceManager.getDeviceList()))
    }
    
    func testGetNetworkInfo() {
        XCTAssertNotNil(viewModel.getNetworkInfo())
    }
    
    
    func testRestoreDevice() {
        XCTAssertNotNil(viewModel.restoreDevice(deviceInfo))
    }

    func testSubscribeObservers() {
        viewModel.repository.deviceListSubject.onNext(DeviceList(deviceList: [deviceInfo]))
        viewModel.repository.errorMessageSubject.onNext("No Error")
        viewModel.repository.deviceListWithMacDeviceIdSubject.onNext(DeviceList(deviceList: [deviceInfo]))
        viewModel.repository.errorDeviceListWithMacDeviceIdSubject.onNext("No Error")
        viewModel.repository.macDeviceInfoListSubject.onNext(DeviceList(deviceList: [deviceInfo]))
        viewModel.repository.errorMacDeviceInfoListSubject.onNext("No Error")
        viewModel.networkRepository.isModemOnlineSubject.onNext(true)
        viewModel.repository.errorNetworkInfoSubject.onNext((deviceInfo,"No Error"))
        viewModel.networkInfoSubject.onNext(deviceInfo)
    }
    
    func testPauseResumeDevice() {
        XCTAssertNotNil(viewModel.pauseResumeDevice(deviceInfo, true))
    }
    
    func testShowAlert() {
        XCTAssertNotNil(viewModel.showAlert(withMessage: "Alert", deviceInfo: deviceInfo))
        XCTAssertNotNil(viewModel.showPauseResumeFailureAlert(withMessage: "Alert", deviceInfo: deviceInfo))
    }
}
