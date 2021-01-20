//
//  StatmentDetailViewModelTest.swift
//  BiWFTests
//
//  Created by pooja.q.gupta on 19/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class StatementDetailViewModelTest: XCTestCase {
    private let disposeBag = DisposeBag()
    private let paymentRecord = PaymentRecord.init(attributes: RecordAttributes.init(type: "Zuora__Payment__c",
                                                                                     url: "/services/data/v46.0/sobjects/Zuora__Payment__c/a7Nq0000000BYvlEAG"),
                                                   id: "a7Nq0000000BYvlEAG",
                                                   zuoraInvoice: "a7fq0000000IFFsAAO",
                                                   createdDate: "2020-05-07T10:08:05.000+0000",
                                                   email: nil,
                                                   billingAddress: nil)
    
    func testInit() {
        let viewModel = StatementDetailViewModel(withRepository: SubscriptionRepository(subscriptionServiceManager: MockSubscriptionServiceManager()),
                                                 paymentRecord: paymentRecord)
        XCTAssertNotNil(viewModel)
    }
    
    func testDoneEvent() {
        let testExpectation = expectation(description: "Receive event to go to account view")
        
        let viewModel = StatementDetailViewModel(withRepository: SubscriptionRepository(subscriptionServiceManager: MockSubscriptionServiceManager()),
                                                 paymentRecord: paymentRecord)
        
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goBackToAccount = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.doneTapObserver.onNext(Void())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testBackEvent() {
        let testExpectation = expectation(description: "Receive event to go back from statement screen")
        
        let viewModel = StatementDetailViewModel(withRepository: SubscriptionRepository(subscriptionServiceManager: MockSubscriptionServiceManager()),
                                                 paymentRecord: paymentRecord)
        
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goBack = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.backTapObserver.onNext(Void())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testSection() {
        let testExpectation = expectation(description: "Receive sections from view model")
        let viewModel = StatementDetailViewModel(withRepository: SubscriptionRepository(subscriptionServiceManager: MockSubscriptionServiceManager()),
                                                 paymentRecord: paymentRecord)
        
        viewModel.sections.subscribe(onNext: { sections in
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testCreatePaymentDetailsItem() {
        let viewModel = StatementDetailViewModel(withRepository: SubscriptionRepository(subscriptionServiceManager: MockSubscriptionServiceManager()),
                                                 paymentRecord: paymentRecord)
            
        XCTAssertNotNil(viewModel.createPaymentDetailsItem(withInvoiceDetails: Invoice(id: "748363", paymentName: "Modem", planName: "Discussed", planPrice: "756211", salesTaxAmount: 344.4, totalCost: 678.8, processedDate: "29/12/20", billingAddress: "Washington", email: "biwf@test.com", promoCode: "86730938", promoCodeValue: 0, promoCodeDescription: nil)))
    }
    
    func testCreatePaymentBreakdownItem() {
        let viewModel = StatementDetailViewModel(withRepository: SubscriptionRepository(subscriptionServiceManager: MockSubscriptionServiceManager()),
                                                 paymentRecord: paymentRecord)
            
        XCTAssertNotNil(viewModel.createPaymentBreakdownItem(withInvoiceDetails: Invoice(id: "748363", paymentName: "Modem", planName: "Discussed", planPrice: "756211", salesTaxAmount: 344.4, totalCost: 678.8, processedDate: "29/12/20", billingAddress: "Washington", email: "biwf@test.com", promoCode: "86730938", promoCodeValue: 0, promoCodeDescription: nil)))
    }
    
    func testGetInvoice() {
        let viewModel = StatementDetailViewModel(withRepository: SubscriptionRepository(subscriptionServiceManager: MockSubscriptionServiceManager()),
                                                 paymentRecord: paymentRecord)
        XCTAssertNotNil(viewModel.getInvoice())
        viewModel.repository.invoice.onNext(Invoice(id: "748363", paymentName: "Modem", planName: "Discussed", planPrice: "756211", salesTaxAmount: 344.4, totalCost: 678.8, processedDate: "29/12/20", billingAddress: "Washington", email: "biwf@test.com", promoCode: "86730938", promoCodeValue: 0, promoCodeDescription: nil))
        viewModel.repository.errorMessage.onNext("No Error")
    }
}
