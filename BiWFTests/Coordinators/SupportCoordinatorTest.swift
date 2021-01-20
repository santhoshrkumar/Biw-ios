//
//  SupportCoordinatorTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 14/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
@testable import BiWF

class SupportCoordinatorTest: XCTestCase {

    var supportCoordinator: SupportCoordinator?

    func testInitialisationEvent() {
        supportCoordinator = SupportCoordinator.init(navigationController: UINavigationController(),
                                                     networkRepository: NetworkRepository())
        supportCoordinator?.start()
    }
}
