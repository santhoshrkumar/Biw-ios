//
//  PauseResumeResponse.swift
//  BiWF
//
//  Created by Amruta Mali on 28/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

struct PauseResumeResponse: Codable {
    let code: String
    let message: String?
    let macDeviceList: [MacDeviceList]?
    let isPaused: Bool?
    let deviceInfoList: [MacDeviceInfo]?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case macDeviceList = "mac_device_list"
        case isPaused = "blocked"
        case deviceInfoList = "devices"
    }
}
