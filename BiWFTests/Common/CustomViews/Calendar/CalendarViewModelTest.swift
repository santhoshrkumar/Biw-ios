//
//  CalendarViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 22/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
//import RxTest

@testable import BiWF

class CalendarViewModelTests: XCTestCase {
    /*
    var subject: CalendarViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        let dates = ["2020-10-22 15:22:27.166"]
        subject = CalendarViewModel(with: dates)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    func testSelectedDateObservable() {
        let date = Date()
        let dateObserver = scheduler.createObserver(Date.self)

        subject.output.selectedDateObservable
            .bind(to: dateObserver)
            .disposed(by: disposeBag)

        subject.input.selectedDateObserver.onNext(date)

        XCTAssertRecordedElements(dateObserver.events, [date])
    }

    func testAvailableDatesDriver() {
        XCTAssertEqual(try subject.output.availableDatesDriver.toBlocking().first(), ["2020-10-22 15:22:27.166"])
    }*/
}
