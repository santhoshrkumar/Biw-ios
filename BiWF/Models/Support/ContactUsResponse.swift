//
//  ContactUs.swift
//  BiWF
//
//  Created by pooja.q.gupta on 09/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxDataSources

struct ContactUsResponse: Codable {
    let contactUs: ContactUs
}

struct ContactUs: Codable {
    let liveChatTimings: String
    let liveChatWebUrl: String
    let scheduleCallbackTimings: String
    let contactDetails: String
}


/// TODO: to be removed once data get load from API
extension ContactUsResponse {
    static func loadFromJson() -> ContactUs? {
        guard let path = Bundle.main.path(forResource: "contactUsResponse",
                                          ofType: "json") else { return nil }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path),
                                options: .mappedIfSafe)
            let response = try JSONDecoder().decode(ContactUsResponse.self, from: data)
            return response.contactUs
        } catch {
            return nil
        }
    }
}

