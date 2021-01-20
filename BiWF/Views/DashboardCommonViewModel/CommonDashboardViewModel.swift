
//
//  CommonDashboardViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 27/03/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

/// InstallationState to to show status about installation
enum InstallationState: Int, CaseIterable {
    case scheduled = 1
    case enRoute
    case inProgress
    case complete
    case cancelled
}

/// AppointmentType
enum AppointmentType: Int {
    case installation
    case service
}

/// NewUserDashboardViewModel to handle new user on dashboard
class CommonDashboardViewModel {
    
    /// Input structure
    struct Input {
        let changeAppointmentObserver: AnyObserver<ServiceAppointment>
        let cancelAppointmentObserver: AnyObserver<Void>
        let getStartedTapObserver: AnyObserver<Void>
        let moveToStandardDashboardObserver: AnyObserver<Void>
    }
    
    /// Output structure
    struct Output {
        let viewStatusObservable: Observable<ViewStatus>
        let showCancelAppointmentAlertObservable: Observable<Void>
        let viewComplete: Observable<DashboardCoordinator.Event>
    }
    
    /// Input/Output structure variables
    let input: Input
    let output: Output
    
    /// Subject to view the status
    let viewStatusSubject = PublishSubject<ViewStatus>()
    
    
    /// Subject to handle chamge in appointment
    let changeAppointmentSubject = PublishSubject<ServiceAppointment>()
    
    /// Subject to handle get started button tap
    let getStartedTapSubject = PublishSubject<Void>()
    
    /// Subject to show cancel in appointment
    let showCancelAppointmentAlertSubject = PublishSubject<Void>()
    
    // /// Subject to handle cancel appointment
    private let cancelAppointmentSubject = PublishSubject<Void>()
    
    /// Subject to move to standard dashboard
    private let moveToStandardDashboardSubject = PublishSubject<Void>()
    
    let serviceAppointmentCompleted = PublishSubject<Bool>()

    let disposeBag = DisposeBag()
    
    /// Holds AppointmentRepository with strong reference
    var repository: AppointmentRepository
    
    var currentAppointment: ServiceAppointment? {
        didSet {
            setSections()
        }
    }
    /// Holds Account with strong reference
    var accountDetails: Account?
    
    /// Variables/Constans
    var timer: Timer?
    var sections = BehaviorSubject(value: [TableDataSource]())
    
    /// Initializes a new instance of AppointmentRepository
    /// - Parameter appointmentRepository : to get api values on appointment
    init(with appointmentRespository: AppointmentRepository) {
        
        self.repository = appointmentRespository
        
        input = Input(
            changeAppointmentObserver: changeAppointmentSubject.asObserver(),
            cancelAppointmentObserver: cancelAppointmentSubject.asObserver(),
            getStartedTapObserver: getStartedTapSubject.asObserver(),
            moveToStandardDashboardObserver: moveToStandardDashboardSubject.asObserver()
        )
        
        let changeAppointmentObservable = changeAppointmentSubject.asObservable().map { serviceAppointment in
                return DashboardCoordinator.Event.goToChangeAppointment(serviceAppointment)
        }
        
        let getStartedTapObservable = getStartedTapSubject.asObservable().map { _ in
            return DashboardCoordinator.Event.goToStandardDashboard
        }
        
        let moveToStandardDashboardObservable = moveToStandardDashboardSubject.asObservable().map { _ in
            return DashboardCoordinator.Event.goToStandardDashboard
        }
        
        let viewCompleteObservable = Observable.merge(changeAppointmentObservable,
                                                      getStartedTapObservable,
                                                      moveToStandardDashboardObservable)
        
        output = Output(viewStatusObservable: viewStatusSubject.asObservable(),
                        showCancelAppointmentAlertObservable: showCancelAppointmentAlertSubject.asObservable(),
                        viewComplete: viewCompleteObservable
        )
        
        cancelAppointmentSubject.subscribe(onNext: {[weak self] _ in
            self?.cancelAppointment()
        }).disposed(by: disposeBag)
        
        createSubscription()
        //No need to call the API because we are passing the data from previous page
    }
}

//MARK:- Timer
extension CommonDashboardViewModel {
    
    /// checks for available date and time for an appointment
    func checkForArrivalTimeAndAddTimer() {
        if let appointment = self.currentAppointment {
            if appointment.isCurrentTimeGreaterThanStartTime() {
                addTimer()
            }
        }
    }
    
    /// Adds appointment timer
    func addTimer() {
        //Check if timer is not added then only add the timer
        if self.timer == nil {
            let timer =  Timer.scheduledTimer(withTimeInterval: Constants.NewUserDashboard.serviceAppointmentPollTime, repeats: true) {[weak self] timer in
                guard let self = self else { return }
                self.getServiceAppointment()
                if let appointment = self.currentAppointment, appointment.getState() == .complete || appointment.getState() == .cancelled {
                    //If state is complete or cancelled then invalidate the timer
                    timer.invalidate()
                }
            }
            self.timer = timer
        }
    }
}

