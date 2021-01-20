//
//  NetworkAccountServiceManager.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 5/13/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import LocalAuthentication
import RxSwift

class NetworkAccountServiceManager: AccountServiceManager {
    
    private let disposeBag = DisposeBag()
    private let serviceManager = ServiceManager.shared
    
    static let shared: NetworkAccountServiceManager = {
        let instance = NetworkAccountServiceManager()
        return instance
    }()
    
    func updateUserPassword(newPassword: String) -> Observable<Result<Data, Error>> {
        let changePasswordResult = PublishSubject<Result<Data, Error>>()
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.updatePassword,
                                                endPoint: serviceManager.userID,
                                                sobjects: true)
        let path = EnvironmentPath.salesforceServiceBase + endpoint
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.post.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            let params: [String: Any]  = [
                Constants.Networking.newPassword: newPassword
            ]
            request.httpBody = serviceManager.generateHTTPBody(from: params)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                changePasswordResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                changePasswordResult.onCompleted()
            }
            dataTask.resume()
        }
        return changePasswordResult.asObservable()
    }
    
    func getUser() -> Observable<Result<Data, Error>> {
        let userResult = PublishSubject<Result<Data, Error>>()
        
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.user,
                                                endPoint: "",
                                                sobjects: true)
        let path = EnvironmentPath.salesforceServiceBase + endpoint
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                userResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                userResult.onCompleted()
            }
            dataTask.resume()
        }
        return userResult.asObservable()
    }
    
    func getUserDetails() -> Observable<Result<Data, Error>> {
        let userDetailsResult = PublishSubject<Result<Data, Error>>()
        
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.userDetails,
                                                endPoint: serviceManager.userID,
                                                sobjects: true)
        let path = EnvironmentPath.salesforceServiceBase + endpoint
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                userDetailsResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                userDetailsResult.onCompleted()
            }
            dataTask.resume()
        }
        return userDetailsResult.asObservable()
    }
    
    func getAccountInformation(forAccountId accountId: String) -> Observable<Result<Data, Error>> {
        let accountInformationResult = PublishSubject<Result<Data, Error>>()
        
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.accountInformation,
                                                endPoint: accountId,
                                                sobjects: true)
        let path = EnvironmentPath.salesforceServiceBase + endpoint
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                accountInformationResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                accountInformationResult.onCompleted()
            }
            dataTask.resume()
        }
        return accountInformationResult.asObservable()
    }
    
    func getContactInformation(forContactId contactId: String) -> Observable<Result<Data, Error>> {
        let contactInformationResult = PublishSubject<Result<Data, Error>>()
        
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.contactInformation,
                                                endPoint: contactId,
                                                sobjects: true)
        let path = EnvironmentPath.salesforceServiceBase + endpoint
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                contactInformationResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                contactInformationResult.onCompleted()
            }
            dataTask.resume()
        }
        return contactInformationResult.asObservable()
    }
    
    func updateContactInformation(forContact contact: Contact) -> Observable<Result<Data, Error>> {
        let updateContactInformationResult = PublishSubject<Result<Data, Error>>()
        
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.contactInformation,
                                                endPoint: contact.contactId,
                                                sobjects: true)
        let path = EnvironmentPath.salesforceServiceBase + endpoint
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.patch.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            let params: [String: Any]  = [
                Constants.Networking.marketingCallOptIn: contact.marketingCallOptIn ?? false,
                Constants.Networking.mobileNumber: contact.mobileNumber ?? ""
            ]
            request.httpBody = serviceManager.generateHTTPBody(from: params)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                updateContactInformationResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                updateContactInformationResult.onCompleted()
            }
            dataTask.resume()
        }
        return updateContactInformationResult.asObservable()
    }
    
    func updateAccountInformation(forAccount account: Account) -> Observable<Result<Data, Error>> {
        let updateAccountInformationResult = PublishSubject<Result<Data, Error>>()
        
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.accountInformation,
                                                endPoint: account.accountId,
                                                sobjects: true)
        let path = EnvironmentPath.salesforceServiceBase + endpoint
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.patch.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            let params: [String: Any]  = [
                Constants.Networking.marketingCallOptIn: account.marketingCallOptIn ?? false,
                Constants.Networking.cellPhoneOptIn: account.cellPhoneOptIn ?? false,
                Constants.Networking.marketingEmailOptIn: account.marketingEmailOptIn ?? true
            ]
            request.httpBody = ServiceManager.shared.generateHTTPBody(from: params)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                updateAccountInformationResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                updateAccountInformationResult.onCompleted()
            }
            dataTask.resume()
        }
        return updateAccountInformationResult.asObservable()
    }
    
    func getAssiaID(forAccountId accountId: String) -> Observable<Result<Data, Error>> {
        let assiaIdResult = PublishSubject<Result<Data, Error>>()
        
        let endpoint = serviceManager.buildPath(withEnvironmentPath: EnvironmentPath.assiaID,
                                                endPoint: accountId,
                                                sobjects: false)
        let path = EnvironmentPath.salesforceServiceBase + endpoint
        // Encode the url becuase it has space
        if let requestUrl = URL(string: path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                assiaIdResult.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: response, error: error))
                assiaIdResult.onCompleted()
            }
            dataTask.resume()
        }
        return assiaIdResult.asObservable()
    }
    
    func logoutUser() -> Observable<Result<Data, Error>> {
        
        let userToLogout = PublishSubject<Result<Data, Error>>()

        let path = String(format: EnvironmentPath.logoutUser,
                          EnvironmentPath.Login.clientId,
                          ServiceManager.shared.accessToken)
        if let requestUrl = URL(string: path) {
            var request = URLRequest(url: requestUrl)
            request.httpMethod = HTTPMethod.get.rawValue
            request.allHTTPHeaderFields = ServiceManager.shared.defaultHeaders(nil)
            
            let dataTask = URLSession.shared.dataTask(with: request) { data, respose, error
                in
                userToLogout.onNext(ServiceManager.shared.handleResponseForSFApi(with: data, response: respose, error: error))
                userToLogout.onCompleted()
            }
            dataTask.resume()
        }
        return userToLogout.asObservable()
    }
}
