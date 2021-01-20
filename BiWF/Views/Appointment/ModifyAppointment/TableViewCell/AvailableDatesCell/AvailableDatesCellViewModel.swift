//
//  AvailableDatesCellViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 04/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
/*
  AvailableDatesCellViewModel to see the available date to book an Appointment
*/
class AvailableDatesCellViewModel {
    
    /// Output structure
    struct Output {
        let selectDayDriver: Driver<String>
        let instructionsDriver: Driver<String>
        let selectedDateObservable: Observable<Date>
        let calendarViewModelObservable: Observable<CalendarViewModel>
    }
    
    /// Input structure
    struct Input {
    }
    
    /// Subject to handle selected date
    private let selectedDateSubject = PublishSubject<Date>()
    
    /// Input & Output structure variable
    let output: Output
    let input: Input
    
    let disposeBag = DisposeBag()
    
    /// Initialize a new instance of available slots
    /// - Parameter available slot: dict with list of available time slots to book an appointment, with key as date and time as slots in array
    init(with availableSlots: Dictionary<String, [String]>, appointmentType: AppointmentType) {
        
        let calendarViewModel = CalendarViewModel(with: Array(availableSlots.keys))
        
        output = Output(selectDayDriver: .just(Constants.AvailableDatesTableViewCell.selectDayAndTime),
                        instructionsDriver: .just(appointmentType == .service ? "" : Constants.AvailableDatesTableViewCell.modifyAppointmentInstructions),
                        selectedDateObservable: selectedDateSubject.asObservable(),
                        calendarViewModelObservable: .just(calendarViewModel))
        
        input = Input()
        
        calendarViewModel.output.selectedDateObservable.subscribe(onNext: {[weak self] date in
            self?.selectedDateSubject.onNext(date)
        }).disposed(by: disposeBag)
    }
}

