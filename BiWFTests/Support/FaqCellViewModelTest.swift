//
//  FaqCellViewModelTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 20/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class FaqCellViewModelTest: XCTestCase {

    func testInitMethod() {
        let viewModel = FAQQuestionsCellViewModel(withContent: FaqRecord(attributes: FaqRecordAttributes(type: "Modem", url: "https://app.zeplin.io/project/5e727d8f615283b2933b424c"), articleNumber: "86730938", articleTotalViewCount: 7, articleContent: "Discussed", articleUrl:  "https://app.zeplin.io/project/5e727d8f615283b2933b424c", Id: "756211", language: "English", sectionC: "", title: "Faq", isAnswerExpanded: true))
        XCTAssertNotNil(viewModel)
    }

}
