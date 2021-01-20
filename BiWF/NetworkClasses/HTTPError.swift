//
//  HTTPError.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 6/19/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

enum HTTPError: Error {
    case unauthorized
    case forbidden
    case notFound
    case noData
    case noResponse
    case unknownStatusCode
}
