//
//  NetworkSupportServiceManager.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 05/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import LocalAuthentication
import RxSwift

class NetworkSupportServiceManager: SupportServiceManager {
    
    private let disposeBag = DisposeBag()
    var serviceManager = ServiceManager.shared
    
    static let shared: NetworkSupportServiceManager = {
        let instance = NetworkSupportServiceManager()
        return instance
    }()
    
    func getFaqList(for recordTypeID: String) -> Observable<Result<Data, Error>> {
        let serviceFaqListResult = PublishSubject<Result<Data, Error>>()
        
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.faqSectionList,
                                                endPoint: recordTypeID,
                                                sobjects: false)
        let path = EnvironmentPath.salesforceServiceBase + endpoint
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                serviceFaqListResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                serviceFaqListResult.onCompleted()
            }
            dataTask.resume()
        }
        return serviceFaqListResult.asObservable()
    }

    func getRecordTypeID() -> Observable<Result<Data, Error>> {
        let recordTypeIDResult = PublishSubject<Result<Data, Error>>()
        
        let accessToken = ServiceManager.shared.accessToken
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.faqRecordTypeID,
                                                endPoint: "",
                                                sobjects: false)
        let path = EnvironmentPath.salesforceServiceBase + endpoint
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders([HTTPHeader.authorization.rawValue: "Bearer "+accessToken])
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                recordTypeIDResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                recordTypeIDResult.onCompleted()
            }
            dataTask.resume()
        }
        return recordTypeIDResult.asObservable()
    }
    
    func scheduleSupportGuestCallback(scheduleCallbackInfo: ScheduleCallback) -> Observable<Result<Data, Error>> {
        
        let scheduleGuestCallbackResult = PublishSubject<Result<Data, Error>>()
        let url = EnvironmentPath.salesforceApexRest + EnvironmentPath.scheduleCallback.rawValue
        if let requestUrl = URL(string: url) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.post.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            
            let params: [String: Any]  = [
                Constants.Networking.userid: ServiceManager.shared.userID ?? "",
                Constants.Networking.phone: scheduleCallbackInfo.phone ,
                Constants.Networking.asap: "\(scheduleCallbackInfo.asap )",
                Constants.Networking.customerCareOption: scheduleCallbackInfo.customerCareOption,
                Constants.Networking.handleOption: "\(scheduleCallbackInfo.handleOption )",
                Constants.Networking.callbackTime: scheduleCallbackInfo.callbackTime ,
                Constants.Networking.callbackReason: scheduleCallbackInfo.callbackReason
            ]
            request.httpBody = serviceManager.generateHTTPBody(from: params)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                scheduleGuestCallbackResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                scheduleGuestCallbackResult.onCompleted()
            }
            dataTask.resume()
        }
        return scheduleGuestCallbackResult.asObservable()
    }
    
    func getCustomerCareRecordTypeID() -> Observable<Result<Data, Error>> {
        let recordTypeIDResult = PublishSubject<Result<Data, Error>>()
        
        let accessToken = ServiceManager.shared.accessToken
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.customerCareOptionRecordTypeID,
                                                endPoint: "",
                                                sobjects: false)
        let path = EnvironmentPath.salesforceServiceBase + endpoint
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders([HTTPHeader.authorization.rawValue: "Bearer "+accessToken])
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                recordTypeIDResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                recordTypeIDResult.onCompleted()
            }
            dataTask.resume()
        }
        return recordTypeIDResult.asObservable()
    }

    func getCustomerCareOptionList(for recordTypeID: String) -> Observable<Result<Data, Error>> {

        let customerCareOptionListResult = PublishSubject<Result<Data, Error>>()
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.customerCareOptionList,
                                                endPoint: recordTypeID,
                                                sobjects: false)
        let path = EnvironmentPath.salesforceServiceBase + endpoint
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                customerCareOptionListResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                customerCareOptionListResult.onCompleted()
            }
            dataTask.resume()
        }
        return customerCareOptionListResult.asObservable()
    }
}
