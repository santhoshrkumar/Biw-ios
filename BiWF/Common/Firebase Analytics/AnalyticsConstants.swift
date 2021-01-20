//
//  AnalyticsConstants.swift
//  BiWF
//
//  Created by Amruta Mali on 05/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

enum AnalyticsConstants {
    //Mark:- Google analytics event name
    enum Event {
        static let eventTypeScreenLaunch = "screen_launch"
        static let eventTypeButtonTapped = "button_tapped"
        static let eventTypeCardSelected = "card_selected"
        static let eventTypeListItemTapped = "list_item_tapped"
        static let eventTypeAPICall = "api_call"
        static let eventTypeBiometricLogin = "biometrics_login"
        static let eventTypeToggleButtonTapped = "toggle_state_changed"
    }
    
    //Mark:- Screen Name
    enum EventScreenName {
        //Account Tab
        static let account = "Accounts Screen"
        static let subscription = "Subscription Screen"
        static let statement = "Invoice Statement Screen"
        static let editPaymentInformation = "Edit Payment Details Screen"
        static let cancelSubscription = "Cancel Subscription Screen"
        static let cancelSubscriptionDetails = "Cancel Subscription Details Screen"
        static let personalInformation = "Personal Info Screen"
        static let cancelSubscriptionPopup = "Cancel Subscription Popup Screen"
        static let changeEmailInfoPopup = "Change Email Info Popup"
        
        //Devices Tab
        static let devices =  "Devices Screen"
        static let devicesDetail = "Devices Details Screen"
        
        //Support Tab
        static let support = "Support Screen"
        static let FAQ = "FAQ Screen"
        static let scheduleCallbackSupport = "Schedule-Callback Support Screen"

        //FAQ Tab
        static let additionalInfo = "Additional Info Screen"
    }
    
    //Mark:- Card Name
    enum EventCardViewName {
        static let subscriptionInfo = "Subscription Info"
        static let personalInfo = "Personal Info"
    }
    
    //Mark:- Card Name
    enum EventListItemName {
        //Device Tab
        static let removedDevices = "List item clicked Removed devices list"
        static let connectedDevices = "List item clicked Connected devices list"
        //Support Tab
        static let FAQListItem = "FAQ list Item Support"
        static let scheduleCallbackItem = "List item Schedule-Callback Screen"
    }

    //Mark:- Button Name
    enum EventButtonTitle {
        //Account Tab
        static let personalInformationDone = "Done Button Personal Information"
        static let subscriptionDone = "Done Button Subscription"
        static let editPaymentInformationDone = "Done Button Edit Payment Details"
        static let editPaymentInformationBack = "Back Button Edit Payment Details"
        static let statementDone = "Done Button Previous Statements"
        static let statementBack = "Back Button Previous Statements"
        static let cancelSubscriptionBack = "Back Button Cancel Subscription"
        static let cancelSubscriptionCancel = "Cancel Button Cancel Subscription"
        static let submitCancelSubscription = "Submit Button Cancel Subscription Confirmation"
        static let cancelSubscriptionDetailBack = "Back Button Cancel Subscription Confirmation"
        static let cancelSubscriptionDetailCancel = "Cancel Button Cancel Subscription Confirmation"
        static let keepServices = "Keep Service Cancel Subscription Confirmation"
        static let cancelServices = "Cancel Service Cancel Subscription Confirmation"
        static let logout = "Logout Button"
        
        //Devices Tab
        static let connectedDevicesExpandCollapseArrow = "Connected devices expandable list"
        static let deviceDetailDone = "Done Button Devices Details"
        static let restoreAccess = "Restore-Access Removed Devices Confirmation"
        static let restoreAccessCancel = "Cancel Restore-Access Removed Devices Confirmation"
        static let removeDeviceConfirmation = "Remove Devices Button Devices Details"
        static let canncelRemoveDeviceConfirmation = "Cancel, Remove Device Confirmation Devices Details"
        static let listItemIcon = "List item icon Connected devices" // TODO
        static let removeDeviceConncection = "Connection Status Button Remove Details"
        static let pauseConnectionDeviceScreen = "Button Pause Connection Device Screen"
        static let unpauseConnectionDeviceScreen = "Button UnPause Connection Device Screen"
        static let pauseConnectionDeviceDetailScreen = "Button Pause Connection Device Details"
        static let unpauseConnectionDeviceDetailScreen = "Button UnPause Connection Device Details"
        
        //Support Tab
        static let supportDone = "Done Button Support"
        static let liveChatSupport = "Live Chat Support"
        static let scheduleCallbackSupport = "Schedule a Callback Support"
        static let runSpeedTest = "Run Speed Test Button Support"
        static let restartModem = "Restart Modem Button Support"
        static let visitWebsiteFromSupport = "Visit Website Modem Button Support"
        static let cancelScheduleCallback = "Cancel Button Schedule-Callback Screen"
        static let backScheduleCallback = "Back Button Schedule-Callback Screen"
        static let callUsNowScheduleCallback = "Call us now Schedule-Callback Screen"
        static let supportButton = "Button Support Home Screen"
        static let restartModemSuccess = "Restart Modem Success Popup"
        static let restartModemFailure = "Restart Modem Failure Popup"
        
