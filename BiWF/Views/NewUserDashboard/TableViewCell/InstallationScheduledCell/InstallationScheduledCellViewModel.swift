//
//  InstallationStatusCellViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 31/03/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/*
InstallationScheduledCellViewModel to schedule call for installation
*/
struct InstallationScheduledCellViewModel {
    
    /// Output structure
    struct Output {
        let appointmentDateTextDriver: Driver<String>
        let appointmentTimeTextDriver: Driver<String>
        let changeAppointmentDriver: Driver<String>
        let cancelAppointmentDriver: Driver<String>
        let cancelAppointmentObservable: Observable<Void>
        let changeAppointmentObservable: Observable<Void>
        let installationStatusViewModelObservable: Observable<InstallationStatusViewModel>
    }
    
    /// Input structure
    struct Input {
        let cancelAppointmentObserver: AnyObserver<Void>
        let changeAppointmentObserver: AnyObserver<Void>
    }
    
    private let cancelAppointmentSubject = PublishSubject<Void>()
    private let changeAppointmentSubject = PublishSubject<Void>()
    
    /// Input/Output structure variable
    let output: Output
    let input: Input
    
    /// Initializes a new instance of appointment
    /// - Parameter appointment : contains all service appointment values
    init(appointment: ServiceAppointment) {
        
        let titleAndStatus = InstallationScheduledCellViewModel.getTitleAndStatus(by: appointment.getAppointmentType())
        let installationStatusViewModel = InstallationStatusViewModel(with: titleAndStatus.0,
                                                                      status: titleAndStatus.1,
                                                                      state: .scheduled)
        let appointmentTime = (appointment.getAppointmentTime() == nil) ?
            Constants.ServiceAppointment.noTechnicianAssigned :
        "\(Constants.InstallationScheduledCell.appointmentBetweenText) \(appointment.getAppointmentTime() ?? "")"
        
        output = Output(
            appointmentDateTextDriver: .just(appointment.getInstallationDate()),
            appointmentTimeTextDriver: .just(appointmentTime),
            changeAppointmentDriver: .just(Constants.InstallationScheduledCell.changeAppointment),
            cancelAppointmentDriver: .just(Constants.InstallationScheduledCell.cancel),
            cancelAppointmentObservable: cancelAppointmentSubject.asObservable(),
            changeAppointmentObservable: changeAppointmentSubject.asObservable(),
            installationStatusViewModelObservable: Observable.just(installationStatusViewModel)
        )
        
        input = Input(cancelAppointmentObserver: cancelAppointmentSubject.asObserver(),
                      changeAppointmentObserver: changeAppointmentSubject.asObserver())
    }
    
    /// Gets the title and status
    /// - Parameter appointmentType : contains all appointmenttype values
    static func getTitleAndStatus(by appointmentType: AppointmentType) -> (String, String) {
        var title: String
        var status: String
        
        switch appointmentType {
        case .installation:
            title = Constants.InstallationScheduledCell.welcomeText
            status = Constants.InstallationScheduledCell.scheduledText
            
        default:
            title = Constants.InstallationScheduledCell.serviceVisitStatus
            status = Constants.InstallationScheduledCell.serviceVisitScheduled
        }
        
        return (title, status)
    }
}
