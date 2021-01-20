//
//  PaymentRecord.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 12/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit

struct PaymentRecord: Codable {
    let attributes: RecordAttributes?
    let id: String?
    let zuoraInvoice: String?
    let createdDate: String?
    var email: String?
    var billingAddress: String?
    var contactID: String?
    
    enum CodingKeys: String, CodingKey {
        case attributes = "attributes"
        case id = "Id"
        case zuoraInvoice = "Zuora__Invoice__c"
        case createdDate = "CreatedDate"
        case billingAddress = "Billing_Address"
        case email = "Email"
        case contactID = "contactID"
    }
    
    func getCreatedDate() -> String {
        guard let dateString = createdDate,
            let formatedDate = dateString.formattedDateFromString(dateString: dateString, withFormat: Constants.DateFormat.MMddyyyy)  else { return "" }
        return formatedDate
    }
    
    
}

struct RecordAttributes: Codable {
    let type: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case url = "url"
    }
}
