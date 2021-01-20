//
//  GoogleTagManager.swift
//  BiWF
//
//  Created by Amruta Mali on 05/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import FirebaseAnalytics
/*
 FirebaseAnalyticsManager to manage analytics events
 */
class FirebaseAnalyticsManager {

     /// Call firebase function and send event
    /// Parameter : event name and parameters : with extra or other information of event
    private func fireEvent(eventName: String, parameters: Dictionary<String, Any>?) {
        Analytics.logEvent(eventName, parameters: parameters)
    }

    /// Creates an event
    /// Parameter : event name and parameters : with extra or other information of event
    func createEvent(eventName: String, parameters: Dictionary<String, Any>? = nil) {
        fireEvent(eventName: eventName, parameters: parameters)
    }
}
