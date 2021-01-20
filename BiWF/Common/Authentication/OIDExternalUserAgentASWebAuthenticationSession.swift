//
//  OIDExternalUserAgentASWebAuthenticationSession.swift
//  BiWF
//
//  Created by Calvin O. Moenga on 10/20/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//
/*
 This Class extends the AppAuth library to suppress the Data sharing pop up that the lacks. This implements the setting of "prefersEphemeralWebBrowserSession"
 */

import Foundation
import UIKit
import SafariServices
import AuthenticationServices
import AppAuth

class OIDExternalUserAgentASWebAuthenticationSession: NSObject, OIDExternalUserAgent {
    private let presentingViewController: UIViewController
    private var externalUserAgentFlowInProgress: Bool = false
    private var authenticationViewController: ASWebAuthenticationSession?
    
    private weak var session: OIDExternalUserAgentSession?
    
    init(with presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        self.presentingViewController.view.backgroundColor = UIColor.BiWFColors.purple
        super.init()
    }
    
    func present(_ request: OIDExternalUserAgentRequest, session: OIDExternalUserAgentSession) -> Bool {
        if externalUserAgentFlowInProgress {
            return false
        }
        guard let requestURL = request.externalUserAgentRequestURL() else {
            return false
        }
        self.externalUserAgentFlowInProgress = true
        self.session = session
       
        var openedUserAgent = false
        
        // ASWebAuthenticationSession doesn't work with guided access (Search web for "rdar://40809553")
        // Make sure that the device is not in Guided Access mode "(Settings -> General -> Accessibility -> Enable Guided Access)"
        if UIAccessibility.isGuidedAccessEnabled == false {
            let redirectScheme = request.redirectScheme()
            let authenticationViewController = ASWebAuthenticationSession(url: requestURL, callbackURLScheme: redirectScheme) { (callbackURL, error) in
                self.authenticationViewController = nil
                if let url = callbackURL {
        
                    self.session?.resumeExternalUserAgentFlow(with: url)
                } else {
                    let webAuthenticationError = OIDErrorUtilities.error(with: OIDErrorCode.userCanceledAuthorizationFlow,
                                                              underlyingError: error,
                                                              description: nil)
                    self.session?.failExternalUserAgentFlowWithError(webAuthenticationError)
                }
            }
            if #available(iOS 13.0, *) {
                authenticationViewController.presentationContextProvider = self
            } else {
                // Fallback on earlier versions
            }
            /// ** Key Line of code  -> `.prefersEphemeralWebBrowserSession`** allows for private browsing
            if #available(iOS 13.0, *) {
                authenticationViewController.prefersEphemeralWebBrowserSession = true
            } else {
                // Fallback on earlier versions
            }
            self.authenticationViewController = authenticationViewController
            openedUserAgent = authenticationViewController.start()
        } else {
            let webAuthenticationError = OIDErrorUtilities.error(with: OIDErrorCode.safariOpenError,
                                                      underlyingError: nil,
                                                      description: nil)
            self.session?.failExternalUserAgentFlowWithError(webAuthenticationError)
        }
        return openedUserAgent
    }
    
    func dismiss(animated: Bool, completion: @escaping () -> Void) {
        // Ignore this call if there is no authorization flow in progress.
        if externalUserAgentFlowInProgress == false {
            completion()
        }
        cleanUp()
        if authenticationViewController != nil {
            authenticationViewController?.cancel()
            completion()
        } else {
            completion()
        }
        return
    }
}

extension OIDExternalUserAgentASWebAuthenticationSession {
    /// Sets class variables to nil. Note 'weak references i.e. session are set to nil to avoid accidentally using them while not in an authorization flow.
    func cleanUp() {
        session = nil
        authenticationViewController = nil
        externalUserAgentFlowInProgress = false
    }
}

extension OIDExternalUserAgentASWebAuthenticationSession: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return presentingViewController.view.window!
    }
}
