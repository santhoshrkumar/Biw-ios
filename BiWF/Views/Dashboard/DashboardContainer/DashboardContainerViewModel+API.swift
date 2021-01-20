//
//  DashboardContainerViewModel+API.swift
//  BiWF
//
//  Created by pooja.q.gupta on 28/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

/// DashboardContainerViewModel extension
extension DashboardContainerViewModel {
    
    /// Gets the user details
   private func getUserDetails() {
        accountRepository.userDetail
            .subscribe(onNext: { details in
                self.getAccountInformation(forAccountId: details.accountID ?? "")
            }).disposed(by: self.disposeBag)
        accountRepository.getUserDetails()
    }
    
    /// Get the user on the network
    func getUser() {
        let loading = ViewStatus.loading(loadingText: Constants.Common.loading)
        viewStatusSubject.onNext(loading)
        
        accountRepository.userResult
            .subscribe(onNext: { details in
                self.getUserDetails()
            }).disposed(by: self.disposeBag)
        accountRepository.getUser()
    }
    
    /// Gets the account information
    /// - Parameter accountID : account id of the user
    func getAccountInformation(forAccountId accountID: String) {
        accountRepository.accountDetails
            .subscribe(onNext: {[weak self] details in
                ///Get service appointment
                self?.getServiceAppointment(with: details)
            }).disposed(by: self.disposeBag)
        accountRepository.getAccount(forAccountId: accountID)
    }
    
    /// Gets the apointment information
    /// - Parameter accountDetails : details of the user from account
    func getServiceAppointment(with accountDetails: Account) {
        
        self.appointmentRepository.serviceAppointment
            .subscribe(onNext: {[weak self] serviceAppointment in
                self?.viewStatusSubject.onNext(ViewStatus.loaded)
                
                if let currentAppointment = serviceAppointment.records.first {
                    if currentAppointment.getAppointmentType() == .service || currentAppointment.isCloseServiceCompleteCard {
                        self?.dashboardViewModel.currentAppointment = currentAppointment
                        self?.dashboardViewModel.commonDashboardViewModel.accountDetails = accountDetails
                        self?.dashboardViewModel.commonDashboardViewModel.currentAppointment = currentAppointment
                        self?.showDashboardSubject.onNext(())
                        self?.showDashboardSubject.onCompleted()
                    } else {
                        self?.moveToNewUserDashboard(with: accountDetails, appointment: currentAppointment)
                    }
                } else {
                    self?.viewStatusSubject.onNext(ViewStatus.loaded)
                    self?.showDashboardSubject.onNext(())
                    self?.showDashboardSubject.onCompleted()
                }
            }).disposed(by: self.disposeBag)
        appointmentRepository.getServiceAppointment(for: accountDetails.accountId ?? "")
    }
    
    /// Move to new user dashboard
    /// - Parameter accountDetails : details of the user from account
    /// appointment : details of the appointment
    func moveToNewUserDashboard(with accountDetails: Account, appointment: ServiceAppointment) {
        commonDashboardViewModel.accountDetails = accountDetails
        commonDashboardViewModel.currentAppointment = appointment
        //If its a service appointment then show the devices tab else show only dashboard & account tab
        showNewUserDashboardWithDevicesTabSubject.onNext(appointment.getAppointmentType() == .service)
        showNewUserDashboardWithDevicesTabSubject.onCompleted()
    }
    
    /// Gets error if any
    func getError() {
        accountRepository.errorMessageUser
            .subscribe(onNext: {[weak self] error in
                let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                    self?.getUser()
                }
                self?.viewStatusSubject.onNext(error)
            }).disposed(by: self.disposeBag)
        
        accountRepository.errorMessageUserDetail
            .subscribe(onNext: {[weak self] error in
                let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                    self?.getUserDetails()
                }
                self?.viewStatusSubject.onNext(error)
            }).disposed(by: self.disposeBag)
        
        accountRepository.errorMessageAccountDetail
            .subscribe(onNext: {[weak self] error in
                let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                    self?.getUserDetails()
                }
                self?.viewStatusSubject.onNext(error)
            }).disposed(by: self.disposeBag)
        
        appointmentRepository.errorMessage
            .subscribe(onNext: {[weak self] error in
                let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                    self?.getUserDetails()
                }
                self?.viewStatusSubject.onNext(error)
            }).disposed(by: self.disposeBag)
    }
}
