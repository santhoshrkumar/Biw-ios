//
//  StatementList.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 12/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

struct StatementList: Codable {
    let totalSize: Int?
    let done: Bool?
    let records: [PaymentRecord]?
    
    enum CodingKeys: String, CodingKey {
        case totalSize = "totalSize"
        case done = "done"
        case records = "records"
    }
}

