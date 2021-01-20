//
//  AppointmentCancelledCellViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 07/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
/*
AppointmentCancelledCellViewModel to handle cancelled appointment
*/
class AppointmentCancelledCellViewModel {
    
    /// Output structure
    struct Output {
        let descriptionTextDriver: Driver<String>
        let installationStatusViewModelObservable: Observable<InstallationStatusViewModel>
    }
    
    /// Output structure variable
    let output: Output
    
    /// Initializes a new instance of appointment
    /// - Parameter appointment : contains all service appointment values
    init(appointment: ServiceAppointment) {
        let installationStatusViewModel = InstallationStatusViewModel(with: Constants.AppointmentCancelledCell.fiberInstallationStatus,
                                                                      status: Constants.AppointmentCancelledCell.installationCancelled,
                                                                      state: .cancelled)
        
        output = Output(descriptionTextDriver: .just("\(Constants.AppointmentCancelledCell.madeAMistake) \(Constants.Common.biwfServiceNumber)."),
                        installationStatusViewModelObservable: .just(installationStatusViewModel))
    }
}
