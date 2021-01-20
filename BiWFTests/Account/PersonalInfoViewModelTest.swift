//
//  PersonalInfoViewModelTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 27/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class PersonalInfoViewModelTest: XCTestCase {

    let disposeBag = DisposeBag()
    let manager = MockAccountServiceManager()

    func testShowHowToChangeEmailAlertEvent() {
        let testExpectation = expectation(description: "Open alert to show procideure for chaging email")
        let viewModel = PersonalInfoViewModel(withRepository: AccountRepository(), accountInfo: manager.getAccountDetails())
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .showCustomAlert(Constants.PersonalInformation.title, NSMutableAttributedString()) = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        viewModel.openCustomAlertSubject.onNext((Constants.PersonalInformation.title, NSMutableAttributedString()))
        wait(for: [testExpectation], timeout: 5)
    }

    func testDoneEvent() {
        let testExpectation = expectation(description: "Done call Api and dismiss view")
        let viewModel = PersonalInfoViewModel(withRepository: AccountRepository(), accountInfo: manager.getAccountDetails())
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goBackToAccount = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.doneObserver.onNext(Void())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testIsValidPhone() {
        let viewModel = PersonalInfoViewModel(withRepository: AccountRepository(), accountInfo: manager.getAccountDetails())
        XCTAssertEqual(viewModel.isValidPhone(phone: "111@1"), false)
        XCTAssertEqual(viewModel.isValidPhone(phone: "1111111111"), true)
    }

    func testOpenCustomAlert() {
        let message = Constants.PersonalInformation.detail.attribStringWithNumber
        let title = Constants.PersonalInformation.title
        let viewModel = PersonalInfoViewModel(withRepository: AccountRepository(), accountInfo: manager.getAccountDetails())
        XCTAssertNotNil(viewModel.openCustomAlert(withMessage: message, title: title))
    }

}
