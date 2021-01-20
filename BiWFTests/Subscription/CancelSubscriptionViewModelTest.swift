//
//  CancelSubscriptionViewModel.swift
//  BiWFTests
//
//  Created by pooja.q.gupta on 28/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class CancelSubscriptionViewModelTest: XCTestCase {
    let disposeBag = DisposeBag()
    let manager = MockAccountServiceManager()
    
    func testKeepServiceEvent() {
        
        let testExpectation = expectation(description: "Recieve event to keep service")
        let viewModel = CancelSubscriptionViewModel(withAccount: manager.getAccountDetails(), subscriptionRepository: SubscriptionRepository())
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goBackToAccount = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.keepServiceTapObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testCancelServiceEvent() {
        
        let testExpectation = expectation(description: "Recieve event to cancel service")
        let viewModel = CancelSubscriptionViewModel(withAccount: manager.getAccountDetails(), subscriptionRepository: SubscriptionRepository())
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goBackToAccount = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.cancellationSuccessSubject.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testBackEvent() {
        
        let testExpectation = expectation(description: "Recieve event to back to Tab view")
        let viewModel = CancelSubscriptionViewModel(withAccount: manager.getAccountDetails(), subscriptionRepository: SubscriptionRepository())
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goBack = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.backTapObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testCancelEvent() {
        
        let testExpectation = expectation(description: "Recieve event to cancel")
        let viewModel = CancelSubscriptionViewModel(withAccount: manager.getAccountDetails(), subscriptionRepository: SubscriptionRepository())
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goBackToAccount = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.cancelTapObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testErrorSavingChangesEvent() {
        
        let testExpectation = expectation(description: "Recieve event to error saving changes")
        let viewModel = CancelSubscriptionViewModel(withAccount: manager.getAccountDetails(), subscriptionRepository: SubscriptionRepository())
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .errorSavingChangesAlert = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.errorSavingChangesSubject.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testCancellationDateSelectionEvent() {
        let testExpectation = expectation(description: "Recieve event to select cancellation date")
        let manager = MockAccountServiceManager()        
        let viewModel = CancelSubscriptionViewModel(withAccount: manager.getAccountDetails(), subscriptionRepository: SubscriptionRepository())
        viewModel.output.cancellationDateObservable.subscribe(onNext: { date in
            
            if date != nil {
                testExpectation.fulfill()
            }
        }).disposed(by: disposeBag)
        
        viewModel.input.cancellationDateObserver.onNext((Date()))
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testCancelMySubscription() {
        let subscriptionRepository = SubscriptionRepository()
        let viewModel = CancelSubscriptionViewModel(withAccount: manager.getAccountDetails(), subscriptionRepository: subscriptionRepository)
        XCTAssertNotNil(viewModel.cancelMySubscription())
        XCTAssertNotNil(subscriptionRepository.recordIDResult.onNext("12345"))
        XCTAssertNotNil(subscriptionRepository.cancellationStatusResult.onNext(CancelSubscription(contactID: "003q0000018bdWpAAI",
                                                                                                  cancellationReason: "Reliability or Speed",
                                                                                                  cancellationComment: "Reliability or Speed",
                                                                                                  rating: "5",
                                                                                                  recordTypeID: "012f0000000l1hsAAA",
                                                                                                  cancellationDate: "2020-05-14T14:08:41.000+0000",
                                                                                                  caseID: "",
                                                                                                  status: true)))
        XCTAssertNotNil(subscriptionRepository.errorMessage.onNext("test error"))
    }
    
    func testCancelServiceTapSubject() {
        let viewModel = CancelSubscriptionViewModel(withAccount: manager.getAccountDetails(), subscriptionRepository: SubscriptionRepository())
        XCTAssertNotNil(viewModel.cancellationSuccessSubject.onNext(Void()))
        XCTAssertNotNil(viewModel.cancelServiceTapSubject.onNext(Void()))
    }
}
