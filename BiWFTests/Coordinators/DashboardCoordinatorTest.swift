//
//  DashboardCoordinatorTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 14/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
@testable import BiWF

class DashboardCoordinatorTest: XCTestCase {

    var dashboardCoordinator: DashboardCoordinator?

    func testInitialisationEvent() {
        dashboardCoordinator = DashboardCoordinator.init(navigationController: UINavigationController(),
                                                         appointmentRepository: AppointmentRepository(),
                                                         networkRepository: NetworkRepository(),
                                                         deviceRepository: DeviceRepository())
        dashboardCoordinator?.start()
    }
}
