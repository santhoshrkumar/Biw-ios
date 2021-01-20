//
//  PersonalInfoViewModel.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 22/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
/*
  PersonalInfoViewModel for the user to provide their personalInfo
 */
class PersonalInfoViewModel {
    
    /// Input structure
    struct Input {
        let doneObserver: AnyObserver<Void>
        let emailObserver: AnyObserver<String>
        let passwordObserver: AnyObserver<String>
        let confirmPasswordObserver: AnyObserver<String>
        let moblieNumberObserver: AnyObserver<String>
    }
    
    /// Output structure
    struct Output {
        let loginInformationHeaderTextDriver: Driver<String>
        let emailTextDriver: Driver<String>
        let emailFieldTextDriver: Driver<String>
        let passwordTextDriver: Driver<String>
        let passwordFieldTextDriver: Driver<String>
        let confirmPasswordTextDriver: Driver<String>
        let phoneNumberTextDriver: Driver<String>
        let mobilePhoneTextDriver: Driver<String>
        let mobilePhoneFieldTextDriver: Driver<String>
        let requiredFiledTextDriver: Driver<String>
        let passwordDonotMatchTextDriver: Driver<String>
        let confirmPasswordDonotMatchTextDriver: Driver<String>
        let phoneNumberLengthDriver: Driver<String>
        let viewComplete: Observable<AccountCoordinator.Event>
        let viewStatusObservable: Observable<ViewStatus>
    }
    
    /// Input & Output structure variable
    let input: Input
    let output: Output
    
    /// Subjects to come back from the present screen to dashboard
    private let doneSubject = PublishSubject<Void>()
    
    /// Subjects to open the custom alert when something went wrong
    let openCustomAlertSubject = PublishSubject<(String, NSMutableAttributedString)>()
    
    /// BehaviorSubject to provide the user inputs
    private let emailSubject =  BehaviorSubject<String>(value: "")
    private let passwordSubject = BehaviorSubject<String>(value: "")
    private let confirmPasswordSubject = BehaviorSubject<String>(value: "")
    private let mobilePhoneSubject = BehaviorSubject<String>(value: "")
    
    /// Subjects to indicate after all the fields are given by user
    private let doneEventSubject = PublishSubject<AccountCoordinator.Event>()
    
    /// Subject to view the status of personal information
    private let viewStatusSubject = PublishSubject<ViewStatus>()
    let updateTextviewStateSubject = PublishSubject<Bool>()
    
    /// Variables/Constants
    private var repository: AccountRepository
    private let disposeBag = DisposeBag()
    
    /// Holds the accountInfo with a strong reference
    var accountInfo: Account
    
    /// Shows the singlebutton alert on alert window
    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    
    /// initial value of cellphone update
    var isCellPhoneUpdate = false
    
