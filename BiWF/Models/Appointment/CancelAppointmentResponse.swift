//
//  CancelAppointmentResponse.swift
//  BiWF
//
//  Created by pooja.q.gupta on 05/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

struct CancelAppointmentResponse: Codable {
    let appointmentNumber: String?
    let appointmentID: String?
    let status: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case appointmentNumber = "ServiceAppointmentNumber"
        case appointmentID = "ServiceAppointmentId"
        case status = "Status"
        case message = "Message"
    }
}
