//
//  PersonalInfoCellViewModel.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 09/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
/*
 PersonalInfoCellViewModel for the user to provide their personalInfo
*/
class PersonalInfoCellViewModel {

    /// Constants/Variables
    let header: Driver<String>
    let cellPhoneText: Driver<String>
    let cellPhoneValue: Driver<String>
    let emailInfoText: Driver<String>
    let emailInfoValue: Driver<String>
    let passwordText: Driver<String>
    let passwordValue: Driver<String>
    
    /// Initialize a new instance of Account
    /// - Parameter Account: Contains all the varable and constants of personal info
    init(withPersonalInfo accountInfo: Account) {
        header = .just(Constants.Account.personalInfoText)
        cellPhoneText = .just(Constants.Account.cellPhoneText)
        cellPhoneValue = .just(accountInfo.formatedPhoneNumber(inGeneralFormat: true))
        emailInfoText = .just(Constants.Account.emailInfoText)
        emailInfoValue = .just(accountInfo.email ?? "")
        passwordText = .just(Constants.Account.passwordText)
        passwordValue = .just(Constants.Account.passwordPlaceholder)
    }
}
