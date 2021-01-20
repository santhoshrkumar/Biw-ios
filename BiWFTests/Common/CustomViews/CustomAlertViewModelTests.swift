//
//  CustomAlertViewModelTests.swift
//  BiWFTests
//
//  Created by shriram.narayan.bhat on 12/11/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
//import RxBlocking

@testable import BiWF

class CustomAlertViewModelTests: XCTestCase {
    var subject: CustomAlertViewModel!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()

        subject = CustomAlertViewModel(
            withTitle: "AlertTitle",
            message: "AlertMessage".attributedString(),
            buttonTitleText: "Close",
            isPresentedFromWindow: false
        )
    }
/*
    func testCustomAlert() throws {

        XCTAssertEqual(try subject.output.titleTextDriver.toBlocking().first(), "AlertTitle")
        XCTAssertEqual(try subject.output.messageTextDriver.toBlocking().first(), "AlertMessage".attributedString())
        XCTAssertEqual(try subject.output.buttonTitleTextDriver.toBlocking().first(), "Close")
        XCTAssertEqual(subject.isPresentedFromWindow, false)
    }*/

    func testAlertDismiss() {
        var buttonTapReceived = false
        let buttonTap = PublishSubject<Void>()

        buttonTap
            .bind(to: subject.input.closeButtonTapObserver)
            .disposed(by: disposeBag)

        subject.dismissSubject.subscribe(onNext: { _ in
            buttonTapReceived = true
            XCTAssertTrue(buttonTapReceived)
        }).disposed(by: disposeBag)

        buttonTap.onNext(())
    }
}
