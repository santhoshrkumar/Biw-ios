//
//  TokenManager.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 14/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.

import Foundation
import UIKit
import DPProtocols
import RxSwift
import RxCocoa
import AppAuth
import SwiftKeychainWrapper

/**
Manager handles all token auth related logic and values
 */
class TokenManager {
    
    /// Keychain wrapper add token value in device keychain
    let keychainWrapper = KeychainWrapper.standard
    

    /// TokenManager shared object
    static let shared: TokenManager = {
        let instance = TokenManager()
        return instance
    }()
    
    /// Method returns saved auth token in keychain
    /// - returns:
    ///   - String: Auth token
    func getAuthToken() -> String? {
        let authDetails = authState()
        return authDetails?.lastTokenResponse?.accessToken
    }

    /// Method returns refreshToken auth token in keychain
    /// - returns:
    ///   - String: refresh token
    func getRefreshToken() -> String {
        let authDetails = authState()
        return authDetails?.lastTokenResponse?.refreshToken ?? ""
    }
    
    /// Method returns authState in keychain
    /// - returns:
    ///   - OIDAuthState: Auth state with all details coming from login API
    func authState() -> OIDAuthState? {

        guard let data = keychainWrapper.data(forKey: EnvironmentPath.Login.authStateKey) else {
            return nil
        }
        
        var authState: OIDAuthState? = nil
        if #available(iOS 12.0, *) {
            authState = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? OIDAuthState
        } else {
            authState = NSKeyedUnarchiver.unarchiveObject(with: data) as? OIDAuthState
        }
        return authState
    }

    /// Method returns isUserAuthorised
    /// - returns:
    ///   - Bool: isAuthorise login required or not
    func isUserAuthorised() -> Bool {
        if (!(UserDefaults.standard.bool(forKey: Constants.Common.appLaunchedAfterDelete))) {
            signOutUser()
        }
        guard ((keychainWrapper.data(forKey: EnvironmentPath.Login.authStateKey)) != nil),
              getAuthToken() != nil else {
            return false
        }
        return true
    }
    
    /// Method signOutUser
    func signOutUser() {
        keychainWrapper.removeAllKeys()
        // Clearing the authorization state
//        refreshToken()
        saveState()
        
    }

    /// Method checkTokenValidity
    func checkTokenValidity() {
        let authDetails = authState()
        if let idToken = authDetails?.lastTokenResponse?.accessToken,
            let endSessionEndpoint = authDetails?.lastTokenResponse?.request.configuration.tokenEndpoint {
            var urlComponents = URLComponents(url: endSessionEndpoint, resolvingAgainstBaseURL: false)
            
            urlComponents?.queryItems = [URLQueryItem(name: "id_token_hint", value: idToken)]
            
            if let endSessionEndpointUrl = urlComponents?.url {
                let urlRequest = URLRequest(url: endSessionEndpointUrl)
                
                sendUrlRequest(urlRequest: urlRequest) {
                    data, response, request in
                    
                    if !(200...299).contains(response.statusCode) {
                        // Handling server errors
                        self.keychainWrapper.removeAllKeys()
                    }
                    if data != nil, data!.count > 0 {
                        self.keychainWrapper.removeAllKeys()
                    }
                }
            }
        }
    }
    
    /**
     Sends a URL request.
     
     Sends a predefined request and handles common errors.
     
     - Parameter urlRequest: URLRequest optionally crafted with additional information, which may include access token.
     - Parameter completion: Escaping completion handler allowing the caller to process the response.
     */
    func sendUrlRequest(urlRequest: URLRequest, completion: @escaping (Data?, HTTPURLResponse, URLRequest) -> Void) {
        let task = URLSession.shared.dataTask(with: urlRequest) {
            data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    // Handling transport error
                    print("HTTP request failed \(error?.localizedDescription ?? "")")
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    // Expecting HTTP response
                    print("Non-HTTP response")
                    return
                }
                completion(data, response, urlRequest)
            }
        }
        task.resume()
    }
    
    /**
     Saves authorization state in a storage.
     As an example, the user's defaults database serves as the persistent storage.
     */
    func saveState() {
        var data: Data? = nil
        let authState = getAuthToken()
        if let authState = authState {
            if #available(iOS 12.0, *) {
                data = try! NSKeyedArchiver.archivedData(withRootObject: authState, requiringSecureCoding: false)
            } else {
                data = NSKeyedArchiver.archivedData(withRootObject: authState)
            }
        }
        if let authData = data {
            UserDefaults.standard.set(true, forKey: Constants.Common.appLaunchedAfterDelete)
            keychainWrapper.set(authData, forKey: EnvironmentPath.Login.authStateKey)
        }
    }
    /**
         Refresh token
     */
    func refreshToken() {
        if checkAuthState() {
            let authDetails = authState()
            authDetails?.setNeedsTokenRefresh()
            let currentAccessToken: String? = authDetails?.lastTokenResponse?.accessToken

            /** Validating and refreshing tokens */
            authDetails?.performAction(){
                accessToken, idToken, error in
                if error != nil {
                    return
                }
                guard let accessToken = accessToken else {
                    return
                }
                if currentAccessToken != accessToken {
                    self.saveState()
                } else {

                }
            }
        }
    }
    /**
     *  Verifies authState was performed
     */
    func checkAuthState() -> Bool {
        if (authState() != nil){
            return true
        } else { return false }
    }
}
