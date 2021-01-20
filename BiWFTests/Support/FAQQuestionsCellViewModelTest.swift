//
//  FAQQuestionsCellViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 16/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift

@testable import BiWF

class FAQQuestionsCellViewModelTest: XCTestCase {
    var subject: FAQQuestionsCellViewModel!
    var record: FaqRecord!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        let attributes = FaqRecordAttributes(type: "test", url: "https://fakedomain.com/fakeAttributeUrl")
        record = FaqRecord(
            attributes: attributes,
            articleNumber: "000001055",
            articleTotalViewCount: 10,
            articleContent: "Processor: Intel<span style=\"box-sizing: border-box;line-height: 16.1px;color: black;\">® </span>Core<span style=\"box-sizing: border-box;line-height: 16.1px;color: black;\">™ </span>i5-3320M CPU @ 2.60GHz (4 CPUs)",
            articleUrl: "https://fakedomain.com/fakeArticleUrl",
            Id: "ka0f00000005sGZAAY",
            language: "en_US",
            sectionC: "Installation & hardware",
            title: "What are the hardware recommendations for my connected devices?",
            isAnswerExpanded: true
        )
        subject = FAQQuestionsCellViewModel(withContent: record)

        disposeBag = DisposeBag()
    }

    override func tearDown() {
        super.tearDown()
        subject = nil
    }

    func testQuestion() {
        subject.question.asObservable().subscribe(onNext: { question in
            XCTAssertEqual(question, "What are the hardware recommendations for my connected devices?")
            }).disposed(by: disposeBag)
    }

    func testAnswer() {
        subject.answer.asObservable().subscribe(onNext: { [weak self] answer in
            let data = Data(self?.record.articleContent.utf8 ?? "".utf8)
            let expectedAnswer = try? NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )

            XCTAssertEqual(answer, expectedAnswer)
            }).disposed(by: disposeBag)
    }

    func testIsExpanded() {
        XCTAssertEqual(subject.isExpanded, true)
        
        record.isAnswerExpanded = false
        var viewModel = FAQQuestionsCellViewModel(withContent: record)
        XCTAssertEqual(viewModel.isExpanded, false)

        record.isAnswerExpanded = nil
        viewModel = FAQQuestionsCellViewModel(withContent: record)
        XCTAssertEqual(viewModel.isExpanded, false)
    }
}
