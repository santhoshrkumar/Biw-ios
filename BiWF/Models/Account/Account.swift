//
//  Account.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 08/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

struct Account: Codable {
    
    let accountId: String?
    let name: String?
    let firstName: String?
    let billingAddress: BillingAddress
    var marketingEmailOptIn: Bool?
    var marketingCallOptIn: Bool?
    var cellPhoneOptIn: Bool?
    var productName: String?
    var productPlanName: String?
    var email: String?
    var accountStatus: String?
    var contactId: String?
    var subscriptionEndDate: String?
    var phone: String?
    var serviceAddress: String?
    let lineId: String?
    let serviceCity: String?
    let servicrCountry: String?
    let serviceState: String?
    let serviceStreet: String?
    let serviceZipCode: String?
    let serviceUnit: String?
    let nextPaymentDate: String?
    
    enum CodingKeys: String, CodingKey {
        case accountId = "Id"
        case contactId = "contactId"
        case name = "Name"
        case firstName = "FirstName__c"
        case billingAddress = "BillingAddress"
        case marketingEmailOptIn = "Email_Opt_In__c"
        case marketingCallOptIn = "Marketing_Opt_In__c"
        case cellPhoneOptIn = "Cell_Phone_Opt_In__c"
        case productName = "Product_Name__c"
        case productPlanName = "Product_Plan_Name__c"
        case email = "Email"
        case accountStatus = "AccountStatus__c"
        case subscriptionEndDate = "subscriptionEndDate"
        case phone = "Phone"
        case serviceAddress = "Service_Address__c"
        case lineId = "DTN_Text__c"
        case serviceCity = "Service_City__c"
        case servicrCountry = "Service_Country__c"
        case serviceState = "Service_State_Province__c"
        case serviceStreet = "Service_Street__c"
        case serviceZipCode = "Service_Zip_Postal_Code__c"
        case serviceUnit = "Unit__c"
        case nextPaymentDate = "Next_Renewal_Date__c"
    }
    
    static func getFullAddress(billingAddress: BillingAddress) -> String {
        return "\(billingAddress.street ?? "")\n\(billingAddress.city ?? "") \(billingAddress.state ?? ""), \(billingAddress.postalCode ?? "")"
    }
    
    func getFormattedAddress() -> String {
        if let address = self.serviceAddress {
            let addressString = address.replacingOccurrences(of: "   ", with: " ", options: .literal, range: nil)
            return addressString
        }
        return ""
    }
    
    func getFormattedCity() -> String {
        if let city = self.serviceCity {
            let cityString = city + ","
            return cityString
        }
        return ""
    }
    
    func formatedPhoneNumber(inGeneralFormat: Bool) -> String {
        if let phoneNumber = self.phone {
            return phoneNumber.applyPatternOnNumbers(inGeneralFormat: inGeneralFormat)
        }
        return ""
    }
}

struct BillingAddress: Codable {
    let street: String?
    let city: String?
    let state: String?
    let postalCode: String?
    
    enum CodingKeys: String, CodingKey {
        case street = "street"
        case city = "city"
        case state = "state"
        case postalCode = "postalCode"
    }
}
