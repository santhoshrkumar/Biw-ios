//
//  InRouteCellViewModel.swift
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
InRouteCellViewModel to handle the in route appointment status
*/
class InRouteCellViewModel {
    
    /// Output structure
    struct Output {
        let installationStatusViewModelObservable: Observable<InstallationStatusViewModel>
        let mapViewModelObservable: Observable<MapViewModel>
        let technicianDetailViewModelObservable: Observable<TechnicianDetailViewModel>
    }
    
    /// Output structure variable
    let output: Output
    
    /// Initializes a new instance of appointment
    /// - Parameter appointment : contains all service appointment values
    init(appointment: ServiceAppointment) {
        
        let state = appointment.getState()
        let titleAndStatus = InRouteCellViewModel.getTitleAndStatus(by: appointment.getAppointmentType(), state: state)
        
        let installationStatusViewModel = InstallationStatusViewModel(with: titleAndStatus.0,
                                                                           status: titleAndStatus.1,
                                                                           state: state)
        let mapViewModel = MapViewModel(with: CLLocationCoordinate2D(latitude: appointment.latitude ?? 0,
                                                                               longitude: appointment.longitude ?? 0))
        let technicianDetailViewModel = InRouteCellViewModel.getTechnicianDetail(by: appointment, state: state)
        
        output = Output(
            
            installationStatusViewModelObservable: Observable.just(installationStatusViewModel),
            mapViewModelObservable: Observable.just(mapViewModel),
            technicianDetailViewModelObservable: Observable.just(technicianDetailViewModel)
        )
    }
    
    /// Gets the title and status of appointment type
    /// - Parameter appointmenttype : type of the appointment service or install
    /// state : installation state
    static func getTitleAndStatus(by appointmentType: AppointmentType, state: InstallationState) -> (String, String) {
        
        var title: String
        var status: String
        
        switch appointmentType {
        case .installation:
            title = Constants.InRouteCell.installationStatus
            status = (state == .enRoute) ? Constants.InRouteCell.technicianOnTheWay : Constants.InProgressCell.installationUnderway
            
        case .service:
            title = Constants.InRouteCell.serviceVisitStatus
            status = (state == .enRoute) ? Constants.InRouteCell.technicianOnTheWay : Constants.InProgressCell.serviceUnderway
        }
        return (title, status)
    }
    
    /// Gets the technician details
    /// - Parameter appointment: for the service appointment
    /// state : installation stat
    static func getTechnicianDetail(by appointment: ServiceAppointment, state: InstallationState) -> TechnicianDetailViewModel {
        var technicianName: String
        var arrivalTime: String
        var status: String
        
        if let technicianFirstName = appointment.getTechnicianName() {
            technicianName = technicianFirstName
            switch state {
            case .enRoute:
                arrivalTime = appointment.getEstimatedArrivalTime()
                status = Constants.InRouteCell.estimatedArrivalWindow
                
            default:
                arrivalTime = ""
                status = Constants.InProgressCell.isSettingNetwork
            }
        } else {
            // No technician has been assigned
            technicianName = Constants.ServiceAppointment.noTechnicianAssigned
            arrivalTime = ""
            status = ""
        }
        
        return TechnicianDetailViewModel(with: technicianName, status: status, estimatedArrivalTime: arrivalTime)
    }
}


