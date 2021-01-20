//
//  SubscriptionRepositoryTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 16/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class SubscriptionRepositoryTest: XCTestCase {

    var subscriptionRepository: SubscriptionRepository?

    func testInitialisationEvent() {
        XCTAssertNotNil(subscriptionRepository = SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager()))
    }
    
    func testGetStatementList() {
        subscriptionRepository = SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager())
        XCTAssertNotNil(subscriptionRepository?.getStatementsList(forAccountID: "001q000001HdaIEAAZ"))
    }
    
    func testGetInvoice() {
        subscriptionRepository = SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager())
        XCTAssertNotNil(subscriptionRepository?.getInvoice(forPaymentID: "a7Nq0000000BYvgEAG"))
    }
    
    func testGetRecordID() {
        subscriptionRepository = SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager())
        XCTAssertNotNil(subscriptionRepository?.getRecordID())
    }
    
    func testCancelMySubscription() {
        subscriptionRepository = SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager())
        XCTAssertNotNil(subscriptionRepository?.cancelMySubscription(forCancelSubscription: CancelSubscription(contactID: "003q0000018bdWpAAI",
                                                                                               cancellationReason: "Reliability or Speed",
                                                                                               cancellationComment: "Reliability or Speed",
                                                                                               rating: "5",
                                                                                               recordTypeID: "012f0000000l1hsAAA",
                                                                                               cancellationDate: "2020-05-14T14:08:41.000+0000",
                                                                                               caseID: "",
                                                                                               status: true)))
    }
    
    func testGetPaymentInfo() {
        subscriptionRepository = SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager())
        XCTAssertNotNil(subscriptionRepository?.getPaymentInfo(forAccountId: "001q000001HdaIEAAZ"))
    }
}
