//
//  DeviceDetailTableCellViewModelTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 12/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class DeviceDetailTableCellViewModelTest: XCTestCase {
    var deviceInfo = DeviceInfo(stationMac: "8C:85:90:AC:B7:15",
                                hostname: "AMAC02W31TBHTD8",
                                vendorName: "APPLE",
                                type: "Apple",
                                lastConnectionDate: "2020-06-24T11:30:34+0000",
                                firstConnectionTime: "2020-05-29T23:27:31+0000",
                                connectedInterface: "Band5G",
                                ipAddress: "192.168.0.2",
                                blocked: false,
                                rssi: -1,
                                txRateKbps: 6000,
                                parent: "C4000XG1950000871",
                                rxRateKbps: 1053000,
                                userDefinedProfile: nil,
                                location: "",
                                deviceId: nil,
                                maxSpeed: nil,
                                maxMode: nil)
    func testInit() {
        deviceInfo.networStatus = .error
        let viewModel = DeviceDetailTableCellViewModel(withDevice: deviceInfo, isOnline: true, repository: DeviceRepository())
        XCTAssertNotNil(viewModel)
    }
}
