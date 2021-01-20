//
//  LoginViewModelTests.swift
//  BiWFTests
//
//  Created by nicholas.a.klacik on 3/30/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class LoginViewModelTests: XCTestCase {

    let disposeBag = DisposeBag()
    let viewModel = LoginViewModel()

    func testGotoTabEvent() {
        let testExpectation = expectation(description: "Go to tab view")
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goToTabView = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.goToTabViewSubject.onNext(Void())
        wait(for: [testExpectation], timeout: 5)
    } 
    
    func testStateChanged() {
        XCTAssertNotNil(viewModel.stateChanged())
    }
    
    func testSaveState() {
        XCTAssertNotNil(viewModel.saveState())
    }
}
