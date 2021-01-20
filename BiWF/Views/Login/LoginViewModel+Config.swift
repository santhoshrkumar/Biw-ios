//
//  LoginViewModel+Config.swift
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

// MARK: OIDC Provider configuration
extension LoginViewModel {
    /**
     Returns OIDC Provider configuration.
     In this method the endpoints are provided manually.
     */
    func getOIDCProviderConfiguration() -> OIDServiceConfiguration {
        let configuration = OIDServiceConfiguration.init(
            authorizationEndpoint: URL(string: EnvironmentPath.Login.authorizationEndpoint)!,
            tokenEndpoint: URL(string: EnvironmentPath.Login.tokenEndpoint)!
        )
        return configuration
    }
}
