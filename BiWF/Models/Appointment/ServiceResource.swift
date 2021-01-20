//
//  ServiceResource.swift
//  BiWF
//
//  Created by pooja.q.gupta on 26/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

struct ServiceResourceList: Codable {
    let records: [ServiceResource]?
    
    enum CodingKeys: String, CodingKey {
        case records = "records"
    }
}

struct ServiceResource: Codable {
    let serviceResource: ResourceDetail
    
    enum CodingKeys: String, CodingKey {
        case serviceResource = "ServiceResource"
    }
}

struct ResourceDetail: Codable {
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
    }
}
