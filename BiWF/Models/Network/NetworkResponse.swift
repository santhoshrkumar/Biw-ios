//
//  NetworkResponse.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 17/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
/// Encode NetworkResponse
struct NetworkResponse: Codable {
    let code: Int
    let message: String?
    let data: Bool?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case data = "data"
    }
}

/// Encode NetworkEnableDisableResponse
struct NetworkEnableDisableResponse: Codable {
    let code: String
    let message: String?
    let data: Bool?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case data = "data"
    }
}

/// Encode NetworkPasswordResponse
struct NetworkPasswordResponse: Codable {
    let code: Int
    let message: String?
    let data: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case data = "data"
    }
}
