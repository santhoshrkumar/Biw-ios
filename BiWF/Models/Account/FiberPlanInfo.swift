//
//  FiberPlanInfo.swift
//  BiWF
//
//  Created by Santhosh Kumar on 12/9/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

struct FiberPlanInfo: Codable {
    let internetSpeed: String?
    let productName : String?
    let id: String?
    let zuoraPrice : Float?
    let extendedAmount: Float?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case extendedAmount = "Zuora__ExtendedAmount__c"
        case zuoraPrice = "Zuora__Price__c"
        case internetSpeed = "InternetSpeed__c"
        case productName = "Zuora__ProductName__c"
    }
}

struct FiberPlanInfoResponse: Codable {
    let records: [FiberPlanInfo]
}
