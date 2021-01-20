//
//  NetworkStatus.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 6/18/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

struct SSIDInfo: Codable {
    let band5G: String?
    let band2G: String?
    let band5gGuest4: String?
    let band2gGuest4: String?
    
    enum CodingKeys: String, CodingKey {
        case band5G = "Band5G"
        case band2G = "Band2G"
        case band5gGuest4 = "Band5G_Guest4"
        case band2gGuest4 = "Band2G_Guest4"
    }
}

struct NetworkStatus: Codable {
    let isOnline: Bool
    let serialNumber: String
    let bssidMap: [String: String]?
    let ssidMap: SSIDInfo
    var isRootApp: Bool
    let isSpeedTestEnable: Bool?
    
    var isModemOnline: Bool {
        return isRootApp && isOnline
    }
    
    enum CodingKeys: String, CodingKey {
        case isOnline = "isAlive"
        case serialNumber = "deviceId"
        case bssidMap = "bssidMap"
        case ssidMap = "ssidMap"
        case isRootApp = "isRootAp"
        case isSpeedTestEnable = "SpeedTestEnable"
    }
}

struct NetworkStatusResponseData: Codable {
    let apInfos: [NetworkStatus]
}

struct NetworkStatusResponse: Codable {
    let data: NetworkStatusResponseData
}
