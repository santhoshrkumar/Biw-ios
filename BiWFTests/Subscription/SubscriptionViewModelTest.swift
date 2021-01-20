//
//  SubscriptionViewModelTest.swift
//  BiWFTests
//
//  Created by pooja.q.gupta on 19/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class SubscriptionViewModelTest: XCTestCase {
    
    private let disposeBag = DisposeBag()
    private let account = Account.init(accountId: "001q000001HdaIEAAZ",
                                       name: "Client",
                                       firstName: "Client",
                                       billingAddress: BillingAddress.init(street: "1234 Main St",
                                                                           city: "Denver",
                                                                           state: "CO",
                                                                           postalCode: "77731"),
                                       marketingEmailOptIn: true,
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

    private let paymentInfo = PaymentInfo(card: "Visa ************8291",
                                          billCycleDay: "29th of the month",
                                          nextRenewalDate: "2020-07-29",
                                          id: "a1Ff0000001hp33EAA")
    
    private let fiberPlanInfo = FiberPlanInfo(internetSpeed: "Speeds up to 940Mbps", productName: "Fiber Internet", id: "a1Yf0000002hH8iEAE", zuoraPrice: 65.0, extendedAmount: 65.0)

    private var subscription: Subscription {
        return Subscription(account: account, paymentInfo: paymentInfo, fiberPlanInfo: fiberPlanInfo)
    }
    
    func testDoneEvent() {
        let testExpectation = expectation(description: "Receive event to close subscription view")
        let viewModel = SubscriptionViewModel(with: subscription,
                                              repository: SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager()))
        
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
    
    func testGoToManageSubscriptionEvent() {
        let testExpectation = expectation(description: "Open manage subscription screen")
        let viewModel = SubscriptionViewModel(with: subscription,
                                              repository: SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager()))
        
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goToManageSubscription = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        viewModel.input.moveToManageMySubscription.onNext(account)
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testGoToEditPaymentEvent() {
        let testExpectation = expectation(description: "Open manage subscription screen")
        let viewModel = SubscriptionViewModel(with: subscription,
                                              repository: SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager()))
        
        viewModel.statements = [PaymentRecord.init(attributes: RecordAttributes.init(type: "Zuora__Payment__c",
                                                                                     url: "/services/data/v46.0/sobjects/Zuora__Payment__c/a7Nq0000000BYvlEAG"),
                                                   id: "a7Nq0000000BYvlEAG",
                                                   zuoraInvoice: "a7fq0000000IFFsAAO",
                                                   createdDate: "2020-05-07T10:08:05.000+0000",
                                                   email: nil,
                                                   billingAddress: nil)]
        
        viewModel.output.viewComplete.subscribe(onNext: { event in
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        viewModel.input.cellSelectionObserver.onNext(IndexPath(row: 0, section: 1))
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testGoToMySubscriptionEvent() {
        let testExpectation = expectation(description: "Open manage subscription screen")
        let viewModel = SubscriptionViewModel(with: subscription,
                                              repository: SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager()))
        
        viewModel.statements = [PaymentRecord.init(attributes: RecordAttributes.init(type: "Zuora__Payment__c",
                                                                                     url: "/services/data/v46.0/sobjects/Zuora__Payment__c/a7Nq0000000BYvlEAG"),
                                                   id: "a7Nq0000000BYvlEAG",
                                                   zuoraInvoice: "a7fq0000000IFFsAAO",
                                                   createdDate: "2020-05-07T10:08:05.000+0000",
                                                   email: nil,
                                                   billingAddress: nil)]
        
        viewModel.output.viewComplete.subscribe(onNext: { event in
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        viewModel.input.cellSelectionObserver.onNext(IndexPath(row: 0, section: 2))
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testGoToPreviousStatementsEvent() {
        let testExpectation = expectation(description: "Open manage subscription screen")
        let viewModel = SubscriptionViewModel(with: subscription,
                                              repository: SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager()))
        
        viewModel.statements = [PaymentRecord.init(attributes: RecordAttributes.init(type: "Zuora__Payment__c",
                                                                                     url: "/services/data/v46.0/sobjects/Zuora__Payment__c/a7Nq0000000BYvlEAG"),
                                                   id: "a7Nq0000000BYvlEAG",
                                                   zuoraInvoice: "a7fq0000000IFFsAAO",
                                                   createdDate: "2020-05-07T10:08:05.000+0000",
                                                   email: nil,
                                                   billingAddress: nil)]
        
        viewModel.output.viewComplete.subscribe(onNext: { event in
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        viewModel.input.cellSelectionObserver.onNext(IndexPath(row: 0, section: 3))
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testGoToStatementDetailEvent() {
        let testExpectation = expectation(description: "Open statement detail screen")
        let viewModel = SubscriptionViewModel(with: subscription,
                                              repository: SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager()))
        let manager = MockSubscriptionServiceManager()
        viewModel.statements = manager.mockStatementList()
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goToStatementDetail = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.cellSelectionObserver.onNext(IndexPath(row: 0, section: SubscriptionViewModel.SectionType.previousStatements.rawValue))
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testSection() {
        let testExpectation = expectation(description: "Receive sections from view model")
        let viewModel = SubscriptionViewModel(with: subscription,
                                              repository: SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager()))
        
        viewModel.sections.subscribe(onNext: { sections in
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        wait(for: [testExpectation], timeout: 5)
    }

    func testupdatePaymentInfo() {
        let viewModel = SubscriptionViewModel(with: subscription,
                                              repository: SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager()))
        XCTAssertNotNil(viewModel.updatePaymentInfo())
    }
    
    func testSuccessResponse() {
        let viewModel = SubscriptionViewModel(with: subscription,
                                              repository: SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager()))
        XCTAssertNotNil(viewModel.subscriptionRepository.statementsList.onNext(StatementList(totalSize: 120, done: true, records: MockSubscriptionServiceManager().mockStatementList())))
        
        XCTAssertNotNil(viewModel.subscriptionRepository.paymentInfo.onNext(PaymentInfo(card: "Visa ************8291",
                                                                                        billCycleDay: "29th of the month",
                                                                                        nextRenewalDate: "2020-07-29",
                                                                                        id: "a1Ff0000001hp33EAA")))
        
        XCTAssertNotNil(viewModel.subscriptionRepository.invoice.onNext(Invoice(id: "748363", paymentName: "Modem", planName: "Discussed", planPrice: "756211", salesTaxAmount: 344.4, totalCost: 678.8, processedDate: "29/12/20", billingAddress: "Washington", email: "biwf@test.com", promoCode: "86730938", promoCodeValue: 0, promoCodeDescription: nil)))
        
        XCTAssertNotNil(viewModel.subscriptionRepository.cancellationStatusResult.onNext(CancelSubscription(contactID: "003q0000018bdWpAAI",
                                                                                                            cancellationReason: "Reliability or Speed",
                                                                                                            cancellationComment: "Reliability or Speed",
                                                                                                            rating: "5",
                                                                                                            recordTypeID: "012f0000000l1hsAAA",
                                                                                                            cancellationDate: "2020-05-14T14:08:41.000+0000",
                                                                                                            caseID: "",
                                                                                                            status: true)))
        
        
        XCTAssertNotNil(viewModel.subscriptionRepository.recordIDResult.onNext("test"))
        
    }
    
    func testErrorResponse() {
        let viewModel = SubscriptionViewModel(with: subscription,
                                              repository: SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager()))
        
        XCTAssertNotNil(viewModel.subscriptionRepository.errorMessage.onNext("Error occured"))
        XCTAssertNotNil(viewModel.subscriptionRepository.errorMessagePaymentInfo.onNext("Error occured"))
    }
}
