//
//  CalendarViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 01/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
/*
CalendarViewModel to handle calendar information
*/
class CalendarViewModel {
    
    /// Input structure
    struct Input {
        let selectedDateObserver: AnyObserver<Date>
    }
    
    /// Output structure
    struct Output {
        let selectedDateObservable: Observable<Date>
        let availableDatesDriver: Driver<[String]>
    }
    
    /// Subject to handle date selection
    private let selectedDateSubject = PublishSubject<Date>()
    
    /// Input/Output structure variables
    let input: Input
    let output: Output
    
    /// Initializes a new instance of WiFiNetwork
    /// - Parameter availableDates : date available
    init(with availableDates: [String]) {
        input = Input(selectedDateObserver: selectedDateSubject.asObserver())
        
        output = Output(selectedDateObservable: selectedDateSubject.asObservable(),
                        availableDatesDriver: .just(availableDates))
    }
}
