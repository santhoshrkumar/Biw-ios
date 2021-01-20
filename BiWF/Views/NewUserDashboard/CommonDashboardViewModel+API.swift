//
//  NewUserDashboardViewModel+API.swift
//  BiWF
//
//  Created by pooja.q.gupta on 26/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
/*
NewUserDashboardViewModel to handle new user dashboard
*/
extension CommonDashboardViewModel {
    
    /// Creates the subscription
    func createSubscription() {
        
        repository.serviceAppointment
            .subscribe(onNext: {[weak self] serviceAppointment in
                guard let self = self else {return}
                
                self.viewStatusSubject.onNext(ViewStatus.loaded)
                
                if serviceAppointment.records.count > 0 {
                    self.currentAppointment = serviceAppointment.records[0]
                }
            }).disposed(by: self.disposeBag)
    }
    
    /// Gets the service appointment
    func getServiceAppointment() {
        if let accountDetails = self.accountDetails {
            self.repository.getServiceAppointment(for: accountDetails.accountId ?? "")
        }
    }
    
    /// Handles the cancellation appointment
    func cancelAppointment() {
        
        let loading = ViewStatus.loading(loadingText: Constants.Common.cancelling)
        viewStatusSubject.onNext(loading)
        
        if let currentAppointment = currentAppointment {
            repository.cancelAppointment(currentAppointment)
                .subscribe(onNext: {[weak self] status, error in
                    guard let self = self else { return }
                    if let status = status, status == true {
                        // Appointment cancelled successfully
                        self.getServiceAppointment()
                    }
                    
                    if let errorMsg = error {
                        let error = ViewStatus.error(errorMsg: "\(errorMsg.count == 0 ? Constants.Common.errorLoadingInformation : errorMsg)\n \(Constants.Common.pleaseTryAgain)") {
                        }
                        self.viewStatusSubject.onNext(error)
                    }
                    
                }).disposed(by: self.disposeBag)
        }
        
    }
}

