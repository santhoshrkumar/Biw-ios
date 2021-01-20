//
//  LoginCoordinatorTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 14/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class LoginCoordinatorTest: XCTestCase {

    var loginCoordinator: LoginCoordinator?
    let disposeBag = DisposeBag()

    func testInitialisationEvent() {
        loginCoordinator = LoginCoordinator.init(navigationController: UINavigationController(),
                                                 accountRepository: AccountRepository())
        loginCoordinator?.start()
    }
    
    func testLogoutEvent() {
        let testExpectation = expectation(description: "Recieve event from logoutEventObservable after")
        let viewModel = LoginViewModel()
        viewModel.output.viewComplete.subscribe ({ (event) in
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        viewModel.goToTabViewSubject.onNext(Void())
        wait(for: [testExpectation], timeout: 5)
    }
}


