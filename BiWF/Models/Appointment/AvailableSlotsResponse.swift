//
//  AvailableSlotsResponse.swift
//  BiWF
//
//  Created by pooja.q.gupta on 01/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

struct AvailableSlotsResponse: Codable {
    let slotsValue: Dictionary<String, [String]>?
    let appointmentId: String?
    
    enum CodingKeys: String, CodingKey {
        case slotsValue = "slotsValue"
        case appointmentId = "ServiceAppointmentId"
    }
}

struct Slot {
    var value: String?
    var index: Int
    var isSelected: Bool = false
}
