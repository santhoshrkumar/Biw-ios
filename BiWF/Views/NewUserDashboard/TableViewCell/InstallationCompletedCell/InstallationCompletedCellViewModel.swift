//
//  InstallationCompletedCellViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 26/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
/*
InstallationCompletedCellViewModel to handle installation completed status
*/
class InstallationCompletedCellViewModel {
    
    /// Output structure
    struct Output {
        let welcomeTextDriver: Driver<String>
        let descriptionTextDriver: Driver<String>
        let getStartedTextDriver: Driver<String>
        let getStartedObservable: Observable<Void>
        let installationStatusViewModelObservable: Observable<InstallationStatusViewModel>
    }
    
    /// Input structure
    struct Input {
        let getStartedTappedObvserver: AnyObserver<Void>
    }
    
    /// Input/Output structure variable
    let output: Output
    let input: Input
    
    /// Subject to handle get started button tap
    private let getStartedTapSubject = PublishSubject<Void>()
    
    
    /// Initializes a new instance of appointmenttype
    /// - Parameter appointmentType : contains all appointmenttype values
    init(appointmentType: AppointmentType) {
        let status = (appointmentType == .installation) ? Constants.InstallationCompletedCell.installationComplete : Constants.InstallationCompletedCell.serviceComplete
        
        let startButtonText = (appointmentType == .installation) ? Constants.InstallationCompletedCell.getStarted : Constants.InstallationCompletedCell.dismiss
        
        let installationStatusViewModel = InstallationStatusViewModel(with: status,
                                                                      status: "",
                                                                      state: .complete)
        
        let welcomeAndDescriptionText = InstallationCompletedCellViewModel.getWelcomeAndDescriptionText(by: appointmentType)
        
        output = Output(
            welcomeTextDriver: .just(welcomeAndDescriptionText.0),
            descriptionTextDriver: .just(welcomeAndDescriptionText.1),
            getStartedTextDriver: .just(startButtonText),
            getStartedObservable: getStartedTapSubject.asObservable(),
            installationStatusViewModelObservable: Observable.just(installationStatusViewModel))
        
        input = Input(getStartedTappedObvserver: getStartedTapSubject.asObserver())
    }
    
    /// Gives welcome text with description
     /// - Parameter appointmentType : appointmentType for which welcome and description text to be shown
    static func getWelcomeAndDescriptionText(by appointmentType: AppointmentType) -> (String, String) {
        
        var title: String
        var status: String
        
        switch appointmentType {
        case .installation:
            title = Constants.InstallationCompletedCell.youAreAllSet
            status = Constants.InstallationCompletedCell.networkIsReady
            
        case .service:
            title = Constants.InstallationCompletedCell.youAreAllSet
            status = Constants.InstallationCompletedCell.serviceVisitComplete
        }
        
        return (title, status)
    }
}
