//
//  SubscriptionServiceManager.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 12/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import LocalAuthentication
import RxSwift

class NetworkSubscriptionServiceManager: SubscriptionServiceManager {
    
    private let disposeBag = DisposeBag()
    var serviceManager = ServiceManager.shared
    
    static let shared: NetworkSubscriptionServiceManager = {
        let instance = NetworkSubscriptionServiceManager()
        return instance
    }()

    func getStatementsList(forAccountID accountID: String) -> Observable<Result<Data, Error>> {
        let statementsListResult = PublishSubject<Result<Data, Error>>()
        
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.statementsList,
                                                endPoint: accountID,
                                                sobjects: false)
        let path = EnvironmentPath.salesforceServiceBase + endpoint
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                statementsListResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                statementsListResult.onCompleted()
            }
            dataTask.resume()
        }
        return statementsListResult.asObservable()
    }

    func getInvoice(forPaymentID paymentID: String) -> Observable<Result<Data, Error>> {
        let invoiceResult = PublishSubject<Result<Data, Error>>()
        
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.zuoraPayment,
                                                endPoint: paymentID,
                                                sobjects: true)
        let path = EnvironmentPath.salesforceServiceBase + endpoint
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                invoiceResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                invoiceResult.onCompleted()
            }
            dataTask.resume()
        }
        return invoiceResult.asObservable()
    }

    func getRecordTypeID() -> Observable<Result<Data, Error>> {
        let recordTypeIDResult = PublishSubject<Result<Data, Error>>()
        
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.recordTypeID,
                                                endPoint: "",
                                                sobjects: false)
        let path = EnvironmentPath.salesforceServiceBase + endpoint
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                recordTypeIDResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                recordTypeIDResult.onCompleted()
            }
            dataTask.resume()
        }
        return recordTypeIDResult.asObservable()
    }
    
    func cancelMySubscription(forSubscriptionDetails details: CancelSubscription) -> Observable<Result<Data, Error>> {
        let cancelSubscriptionResult = PublishSubject<Result<Data, Error>>()
        
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.cancelSubscription,
                                                endPoint: "",
                                                sobjects: true)
        let path = EnvironmentPath.salesforceServiceBase + endpoint
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.post.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            let params: [String: Any]  = [
                Constants.Networking.contactID: details.contactID ?? "",
                Constants.Networking.caseKey: Constants.Networking.caseType,
                Constants.Networking.origin: Constants.Networking.originType,
                Constants.Networking.cancelReason: details.cancellationReason ?? "",
                Constants.Networking.cancelComment: details.cancellationComment ?? "",
                Constants.Networking.notes: details.cancellationReason ?? "",
                Constants.Networking.experience: details.rating ?? "",
                Constants.Networking.cancellationDate: details.cancellationDate ?? "",
                Constants.Networking.recordTypeID: details.recordTypeID ?? ""
            ]
            request.httpBody = serviceManager.generateHTTPBody(from: params)
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                cancelSubscriptionResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                cancelSubscriptionResult.onCompleted()
            }
            dataTask.resume()
        }
        return cancelSubscriptionResult.asObservable()
    }

    func getPaymentInfo(forAccountId accountID: String) -> Observable<Result<Data, Error>> {
        let paymentInfoResult = PublishSubject<Result<Data, Error>>()
        
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.paymentInfo,
                                                endPoint: accountID,
                                                sobjects: false)
        let path = EnvironmentPath.salesforceServiceBase + endpoint
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                paymentInfoResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                paymentInfoResult.onCompleted()
            }
            dataTask.resume()
        }
        return paymentInfoResult.asObservable()
    }
    
    func getFiberInternetInfo(forAccountId accountID: String) -> Observable<Result<Data, Error>>{
        let fiberPlanResult = PublishSubject<Result<Data, Error>>()
        
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.fiberInfoPlan,
                                                endPoint: accountID,
                                                sobjects: false)
        var path = EnvironmentPath.salesforceServiceBase + endpoint
        path = (path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                fiberPlanResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                fiberPlanResult.onCompleted()
            }
            dataTask.resume()
        }
        return fiberPlanResult.asObservable()
    }
}
