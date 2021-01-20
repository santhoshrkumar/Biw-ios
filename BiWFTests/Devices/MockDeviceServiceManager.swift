//
//  MockDeviceServiceManager.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 16/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
@testable import BiWF

class MockDeviceServiceManager: DeviceServiceManager {
    
    func getDeviceList() -> Observable<Result<Data, Error>> {
        let getDeviceListResult = PublishSubject<Result<Data, Error>>()
        getDeviceListResult.onNext(getDataFromJSON(resource: "Device"))
        return getDeviceListResult
    }
    
    func getDeviceList() -> DeviceList {
        guard let path = Bundle.main.path(forResource: "deviceResponse",
                                          ofType: "json") else {
                                            return DeviceList()
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path),
                                options: .mappedIfSafe)
            let deviceList = try JSONDecoder().decode(DeviceList.self, from: data)
            return deviceList
        } catch {
            print(error)
            return DeviceList()
        }
    }
    
    func getUsageDetails(for station: String, from startDate: String, to endDate: String) -> Observable<Result<Data, Error>> {
        let getUsageDetailstResult = PublishSubject<Result<Data, Error>>()
        getUsageDetailstResult.onNext(getDataFromJSON(resource: "Device"))
        return getUsageDetailstResult
    }
    
    func blockDevice(_ stationMac: String) -> Observable<Result<Data, Error>> {
        let blockDeviceResult = PublishSubject<Result<Data, Error>>()
        blockDeviceResult.onNext(getDataFromJSON(resource: "Device"))
        return blockDeviceResult
    }
    
    func unblockDevice(_ stationMac: String) -> Observable<Result<Data, Error>> {
        let unblockDeviceResult = PublishSubject<Result<Data, Error>>()
        unblockDeviceResult.onNext(getDataFromJSON(resource: "Device"))
        return unblockDeviceResult
    }
    
    func getMacDeviceIdList(_ serialNumber: String, _ macAddessList: [String]) -> Observable<Result<Data, Error>> {
        let getMacDeviceIdListResult = PublishSubject<Result<Data, Error>>()
        getMacDeviceIdListResult.onNext(getDataFromJSON(resource: "Device"))
        return getMacDeviceIdListResult
    }
    
    func pauseResumeDevice(_ serialNumber: String, _ deviceId: String, _ shouldPause: Bool) -> Observable<Result<Data, Error>> {
        let pauseResumeDeviceResult = PublishSubject<Result<Data, Error>>()
        pauseResumeDeviceResult.onNext(getDataFromJSON(resource: "Device"))
        return pauseResumeDeviceResult
    }
    
    func getNetworkInfo(_ serialNumber: String, _ deviceId: String) -> Observable<Result<Data, Error>> {
        let getNetworkInfoResult = PublishSubject<Result<Data, Error>>()
        getNetworkInfoResult.onNext(getDataFromJSON(resource: "Device"))
        return getNetworkInfoResult
    }
    
    func updateDeviceName(updatedName: String, deviceInfo: DeviceInfo) -> Observable<Result<Data, Error>> {
        let updateDeviceNameResult = PublishSubject<Result<Data, Error>>()
        updateDeviceNameResult.onNext(getDataFromJSON(resource: "Device"))
        return updateDeviceNameResult
    }
    
    func getMacDeviceInfoList(_ serialNumber: String) -> Observable<Result<Data, Error>> {
        let getMacDeviceInfoListResult = PublishSubject<Result<Data, Error>>()
        getMacDeviceInfoListResult.onNext(getDataFromJSON(resource: "Device"))
        return getMacDeviceInfoListResult
    }

    private func getDataFromJSON(resource: String) -> Result<Data, Error> {
        guard let path = Bundle.main.path(forResource: resource, ofType: "json") else {
            return .failure(HTTPError.noResponse)
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}
