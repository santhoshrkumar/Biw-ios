//
//  AccountRepository.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 3/24/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import DPProtocols
import RxSwift
import Foundation
/**
 Assists in the implemetation of the AccountRepository, enabling an abstraction of data
 */
struct AccountRepository: Repository {
    
    /// PublishSubject notification is broadcasted to all subscribed observers when responses come as Bool/Objects/ error
    let changedPassword = PublishSubject<Bool>()
    let errorMessage = PublishSubject<String>()
    let logoutUserResponse = PublishSubject<Bool>()
    let userDetail = PublishSubject<UserDetails>()
    let errorMessageUserDetail = PublishSubject<String>()
    let userResult = PublishSubject<User>()
    let errorMessageUser = PublishSubject<String>()
    let accountDetails = PublishSubject<Account>()
    let errorMessageAccountDetail = PublishSubject<String>()
    let contactDetails = PublishSubject<Contact>()
    let errorMessageLogoutUser = PublishSubject<String>()
    let errorMessageContactDetail = PublishSubject<String>()
    let accountPreferenceDetailsUpdate = PublishSubject<Bool>()
    let errorMessageAccountPreference = PublishSubject<String>()
    let contactPreferenceDetailsUpdate = PublishSubject<Bool>()
    let errorMessageContactPreference = PublishSubject<String>()
    let contactPhoneNumberUpdate = PublishSubject<Bool>()
    /// Contained disposables disposal
    let disposeBag = DisposeBag()
    /// Holds the accountServiceManager with a strong reference
    let accountServiceManager: AccountServiceManager
    
    /// Initialise the AccountServiceManager
    /// - Parameters:
    ///   - accountServiceManager: shared object of accountServiceManager
    init(accountServiceManager: AccountServiceManager = NetworkAccountServiceManager.shared) {
        self.accountServiceManager = accountServiceManager
    }
    
