
//
//  WelcomeCellViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 03/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
/*
WelcomeCellViewModel to handle welcome note
*/
class WelcomeCellViewModel {
    
    /// Output structure
    struct Output {
        let titleTextDriver: Driver<String>
        let descriptionTextDriver: Driver<String>
        let dismissWelcomeObservable: Observable<Void>
    }
    
    /// Input structure
    struct Input {
        let dismissWelcomeObserver: AnyObserver<Void>
    }
    
    /// Input/Output structure variables
    let output: Output
    let input: Input
    let dismissWelcomeSubject = PublishSubject<Void>()
    

    /// Gets the technician details
    /// - Parameter state : installation state
    ///appointmentType : contains all appointmenttype values
    init(state: InstallationState, appointmentType: AppointmentType) {
        let titleAndDescription = WelcomeCellViewModel.titleAndDescription(by: state, appointmentType: appointmentType)
        
        output = Output(
            titleTextDriver: .just(titleAndDescription.0),
            descriptionTextDriver: .just(titleAndDescription.1),
            dismissWelcomeObservable: dismissWelcomeSubject.asObservable()
        )
        
        input = Input(dismissWelcomeObserver: dismissWelcomeSubject.asObserver())
    }
}
/// WelcomeCellViewModel extension
extension WelcomeCellViewModel {
    
    /// Shows title and description on welcome
    /// - Parameter state : installation stat
    ///appointmentType : contains all appointmenttype values
    static func titleAndDescription(by state: InstallationState, appointmentType: AppointmentType) -> (String, String){
        var title: String
        var description: String
        
        switch state {
        case .scheduled:
            title = "\(Constants.WelcomeTableviewCell.welcomeText)"
            description = appointmentType == .installation ? "\(Constants.WelcomeTableviewCell.InstallationNextStep.scheduledText)" : ""
            
        case .enRoute:
            title = "\(Constants.WelcomeTableviewCell.weAreOnTheWay)"
            description = appointmentType == .installation ? "\(Constants.WelcomeTableviewCell.InstallationNextStep.clearTheArea)" : "\(Constants.WelcomeTableviewCell.ServiceNextStep.clearTheArea)"
            
        case .inProgress:
            title = "\(Constants.WelcomeTableviewCell.workInProgress)"
            description = appointmentType == .installation ? "\(Constants.WelcomeTableviewCell.InstallationNextStep.waitWhileTechnicianInstall)" : "\(Constants.WelcomeTableviewCell.ServiceNextStep.waitWhileTechnicianInstall)"
            
        default:
            title = ""
            description = ""
        }
        
        return (title, description)
    }
}
