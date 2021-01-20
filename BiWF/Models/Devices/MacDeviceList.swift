//
//  MacDeviceList.swift
//  BiWF
//
//  Created by Amruta Mali on 25/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

struct MacDeviceList: Codable {
    let devices: [MacDeviceInfo]
    let macAddress: String?
    
    enum CodingKeys: String, CodingKey {
        case devices = "devices"
        case macAddress = "mac_address"
    }
}

struct MacDeviceInfo: Codable {
    let id: String
    let memberId: String?
    
    let os: String?
    let name: String?
    let manufacturer: String?
    let osVersion: String?
    let deviceType: String?
    let cspClientId: String?
    let enforcementType: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case memberId = "member_id"
        case os = "os"
        case name = "name"
        case manufacturer = "manufacturer"
        case osVersion = "os_version"
        case deviceType = "device_type"
        case cspClientId = "csp_client_id"
        case enforcementType = "enforcement_type"
        
    }
}
