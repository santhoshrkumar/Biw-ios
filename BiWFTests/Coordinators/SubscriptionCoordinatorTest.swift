//
//  SubscriptionCoordinatorTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 14/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class SubscriptionCoordinatorTest: XCTestCase {
    
    let account = Account(accountId: "001q000001HdaIEAAZ",
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
    let paymentInfo = PaymentInfo(card: "Visa ************8291",
                                  billCycleDay: "29th of the month",
                                  nextRenewalDate: "2020-07-29",
                                  id: "a1Ff0000001hp33EAA")
    
    let fiberPlanInfo = FiberPlanInfo(internetSpeed: "Speeds up to 940Mbps", productName: "Fiber Internet", id: "a1Yf0000002hH8iEAE", zuoraPrice: 65.0, extendedAmount: 65.0)

    var subscriptionCoordinator: SubscriptionCoordinator?

    func testInitialisationEvent() {
        subscriptionCoordinator = SubscriptionCoordinator.init(navigationController: UINavigationController(),
                                                               subscription: Subscription(account: account,
                                                                                          paymentInfo: paymentInfo, fiberPlanInfo: fiberPlanInfo),
                                                               subscriptionRepository: SubscriptionRepository())
        subscriptionCoordinator?.start()
    }
}
