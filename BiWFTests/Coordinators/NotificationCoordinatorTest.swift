//
//  NotificationCoordinatorTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 14/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
@testable import BiWF

class NotificationCoordinatorTest: XCTestCase {

    var notificationCoordinator: NotificationCoordinator?

    func testInitialisationEvent() {
        notificationCoordinator = NotificationCoordinator.init(navigationController: UINavigationController())
        notificationCoordinator?.start()
    }
}
