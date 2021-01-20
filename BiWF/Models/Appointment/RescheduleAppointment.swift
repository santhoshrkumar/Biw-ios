//
//  RescheduleAppointment.swift
//  BiWF
//
//  Created by pooja.q.gupta on 08/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

struct RescheduleAppointment: Codable {
    let serviceAppointmentID: String?
    let arrivalWindowStartTime: String?
    let ArrivalWindowEndTime: String?
    
    enum CodingKeys: String, CodingKey {
        case serviceAppointmentID = "ServiceAppointmentId"
        case arrivalWindowStartTime = "ArrivalWindowStartTime"
        case ArrivalWindowEndTime = "ArrivalWindowEndTime"
    }
}


