//
//  UsageDetails.swift
//  BiWF
//
//  Created by pooja.q.gupta on 18/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

struct UsageDetails: Codable {
    let downLinkTraffic: Double?
    let upLinkTraffic: Double?
    let interface: String?
    
    enum CodingKeys: String, CodingKey {
        case downLinkTraffic = "downLinkTraffic"
        case upLinkTraffic = "upLinkTraffic"
        case interface = "intf"
    }
}

struct UsageDetailsList: Codable {
    let list: [UsageDetails]?
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
    
    func getUploadUsage() -> DataUsage {
        guard  let usageList = self.list, usageList.count != 0 else {
            return DataUsage(value: "--", unit: Constants.Common.mb)
        }
        let totalUpload = usageList.map({($0.upLinkTraffic ?? 0)}).reduce(0.0, +)
        return totalUpload.getUsageAndUnit()
    }
    
    func getDownloadUsage() -> DataUsage {
        guard  let usageList = self.list, usageList.count != 0 else {
            return DataUsage(value: "--", unit: Constants.Common.mb)
        }
        let totalDownload = usageList.map({($0.downLinkTraffic ?? 0)}).reduce(0.0, +)
        return totalDownload.getUsageAndUnit()
    }
}

struct UsageDetailsResponse: Codable {
    let message: String
    let data: UsageDetailsList
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case data = "data"
    }
}

struct DataUsage {
    let value: String
    let unit: String
}
