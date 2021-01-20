//
//  ServiceManager.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 05/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import LocalAuthentication
import RxSwift

class ServiceManager {
    private let disposeBag = DisposeBag()
    
    static let shared: ServiceManager = {
        let instance = ServiceManager()
        return instance
    }()
    
    //TODO:- Remove this assiaID when you get assiaID from all the accounts
    let tempAssiaID = "C4000XG1950000308" // Calvin's Modem serial number: "C4000XG1950000308"
    let tempLineID = "1000365443" // Calvins Modem
    let orgIDValue = EnvironmentPath.orgID //ID provide by SF team
    
    fileprivate var version: String {
        return EnvironmentPath.salesForceVersion
    }
    
    var accessToken: String {
        if let accessToken = TokenManager.shared.getAuthToken() {
            return accessToken
        }
        return ""
    }
    
    var accountID: String? {
        return UserDefaults.standard.value(forKey: Constants.Common.accountID) as? String
    }
    
    var billingState: String? {
        return UserDefaults.standard.value(forKey: Constants.Common.billingState) as? String
    }
    
    var email: String? {
        return UserDefaults.standard.value(forKey: Constants.Common.email) as? String
    }
    
    var phone: String? {
        return UserDefaults.standard.value(forKey: Constants.Common.phone) as? String
    }
    
    var userID: String? {
        return UserDefaults.standard.value(forKey: Constants.Common.userID) as? String
    }
    
    var orgID: String? {
        return UserDefaults.standard.value(forKey: Constants.Common.orgID) as? String
    }
    
    func set(accountID: String?) {
        UserDefaults.standard.set(accountID, forKey: Constants.Common.accountID)
    }
    
    func set(billingState: String?) {
        UserDefaults.standard.set(billingState, forKey: Constants.Common.billingState)
    }
    
    func set(email: String?) {
        UserDefaults.standard.set(email, forKey: Constants.Common.email)
    }
    
    func set(phone: String?) {
        UserDefaults.standard.set(phone, forKey: Constants.Common.phone)
    }
    
    func set(userID: String?) {
        UserDefaults.standard.set(userID, forKey: Constants.Common.userID)
    }
    
    func set(orgID: String?) {
        //TODO:- Currently no API gives org ID so added mock ID provided by SF team
        UserDefaults.standard.set(orgIDValue, forKey: Constants.Common.orgID)
        //UserDefaults.standard.set(orgID, forKey: Constants.Common.orgID)
    }
    
    var assiaID: String {
        return UserDefaults.standard.value(forKey: Constants.Common.assiaID) as? String ?? tempAssiaID
    }
    
    func set(assiaID: String?) {
        UserDefaults.standard.set(assiaID, forKey: Constants.Common.assiaID)
    }
    
    var lineID: String {
        return UserDefaults.standard.value(forKey: Constants.Common.lineID) as? String ?? tempLineID
    }
    
    func set(lineID: String?) {
        UserDefaults.standard.set(lineID, forKey: Constants.Common.lineID)
    }
    
    //TODO:- passing true -  will need to be updated when all scenarios  are flushed out
    var forcePing: String {
        return "true"
    }
    
    
    func buildPath(withEnvironmentPath path: EnvironmentPath, endPoint: String?, sobjects: Bool) -> String {
        
        let path = String(format: path.rawValue,
                          endPoint ?? "")
        let basePath = sobjects ? String(format: "/%@/sobjects/%@", version, path) : String(format: "/%@/%@", version, path)
        return basePath
    }
    
    func buildServicePath(with environmentPath: EnvironmentPath, firstEndPoint: String?, secondEndPoint: String?) -> String {
        let path = String(format: environmentPath.rawValue,
                          firstEndPoint ?? "",
                          secondEndPoint ?? "")
        return path
    }
    
       func generateHTTPBody(from params: [String: Any]?) -> Data? {
        guard let parameters = params else { return nil }
        return try? JSONSerialization.data(withJSONObject: parameters,
                                           options: .prettyPrinted)
    }
    
    private func mergeOptionals(_ optional: [String: Any]?, base: [String: Any]) -> [String: Any] {
        guard let additions = optional else {
            return base
        }
        // If there's a conflict, take the new override
        return base.merging(additions) { (_, new) in new }
    }
    
    func defaultHeaders(_ headers: [String: String]?) -> [String: String] {
        let defaultHeaders  = [
            "Authorization": "Bearer "+accessToken,
            "Accept": "application/json",
            "Content-Type" : "application/json; charset=utf-8"
        ]
        guard let merged = mergeOptionals(headers, base: defaultHeaders) as? [String: String]
            else { return defaultHeaders }
        return merged
    }

    func getHTTPError(forStatusCode: Int) -> HTTPError? {
        switch forStatusCode {
        case HTTPStatusCode.ok.rawValue:
            return nil
            
        case HTTPStatusCode.unauthorized.rawValue:
            return HTTPError.unauthorized
            
        case HTTPStatusCode.forbidden.rawValue:
            return HTTPError.forbidden

        case HTTPStatusCode.notFound.rawValue:
            return HTTPError.notFound

        case HTTPStatusCode.success.rawValue,
             HTTPStatusCode.invalid.rawValue,
             HTTPStatusCode.oldData.rawValue,
             HTTPStatusCode.cancellationSuccess.rawValue:
            return nil
        default:
            return HTTPError.unknownStatusCode
        }
    }
    
    static func getErrorMessage(forError error: Error) -> String {
        let apiError: NSError = error as NSError
        if apiError.code == NSURLErrorTimedOut && !Reachability.isConnectedToNetwork() {
            return Constants.Common.networkErrorOccurred
        }
        guard let errorMessageArray = apiError.userInfo.values.first as? Array<Any>,
            let messageContent = errorMessageArray.first as? NSMutableDictionary,
            let message = messageContent[Constants.Networking.message] as? String
            else { return error.localizedDescription }
        return message
    }
    
    static func buildQueryUrl(path: String, parameters: [String : String]) -> URL? {
        var urlComps = URLComponents(string: path)
        urlComps?.queryItems = parameters.map { return URLQueryItem(name: $0, value: $1)}
        
        return urlComps?.url
    }
    
    func handleResponseForSFApi(with data: Data?, response: URLResponse?, error: Error?) -> Result<Data, Error> {
        if let error = error {
            return .failure(error)
        }
        guard let response = response as? HTTPURLResponse else {
            return (.failure(HTTPError.noResponse))
        }
        if let httpError = ServiceManager.shared.getHTTPError(forStatusCode: response.statusCode) {
            return (.failure(httpError))
        }
        guard let data = data else {
            return (.failure(HTTPError.noData))
        }
        return (.success(data))
    }

    func getResponseData(data: Data?) -> String {
        if let jsonData = try? JSONSerialization.jsonObject(with: data!, options: []) {
            guard let responseData = jsonData as? Array<Any>,
                let content = responseData.first as? [String: String],
                let message = content[Constants.Networking.message]
                else { return ""}
            return message
        }
        return ""
    }

    static func getMcAfeeError(forStatusCode: Int) -> String {
        switch forStatusCode {
        case McAfeeStatusCode.devicesNotProvisioned.rawValue:
            return McAfeeError.devicesNotProvisioned.rawValue

        case McAfeeStatusCode.invalidInput.rawValue:
            return McAfeeError.invalidInput.rawValue

        case McAfeeStatusCode.invalidToken.rawValue:
            return McAfeeError.invalidToken.rawValue

        case McAfeeStatusCode.notFound.rawValue:
            return McAfeeError.notFound.rawValue

        default:
            return McAfeeError.unhandled.rawValue
        }
    }
}
