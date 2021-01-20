//
//  HTTPStatusCode.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 6/19/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

enum HTTPStatusCode: Int {
    case ok = 200
    case cancellationSuccess = 201
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case success = 204
    case invalid = 400
    case oldData = 500
    enum Assia: Int {
        case success = 1000
    }
}
