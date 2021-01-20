//
//  WiFiNetwork.swift
//  BiWF
//
//  Created by pooja.q.gupta on 30/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

struct WiFiNetwork {
    var name: String
    var password: String
    var isGuestNetwork: Bool
    var isEnabled: Bool = false
    var nameState: ViewState = .normal("")
    var passwordState: ViewState = .normal(Constants.NetworkInfo.networkPasswordDescription)

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case password = "password"
        case isGuestNetwork = "isGuestNetwork"
        case isEnabled = "isEnabled"
    }
    
    func qrCodeGeneratorString() -> String {
        return "WIFI:T:WPA;S:\(name);P:\(password);;"
    }
}
