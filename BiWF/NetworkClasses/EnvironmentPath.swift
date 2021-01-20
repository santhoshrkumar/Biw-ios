//
//  EnvironmentPath.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 04/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//


import Foundation
/**
 Class consists of config mappings and different API endpoints,
 */
/// Configuration enum with key mapping as per current config
enum Configuration {

    /// Enum of error if missing key or invalid value
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    /// Enum of strings for config mapping
    enum Key: String {
        case appName = "CTL_APP_NAME"
        case appBundle = "CTL_APP_BUNDLE"
        case apigeeURL = "APIGEE_URL"
        case salesforceURL = "SALESFORCE_URL"
        case orgID = "ORG_ID"
        case clientID = "CLIENT_ID"
        case redirectScheme = "REDIRECT_SCHEME"
        case communityName = "COMMUNITY_NAME"
        case salesForceVersion = "SALES_FORCE_VERSION"
        case apigeeVersion = "APIGEE_VERSION"
        case liveAgentPod = "LIVE_AGENT_POD"
        case deploymentID = "DEPLOYMENT_ID"
        case buttonID = "BUTTON_ID"
        case ambassadorButtonID = "AMBASSADOR_BUTTON_ID"
        case pendoAppKey = "PENDO_APP_KEY"
    }

    /// Check value for key
    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            throw Error.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

/// Enum for all the environment paths
enum EnvironmentPath: String {

    /// static vars for all base urls and commong url's
    static var salesforceBase: String {
        return try! "https://" + Configuration.value(for: Configuration.Key.salesforceURL.rawValue)
    }

    static var communityName: String {
        return try! Configuration.value(for: Configuration.Key.communityName.rawValue)
    }

    static var salesforceServiceBase: String {
        return salesforceBase + "/" + communityName + "/services/data"
    }

    static var salesforceApexBase: String {
        return salesforceBase + "/"
    }

    static var salesforceApexRest: String {
        return salesforceBase + "/" + communityName + "/services/apexrest"
    }
    
    static var apigeeBase: String {
        return try! "https://" + Configuration.value(for: Configuration.Key.apigeeURL.rawValue)
    }

    static var apigeeAssiaBase: String {
        return apigeeBase + "/" + apigeeVersion + "/cloudcheck/"
    }

    static var apigeeMcAfeeBase: String {
        return apigeeBase + "/" + apigeeVersion + "/mcafee/"
    }

    static var logoutUser: String {
        return apigeeBase + "/" + apigeeVersion + "/mobile/revoke?client_id=%@&token=%@"
    }

    static var pendoAppKey: String {
        return try! Configuration.value(for: Configuration.Key.pendoAppKey.rawValue)
    }

    static var salesForceVersion: String {
        return try! Configuration.value(for: Configuration.Key.salesForceVersion.rawValue)
    }
    
    static var apigeeVersion: String {
        return try! Configuration.value(for: Configuration.Key.apigeeVersion.rawValue)
    }

    static var liveAgentPod: String {
        return try! Configuration.value(for: Configuration.Key.liveAgentPod.rawValue)
    }
    
    static var deploymentID: String {
        return try! Configuration.value(for: Configuration.Key.deploymentID.rawValue)
    }
    
    static var buttonID: String {
        return try! Configuration.value(for: Configuration.Key.buttonID.rawValue)
    }

    static var ambassadorButtonID: String {
        return try! Configuration.value(for: Configuration.Key.ambassadorButtonID.rawValue)
    }

    static var orgID: String {
        return try! Configuration.value(for: Configuration.Key.orgID.rawValue)
    }
    
    /// Enum for all the Login paths
    enum Login {
         /// OAuth 2 client ID.
        static var clientId: String {
            return try! Configuration.value(for: Configuration.Key.clientID.rawValue)
        }

        /// Endpoints
        static var authorizationEndpoint: String {
            return EnvironmentPath.apigeeBase + "/" + apigeeVersion + "/mobile/auth"
        }

        static var tokenEndpoint: String {
            return EnvironmentPath.apigeeBase + "/" + apigeeVersion + "/mobile/salesforce-access-token"
        }

        /// Scheme used in the redirection URI.
        static var redirectionUriScheme: String {
            return try! Configuration.value(for: Configuration.Key.redirectScheme.rawValue)
        }

         /// The key under which the authorization state will be saved in a keyed archive.
        static let authStateKey = "authState"

        /// OpenID Connect issuer URL, where the OpenID configuration can be obtained from.
        static var issuerUrl: String {
            return EnvironmentPath.salesforceBase + "/" + EnvironmentPath.communityName
        }

        /// OAuth 2 redirection URI for the client.
        static let redirectionUri = "://oauth.pstmn.io/" + apigeeVersion + "/callback"

    }
    
    
    static var cancelAppointment: String {
        return communityName + "/services/apexrest/CancelServiceAppointmentMobile"
    }
    
    static var speedTestCallBackURL: String {
        return salesforceBase + "/services/apexrest/SpeedTest/*"
    }

