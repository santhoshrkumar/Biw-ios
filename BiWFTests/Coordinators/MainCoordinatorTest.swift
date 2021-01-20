//
//  MainCoordinatorTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 14/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
@testable import BiWF

class MainCoordinatorTest: XCTestCase {

    var mainCoordinator: MainCoordinator?

    func testInitialisationEvent() {
        mainCoordinator = MainCoordinator.init(navigationController: UINavigationController())
        mainCoordinator?.start()
    }
}
