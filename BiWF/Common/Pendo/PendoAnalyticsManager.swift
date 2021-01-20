//
//  Pendo.swift
//  BiWF
//
//  Created by Amruta Mali on 09/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import Pendo

/// PendoAnalyticsManager manage events
class PendoAnalyticsManager {
    
    /// Pendo initial set up done here
    static func configure() {
        let initParams = PendoInitParams()
        initParams.visitorId = ServiceManager.shared.email
        initParams.accountId = ServiceManager.shared.email
        PendoManager.shared().initSDK(EnvironmentPath.pendoAppKey, initParams: initParams)
    }
}
