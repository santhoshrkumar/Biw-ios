//
//  AppointmentConfirmationViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 06/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
/*
   AppointmentConfirmationViewModel to show the user whether the appointment has confirmed or not
**/
class AppointmentConfirmationViewModel {
    
    /// Input structure
    struct Input {
        let doneTapObserver: AnyObserver<Void>
        let addAppointmentTapObserver: AnyObserver<Void>
        let viewDashboardTapObserver: AnyObserver<Void>
    }
    
    /// Output structure
    struct Output {
        let technicianWillArriveTextDriver: Driver<String>
        let descriptionTextDriver: Driver<String>
        let addAppointmentTextDriver: Driver<String>
        let viewDashabordTextDriver: Driver<String>
        let viewComplete: Observable<DashboardCoordinator.Event>
    }
    
    /// Subject to add done action
    private let doneTapSubject = PublishSubject<Void>()
    
    /// Subject to add a new appointment
    private let addAppointmentTapSubject = PublishSubject<Void>()
    
    /// Subject to see the appointment on dashboard
    private let viewDashboardTapSubject = PublishSubject<Void>()
    
    /// Input & Output structure variable
    let input: Input
    let output: Output
    
    private let disposeBag = DisposeBag()
    
    /// Initializes a new instance of Arrival time viewmodel
    init(with arrivalTime: ArrivalTime, appointmentType: AppointmentType) {
        input = Input(
            doneTapObserver: doneTapSubject.asObserver(),
            addAppointmentTapObserver: addAppointmentTapSubject.asObserver(),
            viewDashboardTapObserver: viewDashboardTapSubject.asObserver()
        )
        
        let doneEventObservable = doneTapSubject.asObservable().map { _ in
            return DashboardCoordinator.Event.goBackToDashboard
        }
        
        let viewDashboardObservable = viewDashboardTapSubject.asObservable().map { _ in
            return DashboardCoordinator.Event.goBackToDashboard
        }
        
        let viewCompleteObservable = Observable.merge(doneEventObservable,
                                                      viewDashboardObservable)
        let timeSlot = "\(arrivalTime.startTime.toString(withFormat: Constants.DateFormat.hmma)) - \(arrivalTime.endTime.toString(withFormat: Constants.DateFormat.hmma))"
        
        let technicianArrivalText = "\(Constants.AppointmentConfirmation.technicianWillArriveOn) \(arrivalTime.startTime.toString(withFormat: Constants.DateFormat.MMddyy)) \(Constants.AppointmentConfirmation.between) \(timeSlot.lowercased())."
        
        output = Output(technicianWillArriveTextDriver: .just(technicianArrivalText),
                        descriptionTextDriver: .just(appointmentType == .installation ? Constants.AppointmentConfirmation.description : Constants.AppointmentConfirmation.bookAppointmentDescription) ,
                        addAppointmentTextDriver: .just(Constants.AppointmentConfirmation.addAppointmentToCalendar),
                        viewDashabordTextDriver: .just(Constants.AppointmentConfirmation.viewMyDashboard),
                        viewComplete: viewCompleteObservable)
    }
}
