//
//  AnalyticsEvents.swift
//  BiWF
//
//  Created by Amruta Mali on 05/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import FirebaseAnalytics
/*
 AnalyticsEvents contains all the analytics events function to be triggerd
 */
class AnalyticsEvents {
    
    /// Triggerd when user visits any screen
    /// - Parameter screenName : Name of the screen which user visits
    static func trackScreenVisitEvent(with screenName: String) {
        FirebaseAnalyticsManager().createEvent(eventName: AnalyticsConstants.Event.eventTypeScreenLaunch,
                                               parameters: [AnalyticsParameterItems: screenName])
    }
    
    /// Triggerd when user tap on any card view
    /// - Parameter cardName : Name of the card which user tapped
    static func trackCradViewTappedEvent(with cardName: String) {
        FirebaseAnalyticsManager().createEvent(eventName: AnalyticsConstants.Event.eventTypeCardSelected,
                                               parameters: [AnalyticsParameterItems: cardName])
    }
    
    /// Triggerd when user tapped on list of items
    /// - Parameter listItem : List of items which user seeing
    static func trackListItemTappedEvent(with listItem: String) {
        FirebaseAnalyticsManager().createEvent(eventName: AnalyticsConstants.Event.eventTypeListItemTapped,
                                               parameters: [AnalyticsParameterItems: listItem])
    }
    
    /// Triggerd when user change toggle button state
    /// - Parameter buttonName : Name of the button which user tapped
    static func trackButtonTapEvent(with buttonName: String) {
        FirebaseAnalyticsManager().createEvent(eventName: AnalyticsConstants.Event.eventTypeButtonTapped,
                                               parameters: [AnalyticsParameterItems: buttonName])
    }
    
    /// Triggerd when user tapped on any toggle button
    /// - Parameter buttonName : Name of the toggle button which user tapped
    /// value : true/false
    static func trackToggleButtonChangeEvent(with buttonName: String, value: Bool) {
        FirebaseAnalyticsManager().createEvent(eventName: AnalyticsConstants.Event.eventTypeToggleButtonTapped,
                                               parameters: [AnalyticsParameterItems: buttonName,
                                                            AnalyticsParameterValue: value ? AnalyticsConstants.EventToggleButton.State.ON : AnalyticsConstants.EventToggleButton.State.OFF])
    }
    
    /// Triggerd when any API call is done
    /// - Parameter screenName : Name of the screen which user visits
    static func trackAPICallEvent(with screenName: String) {
        FirebaseAnalyticsManager().createEvent(eventName: AnalyticsConstants.Event.eventTypeAPICall,
                                               parameters: [AnalyticsParameterItems: screenName])
    }
    
    /// Triggerd when any biometric event is called
    /// - Parameter value : true/false
    static func trackBiometricEvent(with value: Bool) {
        FirebaseAnalyticsManager().createEvent(eventName: AnalyticsConstants.Event.eventTypeBiometricLogin,
                                               parameters: [AnalyticsParameterItems: AnalyticsConstants.EventToggleButton.Name.biometrics,
                                                            AnalyticsParameterValue: value ? AnalyticsConstants.EventToggleButton.State.ON : AnalyticsConstants.EventToggleButton.State.OFF])
    }
}

