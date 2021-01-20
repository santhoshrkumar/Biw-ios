//
//  SupportViewControllerTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 17/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF
/**
 Executes unit test cases for the SupportViewControllerTest
 */
class SupportViewControllerTest: XCTestCase {
    
    // instance for SupportViewController
    var supportViewController: SupportViewController?
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Support", bundle: nil)
        supportViewController = storyboard.instantiateViewController(withIdentifier: "SupportViewController")
            as? SupportViewController
        let viewModel = SupportViewModel(with: SupportRepository(), and: NetworkRepository())
        supportViewController?.setViewModel(to: viewModel)
        _ = supportViewController?.view
        supportViewController?.viewWillAppear(true)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        supportViewController = nil
    }
    
    // tests if SupportViewController initialized
    func testSanity() {
        XCTAssertNotNil(supportViewController)
    }
    
    // tests for testTableViewRowHeight
    func testTableViewRowHeight() {
        if let tableView = supportViewController?.tableView {
            
            var indexPath = IndexPath(row: 0, section: 0)
            XCTAssertEqual(supportViewController?.tableView(tableView, heightForRowAt: indexPath),
                           Constants.Support.faqCellHeight)
            
            indexPath = IndexPath(row: 0, section: 1)
            XCTAssertEqual(supportViewController?.tableView(tableView, heightForRowAt: indexPath),
                           Constants.Support.restartModemCellHeight)
            
            indexPath = IndexPath(row: 0, section: 2)
            XCTAssertEqual(supportViewController?.tableView(tableView, heightForRowAt: indexPath),
                           Constants.Support.contactUsCellHeight)
            
            indexPath = IndexPath(row: 3, section: 3)
            XCTAssertEqual(supportViewController?.tableView(tableView, heightForRowAt: indexPath),
                           UITableView.automaticDimension)
        }
    }
    
    func testViewForHeaderInSection() {
        if let tableView = supportViewController?.tableView {
            XCTAssertNotNil(supportViewController?.tableView(tableView, viewForHeaderInSection: 0))
            
            var headerView = supportViewController?.tableView(tableView, viewForHeaderInSection: 0) as! TitleHeaderview
            XCTAssertNotNil(headerView.setViewModel(to: TitleHeaderViewModel(title: Constants.Support.faqTopics,
                                                                             hideTopSeperator: false,
                                                                             hideBottomSeperator: false)))
        }
    }
}


