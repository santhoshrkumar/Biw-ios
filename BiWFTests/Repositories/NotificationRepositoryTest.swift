//
//  NotificationRepositoryTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 16/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class NotificationRepositoryTest: XCTestCase {

    var notificationRepository = NotificationRepository()

    func testGetNotificationInfo(){
       XCTAssertNotNil(notificationRepository.getNotifications())
    }
}