    ///Account
    case updatePassword = "User/%@/password"
    case userDetails = "User/%@/"
    case user = "User"
    case accountInformation = "Account/%@"
    case contactInformation = "Contact/%@"
    case fiberInfoPlan = "query/?q=SELECT+Id,Zuora__ProductName__c,InternetSpeed__c,Zuora__Price__c,Zuora__ExtendedAmount__c+FROM+Zuora__SubscriptionProductCharge__c+WHERE+(Zuora__Account__c='%@'+AND+Zuora__ProductName__c='Fiber Internet')+AND+(Zuora__BillingPeriod__c='Month'+AND+Zuora__Type__c='Recurring')"
    
    /// Satatements/Subscriptions
    case statementsList = "query/?q=SELECT+Id,Zuora__Invoice__c,CreatedDate+FROM+Zuora__Payment__c+WHERE+Zuora__Account__c+=+'%@'"
    case zuoraPayment = "Zuora__Payment__c/%@"
    case recordTypeID = "query/?q=SELECT+Id+FROM+RecordType+WHERE+SobjectType='Case'+AND+DeveloperName='Fiber'"
    case faqRecordTypeID = "query/?q=SELECT+Id+FROM+RecordType+WHERE+SobjectType='Knowledge__kav'+AND+DeveloperName='Fiber'"
    case customerCareOptionRecordTypeID = "query/?q=SELECT+Id+FROM+RecordType+WHERE+SobjectType='Case'+AND+Name='Fiber'"
    case cancelSubscription = "Case/"
    case faqSectionList = "query/?q=SELECT+ArticleNumber,ArticleTotalViewCount,Article_Content__c,Article_Url__c,Id,Language,Section__c,Title+FROM+Knowledge__kav+WHERE+IsDeleted=false+AND+PublishStatus+=+'Online'+AND+ValidationStatus+=+'Validated'+AND+RecordTypeId='%@'"
    case assiaID = "query/?q=SELECT+Modem_Number__c+FROM+WorkOrder+WHERE+AccountId='%@'+AND+Job_Type__c='Fiber Install - For Installations'"
    case paymentInfo = "query/?q=SELECT+Credit_Card_Summary__c,Id,Name,Next_Renewal_Date__c,Zuora__BillCycleDay__c+FROM+Zuora__CustomerAccount__c+WHERE+Zuora__Account__c+=+'%@'"
    
    //Customer care options
    case customerCareOptionList = "ui-api/object-info/Case/picklist-values/%@/What_kind_of_customer_care_do_you_need__c"

    //Appointment
    case serviceAppointment =
    "query/?q=SELECT+Id,ArrivalWindowEndTime,ArrivalWindowStartTime,Status,Job_Type__c,WorkTypeId,Latitude,Longitude,ServiceTerritory.OperatingHours.TimeZone,Appointment_Number_Text__c,(SELECT+ServiceResource.Name+FROM+ServiceAppointment.ServiceResources)+FROM+ServiceAppointment+WHERE+AccountId='%@'+ORDER+BY+CreatedDate+DESC"
    case appointmentSlot = "services/apexrest/AppointmentSlotsMobile/?ServiceAppointmentId=%@&EarliestPermittedDate=%@"
    case rescheduleAppointment = "services/apexrest/AppointmentSlotsMobile/"

    //Assia
    case asiaAccessToken = "https://ctlink-biwf-staging.cloudcheck.net/cloudcheck-sp/oauth/token?username=biwftest&password=BiwfTest1&client_id=spapi&client_secret=oBj2xZc&grant_type=password"
    case assiaBaseUrl = "https://ctlink-biwf-staging.cloudcheck.net:443/cloudcheck-sp/"
    case networkStatus = "wifi-line-info"
    case usageInfo = "station-traffic?assiaIdTraffic=%@&startDateTraffic=%@&staMacTraffic=%@"
    case deviceList = "station-info"
    case restartModem = "reboot"
    case speedTestStatus = "speed-test-status"
    case speedTestRequest = "speed-test-request"
    case blockDevice = "block"
    case unblockDevice = "unblock"

    //Regular and Guest Wifi network
    case enableRegularGuestWifi = "wifi-operations-enable?wifiDeviceId=%@&interface=%@"
    case disableRegularGuestWifi = "wifi-operations-disable?wifiDeviceId=%@&interface=%@"
    //Post/Change SSID
    case changeSSID = "change-ssid"
    //Post/change network password url
    case changeNetworkPassword = "change-wifi-pwd?wifiDeviceId=%@&interface=%@"
    //Get network password url
    case getNetworkPassword = "get-wifi-pwd?wifiDeviceId=%@&interface=%@"

    //McAfee
    case macAddressMapping = "macaddress/mapping"
    case pauseResumeNetworkAccess = "/network-access"
    case networkInfo = "get-network-access"
    case updateDeviceName = "update-device"
    case devcieInfo = "get-device"

    //Support schedule callback
    case scheduleCallback = "/ServiceAndSupportAPI"

}
