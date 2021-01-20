//
//  AccountViewModel+API.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 11/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
/*
 AccountViewModel extension to select the sections/cells
 */
extension AccountViewModel {
    
    /// used to get the perticular sections
    func setSections() {
        sections.onNext(getSections())
    }
    
    /// Getting all the API values with respect to accounts from the repository
    func subscribeResponses() {
        repository.userDetail
            .subscribe(onNext: { details in
                self.userDetails = details
                self.getAccountInformation(forAccountId: self.userDetails?.accountID ?? "")
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.userDetailsSuccess)
            }).disposed(by: self.disposeBag)
        
        repository.userResult
            .subscribe(onNext: { details in
                self.getUserDetails()
            }).disposed(by: self.disposeBag)
        
        repository.accountDetails
            .subscribe(onNext: { details in
                self.account = details
                self.account?.email = self.userDetails?.email
                self.getContactInformation(forContactId: self.userDetails?.contactID ?? "")
                self.getPaymentInformation(forAccountId: self.account?.accountId ?? "")
                self.getFiberPlanInformation(forAccountId: self.account?.accountId ?? "")
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.accountDetailsSuccess)
            }).disposed(by: self.disposeBag)
        
        repository.contactDetails
            .subscribe(onNext: { details in
                self.viewStatusSubject.onNext(ViewStatus.loaded)
                self.contact = details
                self.setSections()
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.contactDetailsSuccess)
            }).disposed(by: self.disposeBag)
        
        subscriptionRepository.paymentInfo
            .subscribe(onNext: { [weak self] paymentInfo in
                guard let self = self else { return }
                self.paymentInfo = paymentInfo
                self.paymentInfo?.nextRenewalDate = self.account?.nextPaymentDate
                self.setSections()
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.paymentInfoSuccess)
            }).disposed(by: self.disposeBag)
        
        subscriptionRepository.fiberPlanInfo
            .subscribe(onNext: { [weak self] fiberPlanInfo in
                guard let self = self else { return }
                self.fiberPlanInfo = fiberPlanInfo
                self.setSections()
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.fiberPlanInfoSuccess)
            }).disposed(by: self.disposeBag)
    
        subscriptionRepository.errorMessageFiberPlanInfo
            .subscribe(onNext: { [weak self] error in
                let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                    self?.updateFiberPlanInfo()
                }
                self?.isErrorState = true
                self?.viewStatusSubject.onNext(error)
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.fiberPlanInfoFailure)
            }).disposed(by: self.disposeBag)

        repository.errorMessageUserDetail
            .subscribe(onNext: {[weak self] error in
                let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                    self?.getUserDetails()
                }
                self?.isErrorState = true
                self?.viewStatusSubject.onNext(error)
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.userDetailsFailure)
            }).disposed(by: self.disposeBag)
        
        repository.errorMessageUser
            .subscribe(onNext: {[weak self] error in
                let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                    self?.getUser()
                }
                self?.isErrorState = true
                self?.viewStatusSubject.onNext(error)
            }).disposed(by: self.disposeBag)
        
        repository.logoutUserResponse
            .subscribe(onNext: { [weak self] isSuccess in
                guard let self = self else { return }
                self.viewStatusSubject.onNext(ViewStatus.loaded)
                if isSuccess {
                    self.logoutSuccessSubject.onNext(())
                } else {
                    self.showAlert(withMessage: Constants.Biometric.unknownError)
                }
            }).disposed(by: self.disposeBag)
            
        repository.errorMessageLogoutUser
            .subscribe(onNext: {[weak self] error in
                self?.showAlert(withMessage: Constants.Biometric.unknownError)
                self?.viewStatusSubject.onNext(ViewStatus.loaded)
            }).disposed(by: self.disposeBag)
        
        repository.errorMessageAccountDetail
            .subscribe(onNext: {[weak self] error in
                let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                    guard let userDetails = self?.userDetails else { return }
                    self?.getAccountInformation(forAccountId: userDetails.accountID ?? "")
                }
                self?.isErrorState = true
                self?.viewStatusSubject.onNext(error)
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.accountDetailsFailure)
            }).disposed(by: self.disposeBag)
        
        repository.errorMessageContactDetail
            .subscribe(onNext: {[weak self] error in
                let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                    guard let userDetails = self?.userDetails else { return }
                    self?.getContactInformation(forContactId: userDetails.contactID ?? "")
                }
                self?.isErrorState = true
                self?.viewStatusSubject.onNext(error)
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.contactDetailsFailure)
            }).disposed(by: self.disposeBag)
        
        subscriptionRepository.errorMessagePaymentInfo
            .subscribe(onNext: { _ in
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.paymentInfoFailure)
            }).disposed(by: self.disposeBag)
        
        repository.contactPhoneNumberUpdate
            .subscribe(onNext: { success in
                if success {
                    self.updatePhoneNumber = nil
                    guard let userDetails = self.userDetails else { return }
                    self.getAccountInformation(forAccountId: userDetails.accountID ?? "")
                    AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.updateContactDetailsSuccess)
                } else {
                    AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.updateContactDetailsFailure)
                }
            }).disposed(by: self.disposeBag)
    }
    
    /// Gtting the perticular user details from repository
   private func getUserDetails() {
        repository.getUserDetails()
    }
    
    /// used to get the user who entering the userinfo
    func getUser() {
        let loading = ViewStatus.loading(loadingText: Constants.Common.loading)
        viewStatusSubject.onNext(loading)
        repository.getUser()
    }
    
    /// Getting the perticular logging out user
    func getLogoutUser() {
        repository.logoutUser()
    }
    
    /// Update the Fiber Internet info for a specific Account ID
    func updateFiberPlanInfo() {
        subscriptionRepository.getFiberPlanInfo(forAccountId: self.account?.accountId ?? "")
    }
    
    /// Get the perticular sections on account view controller
    /// returns the data on tableview
    private func getSections() -> [TableDataSource] {
        guard let account = self.account, let paymentInfo = paymentInfo, let fiberPlanInfo = fiberPlanInfo else { return [TableDataSource]() }
        return [TableDataSource(header: AccountOwnerDetailsCell.identifier,
                                items: [createAccountOwnerDetailItem(withAccountInformation: account),
                                        createPaymentInfoItem(withAccountInformation: account, andPaymentInformation: paymentInfo, andFiberPlanInformation: fiberPlanInfo),
                                        createPersonalItem(withAccountInformation: account),
                                        createPrefrenceSettingsItem(withAccountInformation: account),
                                        createLogoutItem()])]
    }
    
    /// Creating the setting and preferences for an account
    /// - Parameter Account: contains all the values of Account
    /// returns a sngle item
    private func createPrefrenceSettingsItem(withAccountInformation accountInformation: Account) -> Item {
        let cellViewModel = PreferenceAndSettingsCell.ViewModel(withAccountInformation: accountInformation)
        return Item(identifier: PreferenceAndSettingsCell.identifier,
                    viewModel: cellViewModel,
                    object: accountInformation)
    }
    
    /// Creating account owner details
    /// - Parameter Account: contains all the values of Account
    /// returns a sngle item
    private func createAccountOwnerDetailItem(withAccountInformation accountInformation: Account) -> Item {
        let cellViewModel = AccountOwnerDetailsCell.ViewModel(withAccountInfo: accountInformation)
        return Item(identifier: AccountOwnerDetailsCell.identifier,
                    viewModel: cellViewModel,
                    object: accountInformation)
    }
    
    /// Creating payment info
    /// - Parameter Account: contains all the values of Account
    /// PaymentInfo : contains all the payment info values
    /// returns a sngle item
    private func createPaymentInfoItem(withAccountInformation accountInformation: Account, andPaymentInformation paymentInfo: PaymentInfo, andFiberPlanInformation fiberPlanInfo:FiberPlanInfo) -> Item {
        let cellViewModel = PaymentInfoCell.ViewModel(withAccountInfo: accountInformation, andPaymentInfo: paymentInfo, andFiberPlanInformation:fiberPlanInfo)
        return Item(identifier: PaymentInfoCell.identifier,
                    viewModel: cellViewModel,
                    object: accountInformation)
    }
    
    /// creating personal item
    /// - Parameter Account: contains all the values of Account
    /// returns a sngle item
    private func createPersonalItem(withAccountInformation accountInformation: Account) -> Item {
        let cellViewModel = PersonalInfoCell.ViewModel(withPersonalInfo: accountInformation)
        return Item(identifier: PersonalInfoCell.identifier,
                    viewModel: cellViewModel,
                    object: accountInformation)
    }
    
    ///logout item for perticular account
    private func createLogoutItem() -> Item {
        let cellViewModel = LogoutCellViewModel()
        cellViewModel.output.logoutEventObservable
            .bind(to: logoutSubject.asObserver())
            .disposed(by: disposeBag)
        return Item(identifier: LogoutCell.identifier,
                    viewModel: cellViewModel,
                    object: nil)
    }
    
    /// selecting the sections wirh respect to index value of tableview
    /// - Parameter : Indexpath of the tableview
    func openNext(indexPath: IndexPath) {
        guard let allSections = try? sections.value(), let accountInformation = allSections[indexPath.section].items[indexPath.row].object as? Account
            else { return }
        if indexPath.row == CardType.subscription.rawValue {
            if var account = self.account, let paymentInfo = self.paymentInfo, let fiberPlanInfo = self.fiberPlanInfo {
                account.contactId = self.contact?.contactId
                openSubscriptionSubject.onNext(Subscription(account: account, paymentInfo: paymentInfo, fiberPlanInfo: fiberPlanInfo))
                AnalyticsEvents.trackCradViewTappedEvent(with: AnalyticsConstants.EventCardViewName.subscriptionInfo)
            }
            
        } else if indexPath.row == CardType.personalInfo.rawValue {
            openPersonalInfoSubject.onNext(accountInformation)
            AnalyticsEvents.trackCradViewTappedEvent(with: AnalyticsConstants.EventCardViewName.personalInfo)
        }
    }
    
    /// updating the values of the toggle sections
    /// - Parameter ToggleType : toggle types on the account view controller
    /// toggle : checks whether the selected toggle type is enabled/disabled
    func updateValues(toggle: Bool, toggleType: ToggleType) {
        switch toggleType {
        case .faceID:
            if toggle {
                Biometrics.checkBiometricAuthentication()
            } else {
                Biometrics.disableBiometric()
                setSections()
            }
            AnalyticsEvents.trackBiometricEvent(with: toggle)
            
        case .serviceCall:
            self.account?.cellPhoneOptIn = toggle
            self.switchResponse.subscribe(onNext: { success in
                /// No handling is required for now
            }).disposed(by: self.disposeBag)
            updateSettingsPreferences(updateBoth: false)
            AnalyticsEvents.trackToggleButtonChangeEvent(with: AnalyticsConstants.EventToggleButton.Name.serviceCalls, value: toggle)
            
        case .marketingEmail:
            self.account?.marketingEmailOptIn = toggle
            self.switchResponse.subscribe(onNext: { success in
                /// No handling is required for now
            }).disposed(by: self.disposeBag)
            updateSettingsPreferences(updateBoth: false)
            AnalyticsEvents.trackToggleButtonChangeEvent(with: AnalyticsConstants.EventToggleButton.Name.marketingEmails, value: toggle)
            
        case .marketingCall:
            self.account?.marketingCallOptIn = toggle
            self.switchResponse.subscribe(onNext: { success in
                /// No handling is required for now
            }).disposed(by: self.disposeBag)
            updateSettingsPreferences(updateBoth: true)
            AnalyticsEvents.trackToggleButtonChangeEvent(with: AnalyticsConstants.EventToggleButton.Name.marketingCallsTexts, value: toggle)
        }
    }
    
    /// updating the setting and preferences
    /// - Parameter updateBoth : bool value to check if the user needs update both or not
    func updateSettingsPreferences(updateBoth: Bool) {
        self.setSections()
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard let accountDetails = self.account,
                let contactDetails = self.contact else { return }
            if updateBoth {
                self.updateContacts(forContactDetails: contactDetails,
                                    account: accountDetails)
            } else {
                self.updateAccount(forAccountDetails: accountDetails)
            }
        }
    }
    
    /// getting all the information of the account using account id
    /// - Parameter accountID : to get the information of the account
    func getAccountInformation(forAccountId accountID: String) {
        repository.getAccount(forAccountId: accountID)
    }
    
    func updateAccount(forAccountDetails account: Account) {
        repository.accountPreferenceDetailsUpdate
            .subscribe(onNext: { success in
                if success {
                    self.switchResponse.onNext(success)
                }
            }).disposed(by: self.disposeBag)
        repository.errorMessageAccountPreference
            .subscribe(onNext: {[weak self] error in
                let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                    self?.updateAccount(forAccountDetails: account)
                }
                self?.isErrorState = true
                self?.viewStatusSubject.onNext(error)
            }).disposed(by: self.disposeBag)
        self.repository.updateAccountformation(forAccount: account)
    }
    
    /// updating the contact for an account
    /// - Parameter contact : Contact details of the selected account
    /// Account : Contains all the account value
    func updateContacts(forContactDetails contact: Contact, account: Account) {
        repository.contactPreferenceDetailsUpdate
            .subscribe(onNext: { success in
                if success {
                    AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.updateContactDetailsSuccess)
                    self.updateAccount(forAccountDetails: account)
                } else {
                    self.switchResponse.onNext(success)
                }
            }).disposed(by: self.disposeBag)
        
        repository.errorMessageContactPreference
            .subscribe(onNext: {[weak self] error in
                let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                    self?.updateContacts(forContactDetails: contact, account: account)
                }
                self?.isErrorState = true
                self?.viewStatusSubject.onNext(error)
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.updateContactDetailsFailure)
            }).disposed(by: self.disposeBag)
        self.repository.updateContactInformation(forContact: contact)
    }
    
    /// updating the user contact number if required
    func updateContactNumber() {
        if let phoneNumber = updatePhoneNumber {
            guard var contactDetails = self.contact
                else { return }
            contactDetails.mobileNumber = phoneNumber
            self.repository.updatePhoneNumberContactInformation(forContact: contactDetails)
        }
    }
    
    /// getting the contact information for the perticular account
    /// - Parameter contactID : contactID of the user
    func getContactInformation(forContactId contactID: String) {
        repository.getContact(forContactId: contactID)
    }
    
    /// getting the payment information for the perticular account
    /// - Parameter accountid : account id of the user to which the payment info is showing
    func getPaymentInformation(forAccountId accountId: String) {
        subscriptionRepository.getPaymentInfo(forAccountId: accountId)
    }
    
    /// getting the Fiber internet information for the perticular account
    /// - Parameter accountid : account id of the user to which the payment info is showing
    func getFiberPlanInformation(forAccountId accountId: String) {
        subscriptionRepository.getFiberPlanInfo(forAccountId: accountId)
    }
    
    /// show the alert to the user if anything goes wrong appropriate title and message
    /// - Parameter errorMessage: message to show the user
    func showAlert(withMessage errorMessage: String) {
        AlertPresenter.showRetryErrorAlert(title: Constants.Biometric.alertTitleError,
                                           message: errorMessage,
                                           retryAction: {
                                            self.getLogoutUser()
        },                                 cancelAction: nil,
                                           leftButtonTitle: Constants.Common.cancel.capitalized,
                                           rightButtonTitle: Constants.Common.retry)
        
    }
}
