//
//  PreferenceAndSettingsCellViewModel.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 09/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
/*
  PaymentInfoCellViewModel set the preference and settings
*/
class PreferenceAndSettingsCellViewModel {
    
    /// Input structure
    struct Input {
        let faceIDSwitchObserver: AnyObserver<Bool>
        let serviceCallSwitchObserver: AnyObserver<Bool>
        let marketingEmailSwitchObserver: AnyObserver<Bool>
        let marketingCallSwitchObserver: AnyObserver<Bool>
    }

    /// Output structure
    struct Output {
        let header: Driver<String>
        let loginSettingsHeader: Driver<String>
        let communicationPreferenceHeader: Driver<String>
        let faceIDText: Driver<String>
        let serviceCallText: Driver<String>
        let serviceCallDescriptionText: Driver<String>
        let marketingEmailText: Driver<String>
        let marketingEmailDescriptionText: Driver<String>
        let marketingCallText: Driver<String>
        let marketingCallDescriptionText: Driver<String>
        let faceIDSwitch: Driver<Bool>
        let serviceCallSwitch: Driver<Bool>
        let marketingEmailSwitch: Driver<Bool>
        let marketingCallSwitch: Driver<Bool>
        let complete: Observable<Bool>
    }
    
    /// Input & Output structure variabl
    let input: Input
    let output: Output

    /// BehaviorSubjects inside the perticular section
    let faceIDSubject = BehaviorSubject<Bool>(value: false)
    let serviceCallSubject = BehaviorSubject<Bool>(value: false)
    let marketingEmailSubject = BehaviorSubject<Bool>(value: false)
    let marketingCallSubject = BehaviorSubject<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    
    /// initial value of loader view
    var isInitiallyLoading: Bool = true

    /// Initialize a new instance of Account
    /// - Parameter Account: Contains all the varable and constants of personal info
    init(withAccountInformation accountInformation: Account) {
        input = Input(faceIDSwitchObserver: faceIDSubject.asObserver(),
                      serviceCallSwitchObserver: serviceCallSubject.asObserver(),
                      marketingEmailSwitchObserver: marketingEmailSubject.asObserver(),
                      marketingCallSwitchObserver: marketingCallSubject.asObserver())
        let completeObserver = Observable.merge(faceIDSubject.asObserver(),
                                                serviceCallSubject.asObserver(),
                                                marketingEmailSubject.asObserver(),
                                                marketingCallSubject.asObserver())
        output = Output(header: .just(Constants.PreferenceAndSettings.settingsPreferenceHeader),
                        loginSettingsHeader:.just(Constants.PreferenceAndSettings.loginSettingsHeader),
                        communicationPreferenceHeader: .just(Constants.PreferenceAndSettings.communicationPreferenceHeader),
                        faceIDText:.just(Constants.PreferenceAndSettings.faceIDText),
                        serviceCallText: .just(Constants.PreferenceAndSettings.serviceCallText),
                        serviceCallDescriptionText: .just(Constants.PreferenceAndSettings.serviceCallDescriptionText),
                        marketingEmailText: .just(Constants.PreferenceAndSettings.marketingEmailText),
                        marketingEmailDescriptionText: .just(Constants.PreferenceAndSettings.marketingEmailDescriptionText),
                        marketingCallText: .just(Constants.PreferenceAndSettings.marketingCallText),
                        marketingCallDescriptionText: .just(Constants.PreferenceAndSettings.marketingCallDescriptionText),
                        faceIDSwitch: .just(UserDefaults.standard.bool(forKey: Constants.Biometric.biometricEnabled)),
                        serviceCallSwitch: .just(accountInformation.cellPhoneOptIn ?? false),
                        marketingEmailSwitch: .just(accountInformation.marketingEmailOptIn ?? true),
                        marketingCallSwitch: .just(accountInformation.marketingCallOptIn ?? false),
                        complete: completeObserver.asObservable())
    }
}

