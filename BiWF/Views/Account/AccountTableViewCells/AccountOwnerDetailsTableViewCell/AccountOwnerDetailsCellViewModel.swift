//
//  AccountOwnerDetailsCellViewModel.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 10/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
/*
  AccountOwnerDetailsCellViewModel set the values for account owners
*/
class AccountOwnerDetailsCellViewModel {

    /// Constants/Variables
    let nameTextDriver: Driver<String>
    let serviceAdressTextDriver: Driver<String>
    let serviceAdressValueDriver: Driver<String>
    let serviceUnitDriver: Driver<String>
    let serviceCityDriver: Driver<String>
    let serviceStateDriver: Driver<String>
    let serviceZipDriver: Driver<String>
    
    /// Initialize a new instance of Account
    /// - Parameter Account: Contains all the varable and constants of personal info
    init(withAccountInfo accountInfo: Account) {
        nameTextDriver = .just(accountInfo.name ?? "")
        serviceAdressTextDriver = .just(Constants.Account.serviceAddressText)
        serviceAdressValueDriver = .just(accountInfo.serviceStreet ?? "")
        serviceUnitDriver = .just(accountInfo.serviceUnit ?? "")
        serviceCityDriver = .just(accountInfo.getFormattedCity())
        serviceStateDriver = .just(accountInfo.serviceState ?? "")
        serviceZipDriver = .just(accountInfo.serviceZipCode ?? "")
    }
}

