//
//  NetworkAssiaServiceManager.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 6/17/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift

class NetworkAssiaServiceManager: NetworkServiceManager {
    
    private let disposeBag = DisposeBag()
    
    static let shared = NetworkAssiaServiceManager()
    
    func getNetworkStatus() -> Observable<Result<Data, Error>> {
        TokenManager.shared.refreshToken()
        let networkStatusResult = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.apigeeAssiaBase + EnvironmentPath.networkStatus.rawValue
        
        if let url = ServiceManager.buildQueryUrl(path: path,
                                                  parameters: [HTTPHeader.genericId.rawValue : ServiceManager.shared.lineID, HTTPHeader.forcePing.rawValue : ServiceManager.shared.forcePing]) {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders([HTTPHeader.authorization.rawValue: "Bearer "+ServiceManager.shared.accessToken, HTTPHeader.from.rawValue: Constants.Networking.mobile])
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                networkStatusResult.onNext(AssiaServiceManager.shared.handleResponse(with: data, response: response, error: error))
                networkStatusResult.onCompleted()
            }
            dataTask.resume()
        }
        return networkStatusResult.asObservable()
    }
    
    func restartModem() -> Observable<Result<Data, Error>> {
        let isModemRestartedStatus = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.apigeeAssiaBase + String(format: EnvironmentPath.restartModem.rawValue, ServiceManager.shared.assiaID)
        // TODO: Use accessToken from ServiceManager when usable with Assia
            if let url = URL(string: path) {
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.post.rawValue
                request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders([HTTPHeader.authorization.rawValue: "Bearer "+ServiceManager.shared.accessToken,
                                                                                    HTTPHeader.from.rawValue: Constants.Networking.mobile
                ])
                let parameters: [String: Any] = [
                    HTTPHeader.assiaIdSmall.rawValue: ServiceManager.shared.assiaID,
                ]
                let bodyData = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                request.httpBody = bodyData
                let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                    isModemRestartedStatus.onNext(AssiaServiceManager.shared.handleResponse(with: data, response: response, error: error))
                    isModemRestartedStatus.onCompleted()
                }
                dataTask.resume()
            }
        return isModemRestartedStatus.asObservable()
    }
    
    func runSpeedTest() -> Observable<Result<Data, Error>> {
        let speedTestResult = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.apigeeAssiaBase + EnvironmentPath.speedTestRequest.rawValue
        
            if let url = URL(string: path) {
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.post.rawValue
                request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders([HTTPHeader.authorization.rawValue: "Bearer "+ServiceManager.shared.accessToken,
                                                                                    HTTPHeader.from.rawValue: Constants.Networking.mobile
                ])
                let parameters: [String: Any] = [
                    HTTPHeader.assiaIdSmall.rawValue: ServiceManager.shared.assiaID,
                    HTTPHeader.callBackUrl.rawValue: EnvironmentPath.speedTestCallBackURL
                ]
                let bodyData = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                request.httpBody = bodyData
                let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                    speedTestResult.onNext(AssiaServiceManager.shared.handleResponse(with: data, response: response, error: error))
                    speedTestResult.onCompleted()
                }
                dataTask.resume()
            }
        return speedTestResult.asObservable()
    }
    
    func checkSpeedTestStatus(requestId: String) -> Observable<Result<Data, Error>> {
        let speedTestResult = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.apigeeAssiaBase + EnvironmentPath.speedTestStatus.rawValue
        
            if let url = URL(string: path) {
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.post.rawValue
                request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders([HTTPHeader.authorization.rawValue: "Bearer "+ServiceManager.shared.accessToken,
                                                                                    HTTPHeader.from.rawValue: Constants.Networking.mobile
                ])
                
                let parameters: [String: Any] = [
                    HTTPHeader.assiaIdSmall.rawValue: ServiceManager.shared.assiaID,
                    HTTPHeader.requestId.rawValue: requestId,
                    HTTPHeader.callBackUrl.rawValue: EnvironmentPath.speedTestCallBackURL
                ]
                let bodyData = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                request.httpBody = bodyData
                
                let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                    speedTestResult.onNext(AssiaServiceManager.shared.handleResponse(with: data, response: response, error: error))
                    speedTestResult.onCompleted()
                }
                dataTask.resume()
            }
        return speedTestResult.asObservable()
    }

    //Enable network
    func enableNetwork(forInterface interface: String) -> Observable<Result<Data, Error>> {
        let enableNetworkResult = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.apigeeAssiaBase + String(format: EnvironmentPath.enableRegularGuestWifi.rawValue,
                                                                  ServiceManager.shared.assiaID, interface)
            if let url = URL(string: path) {
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.post.rawValue
                request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders([HTTPHeader.authorization.rawValue: "Bearer "+ServiceManager.shared.accessToken,
                                                                                    HTTPHeader.from.rawValue:Constants.Networking.mobile])
                
                let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                    enableNetworkResult.onNext(AssiaServiceManager.shared.handleResponse(with: data,
                                                                                         response: response,
                                                                                         error: error))
                    enableNetworkResult.onCompleted()
                }
                dataTask.resume()
            }
        return enableNetworkResult.asObservable()
    }
    
    //Disable network
    func disableNetwork(forInterface interface: String) -> Observable<Result<Data, Error>> {
        let disableNetworkResult = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.apigeeAssiaBase + String(format: EnvironmentPath.disableRegularGuestWifi.rawValue,
                                                            ServiceManager.shared.assiaID, interface)
        
        if let url = URL(string: path) {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders([HTTPHeader.authorization.rawValue: "Bearer "+ServiceManager.shared.accessToken,
                                                                                HTTPHeader.from.rawValue:Constants.Networking.mobile])
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                disableNetworkResult.onNext(AssiaServiceManager.shared.handleResponse(with: data,
                                                                                      response: response,
                                                                                      error: error))
                disableNetworkResult.onCompleted()
            }
            dataTask.resume()
        }
        return disableNetworkResult.asObservable()
    }
    
    //Post/change network SSID
    func updateNetworkSSID(newSSID: String, forInterface interface: String) -> Observable<Result<Data, Error>> {
        let networkSSIDUpdateResult = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.apigeeAssiaBase + String(format: EnvironmentPath.changeSSID.rawValue)

            if let url = URL(string: path) {
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.post.rawValue
                request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders([HTTPHeader.authorization.rawValue: "Bearer "+ServiceManager.shared.accessToken,
                                                                                    HTTPHeader.from.rawValue: Constants.Networking.mobile
                ])
                
                let parameters: [String: Any] = [
                    HTTPHeader.newSsid.rawValue: newSSID,
                    HTTPHeader.wifiDeviceId.rawValue: ServiceManager.shared.assiaID,
                    HTTPHeader.interface.rawValue: interface
                ]
                let bodyData = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                request.httpBody = bodyData
                
                let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                    networkSSIDUpdateResult.onNext(AssiaServiceManager.shared.handleResponse(with: data,
                                                                                             response: response,
                                                                                             error: error))
                    networkSSIDUpdateResult.onCompleted()
                }
                dataTask.resume()
        }
        return networkSSIDUpdateResult.asObservable()
    }
    
    //Get network password
    func getNetworkPassword(forInterface interface: String) -> Observable<Result<Data, Error>> {
        let networkPasswordResult = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.apigeeAssiaBase + String(format: EnvironmentPath.getNetworkPassword.rawValue, ServiceManager.shared.assiaID, interface)
        
            if let url = URL(string: path) {
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.get.rawValue
                request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders([HTTPHeader.authorization.rawValue: "Bearer "+ServiceManager.shared.accessToken,
                                                                                    HTTPHeader.from.rawValue: Constants.Networking.mobile])
                
                let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                    networkPasswordResult.onNext(AssiaServiceManager.shared.handleResponse(with: data,
                                                                                           response: response,
                                                                                           error: error))
                    networkPasswordResult.onCompleted()
                }
                dataTask.resume()
            }
        return networkPasswordResult.asObservable()
    }
    
    //Post network password
    func updateNetworkPassword(newPassword: String, forInterface interface: String) -> Observable<Result<Data, Error>> {
        let updateNetworkPasswordResult = PublishSubject<Result<Data, Error>>()
        let path = EnvironmentPath.apigeeAssiaBase + String(format: EnvironmentPath.changeNetworkPassword.rawValue,
                                                                  ServiceManager.shared.assiaID,
                                                                  interface)
        
            if let url = URL(string: path) {
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.post.rawValue
                request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders([HTTPHeader.authorization.rawValue: "Bearer "+ServiceManager.shared.accessToken,
                                                                                    HTTPHeader.from.rawValue: Constants.Networking.mobile])
                
                let parameters: [String: Any] = [
                    HTTPHeader.newPassword.rawValue: newPassword
                ]
                let bodyData = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                request.httpBody = bodyData
                
                let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                    updateNetworkPasswordResult.onNext(AssiaServiceManager.shared.handleResponse(with: data,
                                                                                                 response: response,
                                                                                                 error: error))
                    updateNetworkPasswordResult.onCompleted()
                }
                dataTask.resume()
            }
        return updateNetworkPasswordResult.asObservable()
    }
}
