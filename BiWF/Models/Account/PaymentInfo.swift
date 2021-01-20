//
//  PaymentInfo.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 7/27/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

struct PaymentInfo: Codable {
    let card: String
    let billCycleDay: String
    var nextRenewalDate: String?
    let id: String
    
    var formattedPaymentDate: String {
        if let dateString = nextRenewalDate {
            return dateString.formattedDateFromString(
                dateString: dateString,
                inFormat: Constants.DateFormat.YYYY_MM_dd,
                withFormat: Constants.DateFormat.MMddyy
            )
            ?? "n/a"
        } else {
            return "n/a"
        }
    }

    enum CodingKeys: String, CodingKey {
        case card = "Credit_Card_Summary__c"
        case billCycleDay = "Zuora__BillCycleDay__c"
        case nextRenewalDate = "Next_Renewal_Date__c"
        case id = "Id"
    }
}

struct PaymentInfoResponse: Codable {
    let records: [PaymentInfo]
}
