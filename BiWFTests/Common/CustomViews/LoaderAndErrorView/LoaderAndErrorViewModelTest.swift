//
//  LoaderAndErrorViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 22/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
//import RxTest
import RxSwift

@testable import BiWF

class LoaderAndErrorViewModelTests: XCTestCase {
    /*
    var subject: LoaderAndErrorViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        subject = LoaderAndErrorViewModel(with: "TestMessage")
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        super.tearDown()

        disposeBag = nil
        scheduler = nil
        subject = nil
    }
    
    func testShowingSubject() {
        let subjectObserver = scheduler.createObserver(Bool.self)

        subject.output.showLoaderObservable
            .bind(to: subjectObserver)
            .disposed(by: disposeBag)

        subject.input.showLoaderObserver.onNext(true)
        XCTAssertRecordedElements(subjectObserver.events, [true])

        subject.input.showLoaderObserver.onNext(false)
        XCTAssertRecordedElements(subjectObserver.events, [true, false])
    }

    func testOutput() {
        XCTAssertEqual(try subject.output.messageTextDriver.toBlocking().first(), "TestMessage")
    }*/
}

