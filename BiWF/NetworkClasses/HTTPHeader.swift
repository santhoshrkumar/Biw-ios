//
//  HTTPHeader.swift
//  BiWF
//
//  Created by pooja.q.gupta on 29/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
/**
 Class consists of header key "string" for APIs
 */
enum HTTPHeader: String {
    case authorization = "Authorization"
    case assiaID = "assiaID"
    case assiaIdSmall = "assiaId"
    case assiaIdTraffic = "assiaIdTraffic"
    case staMac = "staMac"
    case staMacTraffic = "staMacTraffic"
    case startDate = "startDate"
    case startDateTraffic = "startDateTraffic"
    case endDate = "endDate"
    case pastXHours = "pastXHours"
    case requestId = "requestId"
    case rtFlagBroadBandSpeed = "rtFlagBroadBandSpeed"
    case stationMac = "stationMacAddress"
    case genericId = "genericId"
    case wifiDeviceId = "wifiDeviceId"
    case interface = "interface"
    case newPassword = "newPassword"
    case newSsid = "newSsid"
    case from = "From"
    case lineId = "lineId"
    case forcePing = "forcePing"
    case mobile = "mobile"
    case callBackUrl = "callBackUrl"
}
