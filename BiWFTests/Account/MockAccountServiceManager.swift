//
//  MockAccountServiceManager.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 5/13/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
@testable import BiWF

class MockAccountServiceManager: AccountServiceManager {

    func logoutUser() -> Observable<Result<Data, Error>> {
        let logoutUserResult = PublishSubject<Result<Data, Error>>()
        logoutUserResult.onNext(getDataFromJSON(resource: "user"))
        return logoutUserResult
    }
    
    func updateUserPassword(newPassword: String) -> Observable<Result<Data, Error>> {
        let changePasswordResult = PublishSubject<Result<Data, Error>>()
        changePasswordResult.onNext(getDataFromJSON(resource: "user"))
        return changePasswordResult
    }
    
    func getUser() -> Observable<Result<Data, Error>> {
        let userResponse = PublishSubject<Result<Data, Error>>()
        userResponse.onNext(getDataFromJSON(resource: "user"))
        return userResponse
    }
    
    func getAssiaID(forAccountId accountID: String) -> Observable<Result<Data, Error>> {
        let assiaIDResponse = PublishSubject<Result<Data, Error>>()
        assiaIDResponse.onNext(getDataFromJSON(resource: "AssiaIDResponse"))
        return assiaIDResponse
    }
    
    func getUserDetails() -> Observable<Result<Data, Error>> {
        let userDetailsResult = PublishSubject<Result<Data, Error>>()
        userDetailsResult.onNext(getDataFromJSON(resource: "userDetails"))
        return userDetailsResult
    }
    
    func getAccountInformation(forAccountId accountId: String) -> Observable<Result<Data, Error>> {
        let accountInformationResult = PublishSubject<Result<Data, Error>>()
        accountInformationResult.onNext(getDataFromJSON(resource: "account"))
        return accountInformationResult
    }
    
    func getContactInformation(forContactId contactId: String) -> Observable<Result<Data, Error>> {
        let contactInformationResult = PublishSubject<Result<Data, Error>>()
        contactInformationResult.onNext(getDataFromJSON(resource: "contact"))
        return contactInformationResult
    }
    
    func updateContactInformation(forContact contact: Contact) -> Observable<Result<Data, Error>> {
        let updateContactInformationResult = PublishSubject<Result<Data, Error>>()
        updateContactInformationResult.onNext(.success(Data()))
        return updateContactInformationResult
    }
    
    func updateAccountInformation(forAccount account: Account) -> Observable<Result<Data, Error>> {
        let updateAccountInformationResult = PublishSubject<Result<Data, Error>>()
        updateAccountInformationResult.onNext(.success(Data()))
        return updateAccountInformationResult
    }
    
    ///Can be handeled later empty case later
    func getAccountDetails() -> Account {
        guard let path = Bundle.main.path(forResource: "account",
                                          ofType: "json") else {
                                            return mockAccountObject()
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path),
                                options: .mappedIfSafe)
            let accountInfo = try JSONDecoder().decode(Account.self, from: data)
            return accountInfo
        } catch {
            print(error)
            return mockAccountObject()
        }
    }
    
    func mockAccountObject() -> Account {
        return Account(accountId: "001q000001HdaIEAAZ",
        name: "Client",
        firstName: "Client",
        billingAddress: BillingAddress.init(street: "1234 Main St",
                                            city: "Denver",
                                            state: "CO",
                                            postalCode: "77731"), marketingEmailOptIn: true,
                                                                  marketingCallOptIn: true,
                                                                  cellPhoneOptIn: true,
                                                                  productName: "Fiber Gigabit",
                                                                  productPlanName: "Best in world fiber",
                                                                  email: "nick@centurylink.com",
                                                                  lineId: "0101100408",
                                                                  serviceCity: "Denver",
                                                                  servicrCountry: "CO",
                                                                  serviceState: "CO",
                                                                  serviceStreet: "1234 Main St",
                                                                  serviceZipCode: "77731",
                                                                  serviceUnit: "CO",
                                                                  nextPaymentDate: "2020-07-29")
    }
    
    private func getDataFromJSON(resource: String) -> Result<Data, Error> {
        guard let path = Bundle.main.path(forResource: resource, ofType: "json") else {
            return .failure(HTTPError.noResponse)
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}
