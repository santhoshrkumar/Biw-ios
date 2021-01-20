//
//  DeviceList.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 19/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

struct DeviceList: Codable {
    var deviceList: [DeviceInfo]?
    
    enum CodingKeys: String, CodingKey {
        case deviceList = "data"
    }
    
    func getMacAddressList() -> [String]? {
        guard let list = self.deviceList else { return nil }
        let macAddressList: [String] = list.compactMap { $0.stationMac.replacingOccurrences(of: ":", with: "-") }
        return macAddressList
    }
    
    func getDeviceListWithMacDeviceId(_ macAddresslist: [MacDeviceList]) -> DeviceList {
        var finalDeviceList: DeviceList = DeviceList()
        finalDeviceList.deviceList = [DeviceInfo]()
        if let list = self.deviceList {
            for item in list {
                if let macDeviceList = macAddresslist.first(where: { $0.macAddress?.replacingOccurrences(of: "-", with: ":") == item.stationMac }) {
                    var device = item
                    device.macDeviceId = macDeviceList.devices.first?.id ?? ""
                    finalDeviceList.deviceList?.append(device)
                } else {
                    finalDeviceList.deviceList?.append(item)
                }
            }
        }
        return finalDeviceList.deviceList?.count == 0 ? self : finalDeviceList
    }

    func getMacDeviceWithNameInfoList(_ deviceInfoList: [MacDeviceInfo]) -> DeviceList {
        var finalDeviceList: DeviceList = DeviceList()
        finalDeviceList.deviceList = [DeviceInfo]()
        if let list = self.deviceList {
            for item in list {
                if let deviceInfo = deviceInfoList.first(where: {$0.id == item.macDeviceId }){
                    var device = item
                    device.nickName = deviceInfo.name ?? ""
                    finalDeviceList.deviceList?.append(device)
                } else {
                    finalDeviceList.deviceList?.append(item)
                }
            }
        }
        return finalDeviceList.deviceList?.count == 0 ? self : finalDeviceList
    }

}

