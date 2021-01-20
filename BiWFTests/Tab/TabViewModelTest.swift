//
//  TabViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 20/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class TabViewModelTest: XCTestCase {

    let disposeBag = DisposeBag()

    func testGotoLogout() {
        let testExpectation = expectation(description: "Recieve event to logout")
        let viewModel = TabViewModel(appointmentRepository: AppointmentRepository(), networkRepository: NetworkRepository())
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goToLogout = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)

        viewModel.logoutSubject.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }

    func testCheckBiometricAuthSubject()  {
        let viewModel = TabViewModel(appointmentRepository: AppointmentRepository(), networkRepository: NetworkRepository())
        XCTAssertNotNil(viewModel.biometricTypeString)
        viewModel.checkBiometricAuthSubject.onNext(())
    }
}
