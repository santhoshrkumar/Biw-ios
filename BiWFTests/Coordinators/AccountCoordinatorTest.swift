//
//  AccountCoordinatorTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 14/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class AccountCoordinatorTest: XCTestCase {

    var accountCoordinator: AccountCoordinator?

    func testInitialisationEvent() {
        accountCoordinator = AccountCoordinator.init(navigationController: UINavigationController())
        accountCoordinator?.start()
    }
}

