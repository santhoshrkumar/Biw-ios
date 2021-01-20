//
//  MapViewModel.swift
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
 MapViewModel to handle google map information
 */
class MapViewModel {
    let location: Driver<CLLocationCoordinate2D>
    
    /// Initializes a new instance of location
    /// - Parameter location : to get the user location
    init(with location: CLLocationCoordinate2D) {
        self.location = .just(location)
    }
}
