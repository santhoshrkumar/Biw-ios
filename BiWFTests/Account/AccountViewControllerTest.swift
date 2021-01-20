//
//  AccountViewControllerTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 17/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF
/**
 Executes unit test cases for the AccountViewController
 */
class AccountViewControllerTest: XCTestCase {

    // instance for AccountViewController
    var accountViewController: AccountViewController?

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "AccountViewController", bundle: nil)
        accountViewController = storyboard.instantiateViewController(withIdentifier: "AccountViewController")
            as? AccountViewController
        _ = accountViewController?.view
        let viewModel = AccountViewModel(
            withRepository: AccountRepository(accountServiceManager: MockAccountServiceManager()), subscriptionRepository: SubscriptionRepository()
        )
        accountViewController?.setViewModel(to: viewModel)
        accountViewController?.viewWillAppear(true)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        accountViewController = nil
    }

    // tests if AccountViewController initialized
    func testSanity() {
        XCTAssertNotNil(accountViewController)
    }
    
    // tests for testTableViewRowHeight
    func testTableViewRowHeight() {
        if let tableView = accountViewController?.tableView {
            var indexPath = IndexPath(row: 0, section: 0)
            XCTAssertEqual(accountViewController?.tableView(tableView, heightForRowAt: indexPath),
                           Constants.Account.accountInfoCellHeight)
            
           indexPath = IndexPath(row: 1, section: 0)
            XCTAssertEqual(accountViewController?.tableView(tableView, heightForRowAt: indexPath),
                           Constants.Account.paymentInfoCellHeight)
            
           indexPath = IndexPath(row: 2, section: 0)
            XCTAssertEqual(accountViewController?.tableView(tableView, heightForRowAt: indexPath),
                           Constants.Account.personalInfoCellHeight)
            
            indexPath = IndexPath(row: 3, section: 0)
            XCTAssertEqual(accountViewController?.tableView(tableView, heightForRowAt: indexPath),
                           Constants.Account.preferenceAndSettingsCellHeight)
            
            indexPath = IndexPath(row: 4, section: 0)
            XCTAssertEqual(accountViewController?.tableView(tableView, heightForRowAt: indexPath),
                           Constants.Account.logoutCellHeight)
            
            indexPath = IndexPath(row: 5, section: 0)
            XCTAssertEqual(accountViewController?.tableView(tableView, heightForRowAt: indexPath),
                           Constants.Account.accountInfoCellHeight)
        }
    }
}

