//
//  DeviceServiceManager.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 23/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
/**
implemetation of the DeviceServiceManager to calls API for devices
 */
protocol DeviceServiceManager {
    /// Get device list, mac device list and mac device list ID
    func getDeviceList() -> Observable<Result<Data, Error>>
    func getMacDeviceInfoList(_ serialNumber: String) -> Observable<Result<Data, Error>>
    func getMacDeviceIdList(_ serialNumber: String, _ macAddessList: [String]) -> Observable<Result<Data, Error>>
    /// Get usage details of device
    func getUsageDetails(for station:String, from startDate: String, to endDate: String) -> Observable<Result<Data, Error>>
    /// Block unblock device
    func blockDevice(_ stationMac: String) -> Observable<Result<Data, Error>>
    func unblockDevice(_ stationMac: String) -> Observable<Result<Data, Error>>
    /// Pause Resume device
    func pauseResumeDevice(_ serialNumber: String, _ deviceId: String, _ shouldPause: Bool) -> Observable<Result<Data, Error>>
    /// Network Info and Update device name API
    func getNetworkInfo(_ serialNumber: String, _ deviceId: String) -> Observable<Result<Data, Error>>
    func updateDeviceName(updatedName: String, deviceInfo: DeviceInfo) -> Observable<Result<Data, Error>>
    
}
