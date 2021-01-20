//
//  DeviceCoordinatorTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 14/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
@testable import BiWF

class DeviceCoordinatorTest: XCTestCase {

    var deviceCoordinator: DeviceCoordinator?

    func testInitialisationEvent() {
        deviceCoordinator = DeviceCoordinator.init(navigationController: UINavigationController(),
                                                   deviceRepository: DeviceRepository(),
                                                   networkRepository: NetworkRepository())
        deviceCoordinator?.start()
    }
}
