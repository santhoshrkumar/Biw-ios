//
//  TechnicianDetailViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 22/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import MapKit
import RxSwift
import RxCocoa
/*
 TechnicianDetailViewModel to handle technician detail information
 */
class TechnicianDetailViewModel {
    
    /// Variables/Constants
    let name: Driver<String>
    let status: Driver<String>
    let estimatedArrivalTime: Driver<String?>
    
    /// Initializes a new instance of name, status and estimatedArrivalTime
    /// - Parameter name : name of the technitian
    /// status : status of the technitian
    /// estimatedArrivalTime : estimatedArrivalTime of the technitian
    init(with name: String, status: String, estimatedArrivalTime: String?) {
        self.name = .just(name)
        self.status = .just(status)
        self.estimatedArrivalTime = .just(estimatedArrivalTime)
    }
}
