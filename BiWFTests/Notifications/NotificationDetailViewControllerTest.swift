//
//  NotificationDetailViewControllerTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 19/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class NotificationDetailViewControllerTest: XCTestCase {

    var notificationDetailViewController : NotificationDetailViewController?
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Notification", bundle: nil)
        notificationDetailViewController = storyboard.instantiateViewController(withIdentifier: "NotificationDetailViewController")
            as? NotificationDetailViewController
        _ = notificationDetailViewController?.view
        let viewModel = NotificationDetailViewModel(withDetailsUrl: "Account")
        notificationDetailViewController?.setViewModel(to: viewModel)
        notificationDetailViewController?.viewWillAppear(true)
    }
    
    override func tearDown() {
           super.tearDown()
           notificationDetailViewController = nil
       }
    
    func testSanity() {
        XCTAssertNotNil(notificationDetailViewController)
    }
}
