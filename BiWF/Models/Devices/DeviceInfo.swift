//
//  DeviceInfo.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 19/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit

struct DeviceInfo: Codable {
    let stationMac: String
    let hostname: String?
    let vendorName: String?
    let type: String?
    let lastConnectionDate: String?
    let firstConnectionTime: String?
    let connectedInterface: String?
    let ipAddress: String?
    let blocked: Bool?
    let rssi: Int?
    let txRateKbps: Int?
    let parent: String?
    let rxRateKbps: Int?
    let userDefinedProfile: String?
    let location: String?
    let deviceId: Int?
    let maxSpeed: MaxSpeed?
    let maxMode: MaxMode?
    var macDeviceId: String?
    var networStatus: DeviceNetworStatus = .loading
    var nickName: String?

    
    enum CodingKeys: String, CodingKey {
        case stationMac = "stationMac"
        case hostname = "hostname"
        case vendorName = "vendorName"
        case type = "type"
        case lastConnectionDate = "lastConnectionDate"
        case firstConnectionTime = "firstConnectionTime"
        case connectedInterface = "connectedInterface"
        case ipAddress = "ipAddress"
        case blocked = "blocked"
        case rssi = "rssi"
        case parent = "parent"
        case txRateKbps = "txRateKbps"
        case rxRateKbps = "rxRateKbps"
        case userDefinedProfile = "userDefinedProfile"
        case location = "location"
        case deviceId = "deviceId"
        case maxSpeed = "maxSpeed"
        case maxMode = "maxMode"
        case macDeviceId = "id"
    }

    func strengthStatusImage(isOnline: Bool, withClearBackground: Bool = false) -> UIImage {
        //    -50 - Show full bars image
        //    -50 > value > -75 - Show medium bars
        //    -75 > value > -90 - Show low bars
        var networkStatusImageName = Constants.Device.disconnectedNetworkStrength
        if blocked ?? false {
            networkStatusImageName = ""
        } else if isOnline {
            if connectedInterface == "Ethernet" {
                networkStatusImageName = Constants.Device.onCableNetworkStrength
            } else if networStatus == .paused  {
                networkStatusImageName = Constants.Device.offNetworkStrength
            } else {
                if let rssiValue = self.rssi {
                    switch rssiValue {
                    case -(50)..<0:
                        networkStatusImageName = Constants.Device.onNetworkStrength
                    case (-75)..<(-50):
                        networkStatusImageName = Constants.Device.mediumNetworkStrength
                    case (-90)..<(-75):
                        networkStatusImageName = Constants.Device.lowNetworkStrength
                    default:
                        networkStatusImageName = Constants.Device.disconnectedNetworkStrength
                    }
                }
            }
        }
        networkStatusImageName = withClearBackground ? networkStatusImageName+Constants.Device.withoutBackground : networkStatusImageName
        return (networkStatusImageName == "") ? UIImage() : UIImage(named: networkStatusImageName) ?? UIImage()
    }
    
    func getUniqueNameFrom(name: String, devicesNameArray: [String]) -> String {
           var suffixNumber = 1
           var nameString = name
           while devicesNameArray.contains(nameString) {
               nameString = name+"-\(suffixNumber)"
               suffixNumber+=1
           }
           return nameString
       }
}

struct MaxSpeed: Codable {
    let Band2G: Int?
    let Band5G: Int?
    
    enum CodingKeys: String, CodingKey {
        case Band2G = "Band2G"
        case Band5G = "Band5G"
    }
}

struct MaxMode: Codable {
    let Band2G: String?
    let Band5G: String?
    
    enum CodingKeys: String, CodingKey {
        case Band2G = "Band2G"
        case Band5G = "Band5G"
    }
}

enum DeviceNetworStatus {
    case offline
    case connected
    case paused
    case loading
    case error
}
