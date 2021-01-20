//
//  FAQTopicsViewControllerTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 17/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF
/**
 Executes unit test cases for the FAQTopicsViewControllerTest
 */
class FAQTopicsViewControllerTest: XCTestCase {

    // instance for FAQTopicsViewController
    var faqTopicsViewController: FAQTopicsViewController?

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Support", bundle: nil)
        faqTopicsViewController = storyboard.instantiateViewController(withIdentifier: "FAQTopicsViewController")
            as? FAQTopicsViewController
         let viewModel = FAQTopicsViewModel(withRepository: SupportRepository(supportServiceManager: MockSupportServiceManager()),
               faqTopics: [FaqRecord(attributes: FaqRecordAttributes(type: "Modem", url: "https://app.zeplin.io/project/5e727d8f615283b2933b424c"), articleNumber: "86730938", articleTotalViewCount: 7, articleContent: "Discussed", articleUrl:  "https://app.zeplin.io/project/5e727d8f615283b2933b424c", Id: "756211", language: "English", sectionC: "", title: "Faq", isAnswerExpanded: true)])
        faqTopicsViewController?.setViewModel(to: viewModel)
        _ = faqTopicsViewController?.view
        faqTopicsViewController?.viewWillAppear(true)
        faqTopicsViewController?.viewDidLayoutSubviews()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        faqTopicsViewController = nil
    }

    // tests if faqTopicsViewController initialized
    func testSanity() {
        XCTAssertNotNil(faqTopicsViewController)
    }

    func testHeightForHeaderInSection() {
        if let tableView = faqTopicsViewController?.tableView {
            XCTAssertEqual(faqTopicsViewController?.tableView(tableView, heightForHeaderInSection: 0), Constants.FAQTopics.faqHeaderViewCellHeight)
            XCTAssertEqual(faqTopicsViewController?.tableView(tableView, heightForHeaderInSection: 1), Constants.FAQTopics.cantFindAnswerHeaderCellHeight)
        }
    }
    
    func testViewForHeaderInSection() {
        if let tableView = faqTopicsViewController?.tableView {
            XCTAssertNotNil(faqTopicsViewController?.tableView(tableView, viewForHeaderInSection: 0))
            
            var headerView = faqTopicsViewController?.tableView(tableView, viewForHeaderInSection: 0) as! TitleHeaderview
            XCTAssertNotNil(headerView.setViewModel(to: TitleHeaderViewModel(title: Constants.Support.faqTopics,
                                                                             hideTopSeperator: false,
                                                                             hideBottomSeperator: false)))
        }
    }
    
    func testTableViewCell() {
         if let tableView = faqTopicsViewController?.tableView {
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = faqTopicsViewController?.tableView(tableView, cellForRowAt: indexPath)
            XCTAssertNotNil(cell)

            let contactUsCell = faqTopicsViewController?.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1))
            XCTAssertNotNil(contactUsCell)

         }
     }
    
    func testSuscriber() {
        let viewModel = FAQTopicsViewModel(withRepository: SupportRepository(supportServiceManager: MockSupportServiceManager()),
              faqTopics: [FaqRecord]())

        viewModel.reloadDataSubject.onNext(Void())
    }
    
    func testCellButtonTapEvent() {
        if let tableView = faqTopicsViewController?.tableView {
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = (faqTopicsViewController?.tableView(tableView, cellForRowAt: indexPath)) as! FAQQuestionsCell
            XCTAssertNotNil(cell.prepareForReuse())
            XCTAssertNotNil(cell.expandCellButton.sendActions(for: UIControl.Event.touchUpInside))
            
        }
    }
}
