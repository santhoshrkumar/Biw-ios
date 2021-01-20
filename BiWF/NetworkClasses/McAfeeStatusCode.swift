//
//  McAfeeStatusCode.swift
//  BiWF
//
//  Created by Amruta Mali on 24/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

enum McAfeeStatusCode: Int {
    case ok = 0
    case devicesNotProvisioned = 14000
    case invalidInput = 14001
    case invalidToken = 14002
    case notFound = 14003
    case unhandled = 14004
}
