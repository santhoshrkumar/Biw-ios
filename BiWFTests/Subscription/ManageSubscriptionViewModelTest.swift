//
//  ManageSubscriptionViewModelTest.swift
//  BiWFTests
//
//  Created by pooja.q.gupta on 17/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class ManageSubscriptionViewModelTest: XCTestCase {
    
    private let disposeBag = DisposeBag()
    
    func testCancelEvent() {
        let testExpectation = expectation(description: "Receive event to close manage subscription view")
        let manager = MockAccountServiceManager()
        let viewModel = ManageSubscriptionViewModel(withAccount: manager.getAccountDetails())
        
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goBackToAccount = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.cancelTapObserver.onNext(Void())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testBackEvent() {
        let testExpectation = expectation(description: "Receive event to back from manage subscription")
        let manager = MockAccountServiceManager()
        let viewModel = ManageSubscriptionViewModel(withAccount: manager.getAccountDetails())
        
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
    
    func testContinueEvent() {
         let testExpectation = expectation(description: "Receive event to continue cancellation")
               let manager = MockAccountServiceManager()
               let viewModel = ManageSubscriptionViewModel(withAccount: manager.getAccountDetails())
               
               viewModel.output.viewComplete.subscribe(onNext: { event in
                guard case .goToCancelSubscription = event else {
                       XCTFail()
                       return
                   }
                   testExpectation.fulfill()
               }).disposed(by: disposeBag)
               
               viewModel.input.continueTapObserver.onNext(Void())
               wait(for: [testExpectation], timeout: 5)
    }
}
