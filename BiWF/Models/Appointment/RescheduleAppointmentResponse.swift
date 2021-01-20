//
//  RescheduleAppointmentResponse.swift
//  BiWF
//
//  Created by pooja.q.gupta on 09/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

struct RescheduleAppointmentResponse: Codable {
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
    }
}
