//
//  NetworkDeviceServiceManager.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 23/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
/**
implemetation of the NetworkDeviceServiceManager to calls API for devices
 */
class NetworkDeviceServiceManager: DeviceServiceManager {
    /// Contained disposables disposal
    private let disposeBag = DisposeBag()
    /// Shared object of NetworkDeviceServiceManager
    static let shared = NetworkDeviceServiceManager()
    
    /// Call get device list apigee API
    /// - returns: <Result<Data, Error>>
    ///   - Data: API response data
    ///   - Error: if any error come in API response
    func getDeviceList() -> Observable<Result<Data, Error>> {
        let deviceListResult = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.apigeeAssiaBase + EnvironmentPath.deviceList.rawValue
        
        if let url = ServiceManager.buildQueryUrl(path: path,
                                                  parameters: [HTTPHeader.lineId.rawValue:ServiceManager.shared.lineID]) {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.get.rawValue
            /// Adding headers auth token and from mobile to differentiate the request is from mobile devices
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders([HTTPHeader.authorization.rawValue: "Bearer "+ServiceManager.shared.accessToken, HTTPHeader.from.rawValue: Constants.Networking.mobile])
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                deviceListResult.onNext(AssiaServiceManager.shared.handleResponse(with: data, response: response, error: error))
                deviceListResult.onCompleted()
            }
            dataTask.resume()
        }
        return deviceListResult.asObservable()
    }
 
    /// Call get usage details apigee API
    /// - Parameters:
    ///   - station: station ID for selected device
    ///   - startDate: started data usage date
    ///   - endDate: end data usage date
    /// - returns: <Result<Data, Error>>
    ///   - Data: API response data
    ///   - Error: if any error come in API response
    func getUsageDetails(for station: String, from startDate: String, to endDate: String) -> Observable<Result<Data, Error>> {
        
        let usageDetailsResult = PublishSubject<Result<Data, Error>>()
        let path = String(format: EnvironmentPath.apigeeAssiaBase + EnvironmentPath.usageInfo.rawValue,
                          ServiceManager.shared.assiaID,
                          startDate,
                          station)
        if let url = URL(string: path) {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.get.rawValue
            /// Adding headers auth token and from mobile to differentiate the request is from mobile devices
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders([HTTPHeader.authorization.rawValue: "Bearer "+ServiceManager.shared.accessToken,
                                                                                HTTPHeader.from.rawValue:Constants.Networking.mobile
            ])

            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                usageDetailsResult.onNext(AssiaServiceManager.shared.handleResponse(with: data,
                                                                                    response: response,
                                                                                    error: error))
                usageDetailsResult.onCompleted()
            }
            dataTask.resume()
        }
        return usageDetailsResult.asObservable()
    }
  
    /// Call blockDevice apigee API
    /// - Parameters:
    ///   - stationMac: station mac ID of the device to be blocked
    /// - returns: <Result<Data, Error>>
    ///   - Data: API response data
    ///   - Error: if any error come in API response
    func blockDevice(_ stationMac: String) -> Observable<Result<Data, Error>> {

        let blockDeviceStatus = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.apigeeAssiaBase + EnvironmentPath.blockDevice.rawValue

            if let url = URL(string: path) {

                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.post.rawValue
                request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders([HTTPHeader.authorization.rawValue: "Bearer "+ServiceManager.shared.accessToken,
                                                                                    HTTPHeader.from.rawValue:Constants.Networking.mobile])

                let parameters: [String: Any] = [
                    HTTPHeader.assiaIdSmall.rawValue: ServiceManager.shared.assiaID,
                    HTTPHeader.stationMac.rawValue: stationMac
                ]
                let bodyData = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                request.httpBody = bodyData

                let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                    blockDeviceStatus.onNext(AssiaServiceManager.shared.handleResponse(with: data, response: response, error: error))
                    blockDeviceStatus.onCompleted()
                }
                dataTask.resume()
            }
        return blockDeviceStatus.asObservable()
    }

    /// Call unblockDevice apigee API
    /// - Parameters:
    ///   - stationMac: station mac ID of the device to be blocked
    /// - returns: <Result<Data, Error>>
    ///   - Data: API response data
    ///   - Error: if any error come in API response
    func unblockDevice(_ stationMac: String) -> Observable<Result<Data, Error>> {

        let unblockDeviceStatus = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.apigeeAssiaBase + EnvironmentPath.unblockDevice.rawValue

            if let url = URL(string: path) {

                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.delete.rawValue
                request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders([HTTPHeader.authorization.rawValue: "Bearer "+ServiceManager.shared.accessToken,
                                                                                    HTTPHeader.from.rawValue:Constants.Networking.mobile])

                let parameters: [String: Any] = [
                    HTTPHeader.assiaIdSmall.rawValue: ServiceManager.shared.assiaID,
                    HTTPHeader.stationMac.rawValue: stationMac
                ]

                let bodyData = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                request.httpBody = bodyData
                let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                    unblockDeviceStatus.onNext(AssiaServiceManager.shared.handleResponse(with: data, response: response, error: error))
                    unblockDeviceStatus.onCompleted()
                }
                dataTask.resume()
            }
        return unblockDeviceStatus.asObservable()
    }

    /// Call MacDeviceIdList apigee API
    /// - Parameters:
    ///   - serialNumber: station mac ID of the device to be blocked
    ///   - macAddessList:
    /// - returns: <Result<Data, Error>>
    ///   - Data: API response data
    ///   - Error: if any error come in API response
    func getMacDeviceIdList(_ serialNumber: String, _ macAddessList: [String]) -> Observable<Result<Data, Error>> {
        let macAddressMappingResult = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.apigeeMcAfeeBase + EnvironmentPath.macAddressMapping.rawValue
        
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.post.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            request.httpBody = ServiceManager.shared.generateHTTPBody(from: [Constants.Networking.serialNumber: serialNumber,                                                                                                     Constants.Networking.macAddress: macAddessList])
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                macAddressMappingResult.onNext(AssiaServiceManager.shared.handleResponse(with: data, response: response, error: error))
                macAddressMappingResult.onCompleted()
            }
            dataTask.resume()
        }
        return macAddressMappingResult.asObservable()
    }
    
    func pauseResumeDevice(_ serialNumber: String, _ deviceId: String, _ shouldPause: Bool) -> Observable<Result<Data, Error>> {
        let macAddressMappingResult = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.apigeeMcAfeeBase + EnvironmentPath.pauseResumeNetworkAccess.rawValue
        
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.put.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            request.httpBody = ServiceManager.shared.generateHTTPBody(from: [Constants.Networking.serialNumber: serialNumber,                                                                                                     Constants.Networking.deviceId: deviceId,
                                                                             Constants.Networking.blocked: shouldPause])
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                macAddressMappingResult.onNext(AssiaServiceManager.shared.handleResponse(with: data, response: response, error: error))
                macAddressMappingResult.onCompleted()
            }
            dataTask.resume()
        }
        return macAddressMappingResult.asObservable()
    }
    
    func getNetworkInfo(_ serialNumber: String, _ deviceId: String) -> Observable<Result<Data, Error>> {
        let getNetworkInfoResult = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.apigeeMcAfeeBase + EnvironmentPath.networkInfo.rawValue
        
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.post.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            request.httpBody = ServiceManager.shared.generateHTTPBody(from: [Constants.Networking.serialNumber: serialNumber,
                                                                             Constants.Networking.deviceId: deviceId])
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                getNetworkInfoResult.onNext(AssiaServiceManager.shared.handleResponse(with: data, response: response, error: error))
                getNetworkInfoResult.onCompleted()
            }
            dataTask.resume()
        }
        return getNetworkInfoResult.asObservable()
    }
    
    func updateDeviceName(updatedName: String, deviceInfo: DeviceInfo) -> Observable<Result<Data, Error>> {
        
        let macAddressMappingResult = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.apigeeMcAfeeBase + EnvironmentPath.updateDeviceName.rawValue
        
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.put.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            request.httpBody = ServiceManager.shared.generateHTTPBody(from: [Constants.Networking.deviceId: deviceInfo.macDeviceId ?? "",
                                                                             Constants.Networking.serialNumber: ServiceManager.shared.assiaID,
                                                                             Constants.Networking.deviceType: deviceInfo.type ?? "",
                                                                             Constants.Networking.deviceNickName: updatedName
            ])
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                macAddressMappingResult.onNext(AssiaServiceManager.shared.handleResponse(with: data, response: response, error: error))
                macAddressMappingResult.onCompleted()
            }
            dataTask.resume()
        }
        return macAddressMappingResult.asObservable()
    }
    
    func getMacDeviceInfoList(_ serialNumber: String) -> Observable<Result<Data, Error>> {
        let deviceInfoResult = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.apigeeMcAfeeBase + EnvironmentPath.devcieInfo.rawValue//String(format: , serialNumber)
        
        if let url = ServiceManager.buildQueryUrl(path: path,
                                                  parameters: [Constants.Networking.serialNumber:serialNumber]) {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                deviceInfoResult.onNext(AssiaServiceManager.shared.handleResponse(with: data, response: response, error: error))
                deviceInfoResult.onCompleted()
            }
            dataTask.resume()
        }
        return deviceInfoResult.asObservable()
    }
}