    /// Call method of network manager which change user password
    /// - Parameters:
    ///   - withNewPassword: new passowrd "string" entered by user
    func changeUserPassword(withNewPassword password: String) {
        accountServiceManager.updateUserPassword(newPassword: password)
            .subscribe(onNext: { [unowned changedPassword, unowned errorMessage] result in
                switch result {
                case .success(let response):
                    let responseMessage = ServiceManager.shared.getResponseData(data: response)
                    if responseMessage != "" {
                        errorMessage.onNext(responseMessage)
                    } else {
                        changedPassword.onNext(true)
                    }
                case .failure(let error):
                    // Show the error message returning from server
                    errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Call method of account network manager which fetch user "userID"
    func getUser() {
        accountServiceManager.getUser()
            .subscribe(onNext: { [unowned userResult, unowned errorMessageUser] result in
                switch result {
                case .success(let response):
                    do {
                        let user = try JSONDecoder().decode(User.self, from: response)
                        //save the accountID to userdefaults and call get assia ID service
                        if let userID = user.recentItems?[0].id {
                            ServiceManager.shared.set(userID: userID)
                            ServiceManager.shared.set(orgID: "")
                        }
                        userResult.onNext(user)
                    } catch {
                        errorMessageUser.onNext(ServiceManager.getErrorMessage(forError: error))
                    }
                case .failure(let error):
                    errorMessageUser.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Call method of account network manager which hit logout user API
    func logoutUser() {
        accountServiceManager.logoutUser()
            .subscribe(onNext: { [unowned errorMessageLogoutUser] result in
                switch result {
                case .success(_):
                    self.logoutUserResponse.onNext(true)
                case .failure(let error):
                    errorMessageLogoutUser.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Call method of account network manager which fetch user details
    func getUserDetails() {
        accountServiceManager.getUserDetails()
            .subscribe(onNext: { [unowned userDetail, unowned errorMessageUserDetail] result in
                switch result {
                case .success(let response):
                    do {
                        let userDetails = try JSONDecoder().decode(UserDetails.self, from: response)
                        userDetail.onNext(userDetails)
                        
                        //save the accountID to userdefaults and call get assia ID service
                        if let accountID = userDetails.accountID {
                            ServiceManager.shared.set(accountID: accountID)
                            let _ = self.getAssiaId(forAccountID: accountID)
                        }
                        //save the email to userdefaults
                        if let email = userDetails.email {
                            ServiceManager.shared.set(email: email)
                        }                        
                    } catch {
                        errorMessageUserDetail.onNext(ServiceManager.getErrorMessage(forError: error))
                    }
                case .failure(let error):
                    errorMessageUserDetail.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Call method of account network manager which fetch account details using account ID come from user details API
    /// - Parameters:
    ///   - forAccountId: account ID come from user details
    func getAccount(forAccountId accountId: String) {
        
        accountServiceManager.getAccountInformation(forAccountId: accountId)
            .subscribe(onNext: { [unowned accountDetails, unowned errorMessageAccountDetail] result in
                switch result {
                case .success(let response):
                    do {
                        let accountInfo = try JSONDecoder().decode(Account.self, from: response)
                        ServiceManager.shared.set(lineID: accountInfo.lineId)
                        ServiceManager.shared.set(phone: accountInfo.phone)
                        ServiceManager.shared.set(billingState: accountInfo.billingAddress.state)
                        accountDetails.onNext(accountInfo)
                    } catch {
                        errorMessageAccountDetail.onNext(ServiceManager.getErrorMessage(forError: error))
                    }
                case .failure(let error):
                    errorMessageAccountDetail.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Call method of account network manager which fetch contact details using contact ID come from user details API
    /// - Parameters:
    ///   - forContactId: contactId come from user details
    func getContact(forContactId contactId: String) {
        accountServiceManager.getContactInformation(forContactId: contactId)
            .subscribe(onNext: { [unowned contactDetails, unowned errorMessageContactDetail] result in
                switch result {
                case .success(let response):
                    do {
                        let contactInfo = try JSONDecoder().decode(Contact.self, from: response)
                        contactDetails.onNext(contactInfo)
                    } catch {
                        errorMessageContactDetail.onNext(ServiceManager.getErrorMessage(forError: error))
                    }
                case .failure(let error):
                    errorMessageContactDetail.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Call method of account network manager which update contact details using contact object come from contact details API
    /// - Parameters:
    ///   - forContact: contact object come from contact details API
    func updateContactInformation(forContact contact: Contact) {
        accountServiceManager.updateContactInformation(forContact: contact)
            .subscribe(onNext: { [unowned contactPreferenceDetailsUpdate] result in
                switch result {
                case .success(_):
                    contactPreferenceDetailsUpdate.onNext(true)
                case .failure(_):
                    contactPreferenceDetailsUpdate.onNext(false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Call method of account network manager which update account details object come from account details API
    /// - Parameters:
    ///   - forAccount: account object come from account details API
    func updateAccountformation(forAccount account: Account) {
        accountServiceManager.updateAccountInformation(forAccount: account)
            .subscribe(onNext: { [unowned accountPreferenceDetailsUpdate] result in
                switch result {
                case .success(_):
                    accountPreferenceDetailsUpdate.onNext(true)
                case .failure(_):
                    accountPreferenceDetailsUpdate.onNext(false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Call method of account network manager which update contact number using contact object come from contact details API
    /// - Parameters:
    ///   - forContact: contact object come from contact details API
    func updatePhoneNumberContactInformation(forContact contact: Contact) {
        accountServiceManager.updateContactInformation(forContact: contact)
            .subscribe(onNext: { [unowned contactPhoneNumberUpdate] result in
                switch result {
                case .success(_):
                    contactPhoneNumberUpdate.onNext(true)
                case .failure(_):
                    contactPhoneNumberUpdate.onNext(false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Call method of account network manager fetch assiaID using Account ID came from Account details API
    /// - Parameters:
    ///   - forAccountID: Account ID came from Account details API
    /// - returns:
    ///   - assiaID: assiaID come from API response
    ///   - error: if any error come in API response
    func getAssiaId(forAccountID accountID: String) -> Observable<(assiaID: String?, error: String?)> {
        let assiaIDResponse = PublishSubject<(assiaID: String?, error: String?)>()
        
        accountServiceManager.getAssiaID(forAccountId: accountID)
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    do {
                        let response = try JSONDecoder().decode(AssiaIdResponse.self, from: response)
                        if response.records.count > 0 {
                            var modemNumber = (response.records[0].modemNumber ?? ServiceManager.shared.tempAssiaID)
                            //Check if its "test123", replace it with tempAssiaID
                            modemNumber = (modemNumber == "test123") ? ServiceManager.shared.tempAssiaID : modemNumber
                            assiaIDResponse.onNext((assiaID: modemNumber, error: nil))
                            ServiceManager.shared.set(assiaID: modemNumber)
                            assiaIDResponse.onCompleted()
                        }
                    } catch {
                        assiaIDResponse.onNext((assiaID: nil, error: ServiceManager.getErrorMessage(forError: error)))
                        assiaIDResponse.onCompleted()
                    }
                case .failure(let error):
                    assiaIDResponse.onNext((assiaID: nil, error: ServiceManager.getErrorMessage(forError: error)))
                    assiaIDResponse.onCompleted()
                }
            })
            .disposed(by: disposeBag)
        
        return assiaIDResponse.asObservable()
    }
}