        //FAQ Tab
        static let FAQDetailsDone = "Done Button FAQ Details Screen"
        static let FAQDetailsBack = "Back Button FAQ Details Screen"
        static let FAQDetailsListExpand = "FAQ Details list expand"
        static let FAQDetailsListCollapse = "FAQ Details list collapse"
        static let liveChatFAQDetails = "Live Chat FAQ Details Screen"
        static let scheduleCallbackFAQDetails = "Schedule a Callback FAQ Details Screen"
        static let additionalInfoNext = "Next Button Additional Info Screen" //TODO
        static let additionalInfoCancel = "Cancel Button Additional Info Screen"
        static let additionalInfoBack = "Back Button Additional Info Screen"
    }
    
    //Mark:- Toggle Button Name
    enum EventToggleButton {
        enum Name {
            static let biometrics = "Biometric"
            static let marketingEmails = "Marketing Emails"
            static let marketingCallsTexts = "Marketing Calls & Texts"
            static let serviceCalls = "Service calls & texts"
        }
        
        //Toggle Button
        enum State {
            static let ON = "On"
            static let OFF = "Off"
        }
    }
    
    //Mark:- API call
    enum EventAPICall {
        //Account Tab
        static let accountDetailsSuccess = "Account Details Api Success"
        static let accountDetailsFailure = "Account Details Api Failure"
        static let contactDetailsSuccess = "Contact Api Success"
        static let contactDetailsFailure = "Contact Api Failure"
        static let updateContactDetailsSuccess = "Update Contact Api Success"
        static let updateContactDetailsFailure = "Update Contact Api Failure"
        static let invoicesListSuccess = "Invoices List Api Success"
        static let invoicesListFailure = "Invoices List  Api Failure"
        static let liveCardInfoSuccess = "Live Card Info Api Success"
        static let liveCardInfoFailure = "Live Card Info Api Failure"
        static let resetPasswordSuccess = "Reset Password Api Success"
        static let resetPasswordFailure = "Reset Password Api  Failure"
        static let recordTypeIDSuccess = "Record Type Id Api Success"
        static let recordTypeIDFailure = "Record Type Id Api  Failure"
        static let userDetailsSuccess = "User Details Api Success"
        static let userDetailsFailure = "User Details Api Failure"
        static let paymentInfoSuccess = "Payment Info Api Success"
        static let fiberPlanInfoSuccess = "Fiber Plan Info Api Success"
        static let paymentInfoFailure = "Payment Info Api Failure"
        static let fiberPlanInfoFailure = "Fiber Plan Info Api Failure"
        static let cancelSubscriptionSuccess = "Cancel Subscription Api Success"
        static let cancelSubscriptionFailure = "Cancel Subscription Api Failure"
        
        //Devices Tab
        static let devicesDetailsSuccess = "Devices Details Api Success"
        static let devicesDetailsFailure = "Devices Details Api Failure"
        static let unblockDevicesListSuccess = "UnBlock Device Api Success"
        static let unblockDevicesListFailure = "UnBlock Device Api Failure"
        static let blockDevicesListSuccess = "Block Device Api Success"
        static let blockDevicesListFailure = "Block Device Api Failure"
        static let modemInfoSuccess = "Modem Info Api Success"
        static let modemInfoFailure = "Modem Info Api Failure"
        static let weeklyUsageDetailsSuccess = "Usage Details BiWeekly Api Success"
        static let weeklyUsageDetailsFailure = "Usage Details BiWeekly Api Failure"
        static let dailyUsageDetailsSuccess = "Usage Details Daily Api Success"
        static let dailyUsageDetailsFailure = "Usage Details Daily Api Failure"
        
        //Support Tab
        static let recordTypeIdSuccess = "Record Type Id Api Success"
        static let recordTypeIdFailure = "Record Type Id Api Failure"
        static let FAQQuestionSuccess = "FAQ Question Api Success"
        static let FAQQuestionFailure = "FAQ Question Api Failure"
        static let startSpeedTestSuccess = "Start Speed Test Api Success"
        static let startSpeedTestFailure = "Start Speed Test Api Failure"
        static let checkSpeedTestSuccess = "Check Speed Test Api Success"
        static let checkSpeedTestFailure = "Check Speed Test Api Failure"
        static let getUpstreamResultsSuccess = "Get Upstream Results Api Success"
        static let getUpstreamResultsFailure = "Get Upstream Results Api Failure"
        static let getDownstreamResultsSuccess = "Get Downstream Results Api Success"
        static let getDownstreamResultsFailure = "Get Downstream Results Api Failure"
    }
}
