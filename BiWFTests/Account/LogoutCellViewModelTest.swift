//
//  LogoutCellViewModelTest.swift
//  BiWFTests
//
//  Created by nicholas.a.klacik on 5/11/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class LogoutCellViewModelTest: XCTestCase {

    let disposeBag = DisposeBag()

    func testLogoutEvent() {
        let testExpectation = expectation(description: "Recieve event from logoutEventObservable after")
        let viewModel = LogoutCellViewModel()
        viewModel.output.logoutEventObservable.subscribe(onNext: { _ in
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        viewModel.input.logoutTapObserver.onNext(())

        wait(for: [testExpectation], timeout: 5)
    }
}
