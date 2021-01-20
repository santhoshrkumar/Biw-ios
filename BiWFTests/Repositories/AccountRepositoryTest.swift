//
//  AccountRepositoryTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 14/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class AccountRepositoryTest: XCTestCase {
    
    var accountRepository: AccountRepository?
    
    func testInitialisationEvent() {
        XCTAssertNotNil(accountRepository = AccountRepository.init(accountServiceManager: MockAccountServiceManager()))
    }
    
    func testChangePassword() {
        accountRepository = AccountRepository.init(accountServiceManager: MockAccountServiceManager())
        XCTAssertNotNil(accountRepository?.changeUserPassword(withNewPassword: "Test123"))
    }
    
    func testGetUser() {
        accountRepository = AccountRepository.init(accountServiceManager: MockAccountServiceManager())
        XCTAssertNotNil(accountRepository?.getUser())
    }
    
    func testLogoutUser() {
        accountRepository = AccountRepository.init(accountServiceManager: MockAccountServiceManager())
        XCTAssertNotNil(accountRepository?.logoutUser())
    }
    
    func testGetUserDetails() {
        accountRepository = AccountRepository.init(accountServiceManager: MockAccountServiceManager())
        XCTAssertNotNil(accountRepository?.getUserDetails())
    }
    
    func testGetAccount() {
        accountRepository = AccountRepository.init(accountServiceManager: MockAccountServiceManager())
        XCTAssertNotNil(accountRepository?.getAccount(forAccountId: "001q000001HdaIEAAZ"))
    }
    
    func testGetContact() {
        accountRepository = AccountRepository.init(accountServiceManager: MockAccountServiceManager())
        XCTAssertNotNil(accountRepository?.getContact(forContactId: "003f000001Q5fkjAAB"))
    }
    
    func testUpdateContactInformation() {
        accountRepository = AccountRepository.init(accountServiceManager: MockAccountServiceManager())
        XCTAssertNotNil(accountRepository?.updateContactInformation(forContact: mockContactObject()))
    }
    
    func testUpdateAccountformation() {
        accountRepository = AccountRepository.init(accountServiceManager: MockAccountServiceManager())
        XCTAssertNotNil(accountRepository?.updateAccountformation(forAccount: mockAccountObject()))
    }
    
    func testUpdatePhoneNumberContactInformation() {
        accountRepository = AccountRepository.init(accountServiceManager: MockAccountServiceManager())
        XCTAssertNotNil(accountRepository?.updatePhoneNumberContactInformation(forContact: mockContactObject()))
    }
    
    func testGetAssiaID() {
        accountRepository = AccountRepository.init(accountServiceManager: MockAccountServiceManager())
        XCTAssertNotNil(accountRepository?.getAssiaId(forAccountID: "001q000001HdaIEAAZ"))
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
    
    func mockContactObject() -> Contact {
        return Contact(contactId: "003f000001Q5fkjAAB",
                       marketingEmailOptIn: true,
                       marketingCallOptIn: false,
                       cellPhoneOptIn: false,
                       mobileNumber: "0123456789")
    }
}
