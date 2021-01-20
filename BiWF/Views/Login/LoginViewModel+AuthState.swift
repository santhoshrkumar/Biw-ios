//
//  LoginViewModel+AuthState.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 13/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import UIKit
import DPProtocols
import RxSwift
import RxCocoa
import AppAuth

// MARK: Authorization methods
extension LoginViewModel {
    /**
     Performs the authorization code flow.
     
     Attempts to perform a request to authorization endpoint by utilizing AppAuth's convenience method.
     Completes authorization code flow with automatic code exchange.
     The response is then passed to the completion handler, which lets the caller to handle the results.
     */
    func authorizeWithAutoCodeExchange(
        configuration: OIDServiceConfiguration,
        clientId: String,
        redirectionUri: String,
        scopes: [String] = [OIDScopeOpenID, OIDScopeProfile],
        completion: @escaping (OIDAuthState?, Error?) -> Void
    ) {
        // Checking if the redirection URL can be constructed.
        guard let redirectURI = URL(string: redirectionUri) else {
            return
        }
        // Building authorization request.
        
        let request = OIDAuthorizationRequest(
            configuration: configuration,
            clientId: clientId,
            clientSecret: nil,
            scopes: [OIDScopeOpenID],
            redirectURL: redirectURI,
            responseType: OIDResponseTypeCode,
            additionalParameters: nil
        )
        // Making authorization request.
        
        let externalAgent = OIDExternalUserAgentASWebAuthenticationSession(with: LoginViewModel.getCurrentViewController()!)
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,let sceneDelegate = windowScene.delegate as? SceneDelegate else {return}
            sceneDelegate.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, externalUserAgent: externalAgent, callback: {authState, error in completion(authState,error)
            })
        } else {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            appDelegate.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, externalUserAgent: externalAgent, callback: {authState, error in completion(authState, error)
            })
        }
    }
    /**
     Makes token exchange request.
     The code obtained from the authorization request is exchanged at the token endpoint.
     */
    func makeTokenRequest(completion: @escaping (OIDAuthState?, Error?) -> Void) {
        guard let tokenExchangeRequest = authState?.lastAuthorizationResponse.tokenExchangeRequest() else {
            return
        }
        OIDAuthorizationService.perform(tokenExchangeRequest) {
            response, error in
            
            if let response = response {
                print("Received token response with access token: ", response.accessToken ?? "")
            } else {
                print("Error making token request: \(error?.localizedDescription ?? "")")
            }
            self.authState?.update(with: response, error: error)
            completion(self.authState, error)
        }
    }
    
    /**
     Authorizes the Relying Party with an OIDC Provider.
     - Parameter issuerUrl: The OP's `issuer` URL to use for OpenID configuration discovery
     - Parameter configuration: Ready to go OIDServiceConfiguration object populated with the OP's endpoints
     - Parameter completion: (Optional) Completion handler to execute after successful authorization.
     */
    func authorizeRp(configuration: OIDServiceConfiguration?, completion: (() -> Void)? = nil) {
        /**
         Performs authorization with an OIDC Provider configuration.
         A nested function to complete the authorization process after the OP's configuration has became available.
         - Parameter configuration: Ready to go OIDServiceConfiguration object populated with the OP's endpoints
         */
        func authorize(configuration: OIDServiceConfiguration) {
            self.authorizeWithAutoCodeExchange(
                configuration: configuration,
                clientId: EnvironmentPath.Login.clientId,
                redirectionUri: self.redirectionUri
            ) {
                authState, error in
                if let authState = authState {
                    self.setAuthState(authState)
                    // Take user to tab view after successful authentication
                    self.goToTabViewSubject.onNext(())
                    if let completion = completion {
                        completion()
                    }
                } else {
                    // Authentication error
                    self.setAuthState(nil)
                    LoginViewModel.getCurrentViewController()?.dismiss(animated: false, completion: { [weak self] in
                        sleep(UInt32(0.75))
                        self?.logoutSubject.onNext(())
                    })
                    
                }
                if let completion = completion {
                    completion()
                }
            }
        }
        if let configuration = configuration {
            // Accepting passed-in OP configuration
            authorize(configuration: configuration)
        }
    }
}

// MARK: OIDAuthState methods
extension LoginViewModel {
    /**
     Saves authorization state in a storage.
     
     As an example, the user's defaults database serves as the persistent storage.
     */
    func saveState() {
        var data: Data? = nil
        if let authState = authState {
            if #available(iOS 12.0, *) {
                data = try! NSKeyedArchiver.archivedData(withRootObject: authState, requiringSecureCoding: false)
            } else {
                data = NSKeyedArchiver.archivedData(withRootObject: authState)
            }
        }
        if let authData = data {
            UserDefaults.standard.set(true, forKey: Constants.Common.appLaunchedAfterDelete)
            TokenManager.shared.keychainWrapper.set(authData, forKey: EnvironmentPath.Login.authStateKey)
        }
    }
    
    /**
     Reacts on authorization state changes events.
     */
    func stateChanged() {
        self.saveState()
    }
    
    /**
     Assigns the passed in authorization state to the class property.
     Assigns this controller to the state delegate property.
     Reacts with UI changes.
     */
    func setAuthState(_ authState: OIDAuthState?) {
        if (self.authState != authState) {
            self.authState = authState
            authState?.stateChangeDelegate = self
            self.stateChanged()
        }
    }
    
    /**
     Loads authorization state from a storage.
     As an example, the user's defaults database serves as the persistent storage.
     */
    func loadState() -> OIDAuthState? {
        guard let data = TokenManager.shared.keychainWrapper.data(forKey: EnvironmentPath.Login.authStateKey) else {
            return nil
        }
        var authState: OIDAuthState? = nil
        if #available(iOS 12.0, *) {
            authState = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? OIDAuthState
        } else {
            authState = NSKeyedUnarchiver.unarchiveObject(with: data) as? OIDAuthState
        }
        if let authState = authState {
            self.setAuthState(authState)
        }
        return authState
    }
    
    static func getCurrentViewController() -> UIViewController? {
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
}

// MARK: OIDAuthState delegates
extension LoginViewModel: OIDAuthStateChangeDelegate {
    /**
     Responds to authorization state changes in the AppAuth library.
     */
    func didChange(_ state: OIDAuthState) {
        stateChanged()
    }
    
}

extension LoginViewModel: OIDAuthStateErrorDelegate {
    /**
     Reports authorization errors in the AppAuth library.
     */
    func authState(_ state: OIDAuthState, didEncounterAuthorizationError error: Error) {
        
    }
}
