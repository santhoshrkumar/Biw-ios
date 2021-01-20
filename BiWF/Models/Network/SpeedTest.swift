//
//  TroubleShooting.swift
//  BiWF
//
//  Created by pooja.q.gupta on 09/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

/// Encode run speed test initial response
struct RunSpeedTestResponse: Codable {
    let requestId: String?
    let status: String?
    let uniqueErrorCode: Int?
    let callBackUrl: String?
    let success: Bool
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case requestId = "requestId"
        case status = "status"
        case uniqueErrorCode = "uniqueErrorCode"
        case callBackUrl = "callBackUrl"
        case success = "success"
        case message = "message"
    }
}

/// Encode run speed test status response after initialisation
struct SpeedTestStatusResponse: Codable {
    let status: String?
    let message: String?
    let uniqueErrorCode: Int?
    let requestId: String?
    let callBackUrl: String?
    let statusResponse: SpeedTestStatus?
    let downloadSpeedSummary: DownloadSpeedSummary?
    let uploadSpeedSummary: UploadSpeedSummary?
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case uniqueErrorCode = "uniqueErrorCode"
        case requestId = "requestId"
        case callBackUrl = "callBackUrl"
        case downloadSpeedSummary = "downloadSpeedSummary"
        case uploadSpeedSummary = "uploadSpeedSummary"
        case statusResponse = "statusResponse"
        case success = "success"
    }
}

/// Speed test status
struct SpeedTestStatus: Codable {
    let code: Int?
    let message: String?
    let data: SpeedTestResponseData?
}

/// Encode speed test response data
struct SpeedTestResponseData: Codable {
    let currentStep: String?
    let finished: Bool
}

/// Encode download speed test summary
struct DownloadSpeedSummary: Codable {
    let code: Int?
    let message: String?
    let downloadData: DownloadSpeedDataList?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case downloadData = "data"
    }
}

/// Encode download speed test summary list
struct DownloadSpeedDataList: Codable {
    let list: [DownloadSpeedData]?
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}

/// Encode download speed test data
struct DownloadSpeedData: Codable {
    let average: Int?
    let std: Double?
    let detection: Int?
    let numErrorFreeSamples: Int?
    let sampleMaxPercentile: Int?
    let latestSampleTimestamp: Int?
    let sampleMax: Int?
    let videoQuality: Int?
    let serviceDetection: Int?
    let percentile: [Int]?
    let latestSample: Int?
    let primaryIp: String?
    let timestamp: String?
    
    enum CodingKeys: String, CodingKey {
        case average = "average"
        case std = "std"
        case detection = "detection"
        case numErrorFreeSamples = "numErrorFreeSamples"
        case sampleMaxPercentile = "sampleMaxPercentile"
        case latestSampleTimestamp = "latestSampleTimestamp"
        case sampleMax = "sampleMax"
        case videoQuality = "videoQuality"
        case serviceDetection = "serviceDetection"
        case percentile = "percentile"
        case latestSample = "latestSample"
        case primaryIp = "primaryIp"
        case timestamp = "timestamp"
    }
}

/// Encode upload speed test summary
struct UploadSpeedSummary: Codable {
    let code: Int?
    let message: String?
    let uploadData: UploadSpeedDataList?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case uploadData = "data"
    }
}

/// Encode upload speed test summary list
struct UploadSpeedDataList: Codable {
    let list: [UploadSpeedData]?
    
    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}

/// Encode Upload speed test data
struct UploadSpeedData: Codable {
    let average: Int?
    let std: Double?
    let detection: Int?
    let numErrorFreeSamples: Int?
    let sampleMaxPercentile: Int?
    let latestSampleTimestamp: Int?
    let sampleMax: Int?
    let videoQuality: Int?
    let serviceDetection: Int?
    let percentile: [Int]?
    let latestSample: Int?
    let primaryIp: String?
    let timestamp: String?
    
    enum CodingKeys: String, CodingKey {
        case average = "average"
        case std = "std"
        case detection = "detection"
        case numErrorFreeSamples = "numErrorFreeSamples"
        case sampleMaxPercentile = "sampleMaxPercentile"
        case latestSampleTimestamp = "latestSampleTimestamp"
        case sampleMax = "sampleMax"
        case videoQuality = "videoQuality"
        case serviceDetection = "serviceDetection"
        case percentile = "percentile"
        case latestSample = "latestSample"
        case primaryIp = "primaryIp"
        case timestamp = "timestamp"
    }
}

/// Entity represents speed test UI elements value on support and dashboard screen
struct SpeedTest: Codable {
    let uploadSpeed: String
    let downloadSpeed: String
    let timeStamp: String
    var formattedTime: String {
        return timeStamp.formattedDateFromString(
            dateString: timeStamp,
            inFormat: Constants.DateFormat.yyyyMMddT,
            withFormat: Constants.DateFormat.MMddyyyy_at_hmma
        )
        ?? "- -"
    }
}

