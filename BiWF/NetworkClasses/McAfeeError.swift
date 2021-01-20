//
//  McAfeeError.swift
//  BiWF
//
//  Created by Amruta Mali on 24/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

enum McAfeeError: String {
    case devicesNotProvisioned = "Your device is not provisioned"
    case invalidInput = "Invalid input"
    case invalidToken = "Invalid token"
    case notFound = "Device not found"
    case unhandled = "Unhandled error"
}
