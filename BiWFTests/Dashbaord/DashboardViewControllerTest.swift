//
//  DashboardViewControllerTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 20/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class DashboardViewControllerTest: XCTestCase {

    var dashboardViewController : DashboardViewController?
    let viewModel = DashboardViewModel(commonDashboardViewModel: CommonDashboardViewModel(with: AppointmentRepository()), notificationRepository: NotificationRepository(), networkRepository: NetworkRepository(), deviceRepository: DeviceRepository())
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "DashboardViewController", bundle: nil)
        dashboardViewController = storyboard.instantiateViewController(withIdentifier: "DashboardViewController")
            as? DashboardViewController
        _ = dashboardViewController?.view
        
        dashboardViewController?.setViewModel(to: viewModel)
        dashboardViewController?.viewWillAppear(true)
    }
    
    override func tearDown() {
           super.tearDown()
        dashboardViewController = nil
       }
    
    func testSanity() {
        XCTAssertNotNil(dashboardViewController)
    }
    
    func testshowLoaderView() {
        XCTAssertNotNil(dashboardViewController?.showLoaderView())
    }
    
    func testCreationDataSource() {
        XCTAssertNotNil(dashboardViewController?.dataSource())
    }
    
    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertNotNil(dashboardViewController?.conforms(to: UITableViewDelegate.self))
    }
}
