//
//  UsageViewModelTest.swift
//  BiWFTests
//
//  Created by pooja.q.gupta on 25/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class UsageViewModelTest: XCTestCase {
    let disposeBag = DisposeBag()
    
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
    var viewModel: UsageDetailsViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = UsageDetailsViewModel.init(with: deviceInfo, deviceRepository: DeviceRepository(), networkRepository: NetworkRepository(), isModemOnline: true)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBackEvent() {
        
        let testExpectation = expectation(description: "Recieve event to back to Tab view")
        let viewModel = UsageDetailsViewModel.init(with: deviceInfo, deviceRepository: DeviceRepository(), networkRepository: NetworkRepository(), isModemOnline: true)
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .dismiss = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.doneSuccessTapSubject.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testUpdateUsageDetails() {
        XCTAssertNotNil(viewModel.updateUsageDetails())
    }

    func testGetUsageDetails() {
        XCTAssertNotNil(viewModel.getUsageDetails())
    }
    
    func testGetUsageDetailsFromStartEndDate() {
        let startDate = "\((Date().dateBeforeDays(Constants.UsageDetails.lastTwoWeeks) ?? Date()).toString(withFormat: Constants.DateFormat.YYYY_MM_dd))T00:00:00-0000"
        let endDate = "\((Date().dateBeforeDays(1) ?? Date()).toString(withFormat: Constants.DateFormat.YYYY_MM_dd))T24:00:00-0000"
        XCTAssertNotNil(viewModel.getUsageDetails(from: startDate, to: endDate, isTodayUsage: false))
    }
    
    func testGetblockDevice() {
        XCTAssertNotNil(viewModel.blockDevice(deviceInfo))
    }
    
    func testGetNetworkInfo() {
        XCTAssertNotNil(viewModel.getNetworkInfo())
    }
    
    func testPauseResumeDevice() {
        XCTAssertNotNil(viewModel.pauseResumeDevice(deviceInfo, true))
        XCTAssertNotNil(viewModel.pauseResumeDevice(deviceInfo, false))
    }
    
    func testShowAlert() {
        XCTAssertNotNil(viewModel.showAlert(withMessage: Constants.Common.anErrorOccurred, deviceInfo: deviceInfo))
    }
}
