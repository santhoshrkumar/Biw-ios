//
//  AssiaIdResponse.swift
//  BiWF
//
//  Created by pooja.q.gupta on 23/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

struct AssiaIdResponse: Codable {

    let records: [AssiaIdRecord]
    
    enum CodingKeys: String, CodingKey {
        case records = "records"
    }
}

struct AssiaIdRecord: Codable {
    let modemNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case modemNumber = "Modem_Number__c"
    }
}
