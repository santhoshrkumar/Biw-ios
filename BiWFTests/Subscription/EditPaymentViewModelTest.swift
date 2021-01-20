//
//  EditPaymentViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 16/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class EditPaymentViewModelTest: XCTestCase {

    let disposeBag = DisposeBag()
    
    func testBackEvent() {
         
         let testExpectation = expectation(description: "Recieve event to back to payment")
         let viewModel = EditPaymentViewModel()
         viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .popEditPayment = event else {
                 XCTFail()
                 return
             }
             testExpectation.fulfill()
         }).disposed(by: disposeBag)
         
        viewModel.input.backTappedObserver.onNext(())
         wait(for: [testExpectation], timeout: 5)
     }

    func testDoneEvent() {
         
         let testExpectation = expectation(description: "Recieve event to back to Tab view")
         let viewModel = EditPaymentViewModel()
         viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goBackToAccount = event else {
                 XCTFail()
                 return
             }
             testExpectation.fulfill()
         }).disposed(by: disposeBag)
         
        viewModel.input.doneTappedObserver.onNext(())
         wait(for: [testExpectation], timeout: 5)
     }
}
