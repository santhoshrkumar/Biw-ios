//
//  Contact.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 08/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

struct Contact: Codable {

    let contactId: String?
    var marketingEmailOptIn: Bool?
    var marketingCallOptIn: Bool?
    var cellPhoneOptIn: Bool?
    var mobileNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case contactId = "Id"
        case marketingEmailOptIn = "Email_Opt_In__c"
        case marketingCallOptIn = "Marketing_Opt_In__c"
        case cellPhoneOptIn = "Cell_Phone_Opt_In__c"
        case mobileNumber = "MobileNumber"
    }
}

