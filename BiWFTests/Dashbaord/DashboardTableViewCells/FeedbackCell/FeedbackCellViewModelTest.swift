//
//  FeedbackCellTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 19/11/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class FeedbackCellViewModelTest: XCTestCase {
    
    let disposeBag = DisposeBag()

    func testTitle() {
        let viewModel = FeedBackCellViewModel()
        viewModel.output.feedbackTitleDriver.asObservable().subscribe(onNext: { feedbackButtonTitle in
            XCTAssertEqual(feedbackButtonTitle, Constants.DashboardContainer.customerFeedBack)
            }).disposed(by: disposeBag)
        
    }
}
