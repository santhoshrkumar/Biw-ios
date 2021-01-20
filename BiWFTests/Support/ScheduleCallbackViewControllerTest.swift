//
//  ScheduleCallbackViewControllerTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 17/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF
/**
 Executes unit test cases for the ScheduleCallbackViewControllerTest
 */
class ScheduleCallbackViewControllerTest: XCTestCase {

    // instance for ScheduleCallbackViewController
    var scheduleCallbackViewController: ScheduleCallbackViewController?

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Support", bundle: nil)
        scheduleCallbackViewController = storyboard.instantiateViewController(withIdentifier: "ScheduleCallbackViewController")
            as? ScheduleCallbackViewController
        let viewModel = ScheduleCallbackViewModel(with: SupportRepository())
        scheduleCallbackViewController?.setViewModel(to: viewModel)
        _ = scheduleCallbackViewController?.view
        scheduleCallbackViewController?.viewDidLayoutSubviews()
        scheduleCallbackViewController?.viewWillAppear(true)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        scheduleCallbackViewController = nil
    }

    // tests if scheduleCallbackViewController initialized
    func testSanity() {
        XCTAssertNotNil(scheduleCallbackViewController)
    }
    
    func testTableViewSectionHeight() {
        if let tableView = scheduleCallbackViewController?.tableView {
            var indexPath = IndexPath(row: 0, section: 0)
            XCTAssertEqual(scheduleCallbackViewController?.tableView(tableView, heightForHeaderInSection: indexPath.section),
                            UITableView.automaticDimension)
            
           indexPath = IndexPath(row: 0, section: 1)
            XCTAssertEqual(scheduleCallbackViewController?.tableView(tableView, heightForHeaderInSection: indexPath.section),
                           Constants.ScheduleCallback.callUsNowHeaderHeight)
            
        }
    }
}
