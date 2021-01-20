//
//  DeviceRepositoryTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 14/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class DeviceRepositoryTest: XCTestCase {
    
    var deviceRepository: DeviceRepository?
    
    func testInitialisationEvent() {
        deviceRepository = DeviceRepository.init(deviceServiceManager: NetworkDeviceServiceManager())
    }
    
    func testGetDeviceList() {
        deviceRepository = DeviceRepository.init(deviceServiceManager: NetworkDeviceServiceManager())
        XCTAssertNotNil(deviceRepository?.getDeviceList())
    }
    
    func testGetUsageDetails() {
        deviceRepository = DeviceRepository.init(deviceServiceManager: NetworkDeviceServiceManager())
        XCTAssertNotNil(deviceRepository?.getUsageDetails(for: "8C:85:90:AC:B7:15", from: "2020-06-17T15:07:33+0000", to: "2020-06-17T15:01:13+0000"))
    }
    
    func testBlockDevice() {
        deviceRepository = DeviceRepository.init(deviceServiceManager: NetworkDeviceServiceManager())
        XCTAssertNotNil(deviceRepository?.blockDevice("8C:85:90:AC:B7:15"))
    }
    
    func testUnBlockDevice() {
        deviceRepository = DeviceRepository.init(deviceServiceManager: NetworkDeviceServiceManager())
        XCTAssertNotNil(deviceRepository?.unblockDevice("8C:85:90:AC:B7:15"))
    }
    
    func testGetDeviceListWithMacDevicesId() {
        deviceRepository = DeviceRepository.init(deviceServiceManager: NetworkDeviceServiceManager())
        XCTAssertNotNil(deviceRepository?.getDeviceListWithMacDevicesId(DeviceList()))
    }
    
    func testGetMacDeviceInfoList() {
        deviceRepository = DeviceRepository.init(deviceServiceManager: NetworkDeviceServiceManager())
        XCTAssertNotNil(deviceRepository?.getMacDeviceInfoList(DeviceList()))
    }
    
    func testGetNetworkInfo() {
        deviceRepository = DeviceRepository.init(deviceServiceManager: NetworkDeviceServiceManager())
        XCTAssertNotNil(deviceRepository?.getNetworkInfo(mockDeviceObject()))
    }
    
    func testPauseResumeDevice() {
        deviceRepository = DeviceRepository.init(deviceServiceManager: NetworkDeviceServiceManager())
        XCTAssertNotNil(deviceRepository?.pauseResumeDevice("C4000XG1950000308", "C4000XG1950000308", true))
    }
    
    func testUpdateDeviceName() {
        deviceRepository = DeviceRepository.init(deviceServiceManager: NetworkDeviceServiceManager())
        XCTAssertNotNil(deviceRepository?.updateDeviceName("Centurylink123", mockDeviceObject()))
    }
    
    func mockDeviceObject() -> DeviceInfo {
        return DeviceInfo(stationMac: "EE:E9:95:EB:38:19",
                          hostname: "1594910886 EE:E9:95:EB:38:19 192.168.0.4 * 01:EE:E9:95:EB:38:19",
                          vendorName: "UNKNOWN",
                          type:  "UNKNOWN",
                          lastConnectionDate: "",
                          firstConnectionTime:  "2020-06-17T15:07:33+0000",
                          connectedInterface: "Band5G",
                          ipAddress: "192.168.0.4",
                          blocked: false,
                          rssi:  -56,
                          txRateKbps: 866600,
                          parent: "C4000XG1950000871",
                          rxRateKbps: 866700,
                          userDefinedProfile: "",
                          location: "",
                          deviceId: nil,
                          maxSpeed: MaxSpeed(Band2G: nil, Band5G: nil),
                          maxMode: MaxMode(Band2G: nil, Band5G: nil))
    }
}
