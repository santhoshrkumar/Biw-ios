//
//  BlockUnblockDeviceResponse.swift
//  BiWF
//
//  Created by pooja.q.gupta on 17/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

struct BlockUnblockDeviceResponse: Codable {
    let code: Int
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
    }
}


