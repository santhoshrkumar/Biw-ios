//
//  StatementDetailViewControllerTest.swift
//  BiWFTests
//
//  Created by pooja.q.gupta on 17/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class StatementDetailViewControllerTest: XCTestCase {
    
    var statementDetailViewController: StatementDetailViewController?
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
        statementDetailViewController = storyboard.instantiateViewController(withIdentifier: "StatementDetailViewController")
            as? StatementDetailViewController
        _ = statementDetailViewController?.view
        let paymentRecord = PaymentRecord.init(attributes: RecordAttributes.init(type: "Zuora__Payment__c",
                                                                                 url: "/services/data/v46.0/sobjects/Zuora__Payment__c/a7Nq0000000BYvlEAG"),
                                               id: "a7Nq0000000BYvlEAG",
                                               zuoraInvoice: "a7fq0000000IFFsAAO",
                                               createdDate: "2020-05-07T10:08:05.000+0000",
                                               email: nil,
                                               billingAddress: nil)
        
        let viewModel = StatementDetailViewModel.init(withRepository: SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager()), paymentRecord: paymentRecord)
        statementDetailViewController?.setViewModel(to: viewModel)
        statementDetailViewController?.viewDidAppear(true)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        statementDetailViewController = nil
    }
    
    func testSanity() {
        XCTAssertNotNil(statementDetailViewController)
    }
}