    /// Initializes a new instance of AccountRepository and Account
    /// - Parameter AccountRepository : Gives all the api values to the Account
    /// Account : Contains all the varable and constants of personal info
    init(withRepository accountRepository: AccountRepository, accountInfo: Account) {
        
        self.repository = accountRepository
        self.accountInfo = accountInfo
        
        input = Input(doneObserver: doneSubject.asObserver(),
                      emailObserver: emailSubject.asObserver(),
                      passwordObserver: passwordSubject.asObserver(),
                      confirmPasswordObserver: confirmPasswordSubject.asObserver(),
                      moblieNumberObserver: mobilePhoneSubject.asObserver())
        
        let openChangeEmailEventObservable = openCustomAlertSubject.asObservable().map { (title, message) in
            return AccountCoordinator.Event.showCustomAlert(title, message)
        }
        
        let viewCompleteObservable = Observable.merge(doneEventSubject.asObservable(),
                                                      openChangeEmailEventObservable)
        
        output = Output(loginInformationHeaderTextDriver: .just(Constants.PersonalInformation.loginInformation),
                        emailTextDriver: .just(Constants.PersonalInformation.emailAddress),
                        emailFieldTextDriver: .just(accountInfo.email ?? ""),
                        passwordTextDriver: .just(Constants.PersonalInformation.password),
                        passwordFieldTextDriver: .just(""),
                        confirmPasswordTextDriver: .just(Constants.PersonalInformation.confirmPassword),
                        phoneNumberTextDriver: .just(Constants.PersonalInformation.phoneNumber),
                        mobilePhoneTextDriver: .just(Constants.PersonalInformation.mobileNumber),
                        mobilePhoneFieldTextDriver: .just(accountInfo.formatedPhoneNumber(inGeneralFormat: false)),
                        requiredFiledTextDriver: .just(Constants.PersonalInformation.requiredFields),
                        passwordDonotMatchTextDriver: .just(Constants.PersonalInformation.passwordDonotMatch),
                        confirmPasswordDonotMatchTextDriver: .just(Constants.PersonalInformation.passwordDonotMatch),
                        phoneNumberLengthDriver: .just(Constants.PersonalInformation.invalidPhoneNumberLength),
                        viewComplete: viewCompleteObservable,
                        viewStatusObservable: viewStatusSubject.asObservable())
        
        updateTextviewStateSubject.subscribe(onNext: { [weak self] shouldUpdate in
            self?.isCellPhoneUpdate = shouldUpdate
        }).disposed(by: self.disposeBag)
        
        doneSubject.subscribe(onNext: { [weak self] _ in
            do {
                guard let self = self else { return }
                let password = try self.confirmPasswordSubject.value()
                let phoneNumber = try self.mobilePhoneSubject.value()
                
                if password != "" {
                    let loading = ViewStatus.loading(loadingText: Constants.Common.loading)
                    self.viewStatusSubject.onNext(loading)
                    self.repository.changedPassword
                        .subscribe(onNext: { success in
                            self.viewStatusSubject.onNext(ViewStatus.loaded)
                            switch success {
                            case true:
                                var updatedPhoneNumber: String?
                                if self.isCellPhoneUpdate {
                                    updatedPhoneNumber = phoneNumber
                                }
                                self.doneEventSubject.onNext(.goBackToAccount(updatedPhoneNumber))
                                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.resetPasswordSuccess)
                            case false:break
                            }
                        }).disposed(by: self.disposeBag)
                    
                    self.repository.errorMessage
                        .subscribe(onNext: { message in
                            self.viewStatusSubject.onNext(ViewStatus.loaded)
                            DispatchQueue.main.async {
                                self.openCustomAlert(withMessage: NSMutableAttributedString(attributedString: NSAttributedString(string: message)),
                                                     title: Constants.PersonalInformation.errorOccured)
                            }
                            AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.resetPasswordFailure)
                        }).disposed(by: self.disposeBag)
                    self.repository.changeUserPassword(withNewPassword: password)
                }  else {
                    var updatedPhoneNumber: String?
                    if self.isCellPhoneUpdate {
                        updatedPhoneNumber = phoneNumber
                    }
                    self.doneEventSubject.onNext(.goBackToAccount(updatedPhoneNumber))
                }
            } catch {}
        }).disposed(by: disposeBag)
    }
    
    /// Used to give the alert for user when some inputs are entered wrong.
    /// - Parameter message: Appropriate message about the alert
    /// title : Respective title of the alert window
    func openCustomAlert(withMessage message: NSMutableAttributedString, title: String) {
        AnalyticsEvents.trackScreenVisitEvent(with: AnalyticsConstants.EventScreenName.changeEmailInfoPopup)
        openCustomAlertSubject.onNext((title, message))
    }
    
    /// Checks whether the entered phone number is valid or not
    /// - Parameter phone : Phonenumber of the user
    /// returns bool value depends on the phone number entered
    func isValidPhone(phone: String) -> Bool {
        let phoneWithoutSpecialCharacter = phone.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
        let phoneRegex = "^[0-9]{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneWithoutSpecialCharacter)
    }
}
