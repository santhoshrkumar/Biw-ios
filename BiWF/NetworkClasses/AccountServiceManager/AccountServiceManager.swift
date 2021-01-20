//
//  AccountServiceManager.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 04/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift

protocol AccountServiceManager {
    func updateUserPassword(newPassword: String) -> Observable<Result<Data, Error>>
    func getUser() -> Observable<Result<Data, Error>>
    func getUserDetails() -> Observable<Result<Data, Error>>
    func getAccountInformation(forAccountId accountId: String) -> Observable<Result<Data, Error>>
    func getContactInformation(forContactId contactId: String) -> Observable<Result<Data, Error>>
    func updateContactInformation(forContact contact: Contact) -> Observable<Result<Data, Error>>
    func updateAccountInformation(forAccount account: Account) -> Observable<Result<Data, Error>>
    func getAssiaID(forAccountId accountID: String) -> Observable<Result<Data, Error>>
    func logoutUser() -> Observable<Result<Data, Error>>
}
