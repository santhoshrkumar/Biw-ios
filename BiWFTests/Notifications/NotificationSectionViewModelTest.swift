//
//  NotificationSectionViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 19/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class NotificationSectionViewModelTest: XCTestCase {

    let notification = Notification.init(id: 1, name: "Chris", description: "Account Subscription", imageUrl: "https://app.zeplin.io/project", isUnRead: true, detailUrl: "https://app.zeplin.io/project/5e727d8f615283b2933b424c/screen/5f7c6f6a7c6b5385582d142d")
    
    
    func testInitMethod() {
        let viewModel = NotificationSectionViewModel(withHeader: "NotificationSectionViewModel", buttonType: "Clear all", notificationItems: [notification])
        XCTAssertNotNil(viewModel)
    }
    
}
