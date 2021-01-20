//
//  RestartModem.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 02/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//


import Foundation

struct RestartModem: Codable  {
    
    let code: Int
    let message: String
    let data: Bool
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case data = "data"
    }
}

