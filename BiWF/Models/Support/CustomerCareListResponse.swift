//
//  CustomerCareListResponse.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 19/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxDataSources

struct CustomerCareListResponse: Codable  {
    
    let controllerValues: [String: String]?
    let defaultValue: String?
    let eTag: String?
    let url: String?
    let values: [CustomerCarevalues]?

    enum CodingKeys: String, CodingKey {
        case controllerValues = "controllerValues"
        case defaultValue = "defaultValue"
        case eTag = "eTag"
        case url = "url"
        case values = "values"
    }
}

struct CustomerCarevalues: Codable  {
    
    let attributes: String?
    let label: String?
    let validFor: [String]?
    let value: String?
    
    enum CodingKeys: String, CodingKey {
        case attributes = "attributes"
        case label = "label"
        case validFor = "validFor"
        case value = "value"
    }
}
