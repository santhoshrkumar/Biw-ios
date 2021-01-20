//
//  ScheduleCallbackResponse.swift
//  BiWF
//
//  Created by Amruta Mali on 07/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxDataSources

struct ScheduleCallbackResponse: Codable  {
    
    let status: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
    }
}
