//
//  RatingViewModelTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 22/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
//import RxTest
import RxSwift

@testable import BiWF

class RatingViewModelTest: XCTestCase {
    /*
    var subject: RatingViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        subject = RatingViewModel(with: 5)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        super.tearDown()

        subject = nil
        disposeBag = nil
        scheduler = nil
    }
    
    func testRating() {
        let rating = 5
        let ratingObserver = scheduler.createObserver(Int.self)
        let updateRatingObserver = scheduler.createObserver(Int.self)

        subject.setRatingSubject
            .bind(to: ratingObserver)
            .disposed(by: disposeBag)
        
        subject.updateRatingSubject
        .bind(to: updateRatingObserver)
        .disposed(by: disposeBag)

        subject.setRatingSubject.onNext(rating)
        XCTAssertRecordedElements(ratingObserver.events, [5])

        subject.updateRatingSubject.onNext(3)
        XCTAssertRecordedElements(updateRatingObserver.events, [3])
    }*/
}
