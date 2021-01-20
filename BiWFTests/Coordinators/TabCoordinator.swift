//
//  TabCoordinator.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 14/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
@testable import BiWF

class TabCoordinatorTest: XCTestCase {

    var tabCoordinator: TabCoordinator?

    func testInitialisationEvent() {
        tabCoordinator = TabCoordinator.init(navigationController: UINavigationController())
        tabCoordinator?.start()
    }
}
