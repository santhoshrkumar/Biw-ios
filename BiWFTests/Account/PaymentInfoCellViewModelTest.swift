//
//  PaymentInfoCellViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 15/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class PaymentInfoCellViewModelTest: XCTestCase {

    func testInitMethod() {
        let viewmodel = PaymentInfoCellViewModel(withAccountInfo: Account(accountId: "12335", name: "Scott", firstName: "Hayden", billingAddress: BillingAddress(street: "Lakers", city: "USA", state: "Washington", postalCode: "5674-746"), marketingEmailOptIn: true, marketingCallOptIn: true, cellPhoneOptIn: false, productName: "Mynk", productPlanName: "Asar", email: "asar@centurylink.com", accountStatus: "passed", contactId: "0958", subscriptionEndDate: "12/10/2020", phone: "7758637292", serviceAddress: "Home", lineId: "86683-5873-876", serviceCity: "Washington", servicrCountry: "USA", serviceState: "30/12/2020", serviceStreet: "houston", serviceZipCode: "5772-928", serviceUnit: "450", nextPaymentDate: "12/01/2021"), andPaymentInfo: PaymentInfo(card: "Subscription", billCycleDay: "23/12/2020", nextRenewalDate: "31/12/2020", id: "765990370"), andFiberPlanInformation: FiberPlanInfo(internetSpeed: "Speeds up to 940Mbps", productName : "Fiber Inetrnet", id: "a1Yf0000002hH8iEAE", zuoraPrice : 65.0, extendedAmount: 65.0))
         XCTAssertNotNil(viewmodel)
     }
}
