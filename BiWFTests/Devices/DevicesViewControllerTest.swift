//
//  DevicesViewControllerTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 20/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class DevicesViewControllerTest: XCTestCase {
    
    var devicesViewController : DevicesViewController?
    override func setUp() {
        let storyboard = UIStoryboard(name: "Device", bundle: nil)
        devicesViewController = storyboard.instantiateViewController(withIdentifier: "DevicesViewController")
            as? DevicesViewController
        let viewModel = DevicesViewModel(withRepository: DeviceRepository(), networkRepository: NetworkRepository())
        devicesViewController?.setViewModel(to: viewModel)
        devicesViewController?.viewWillAppear(true)
    }
    
    override func tearDown() {
        super.tearDown()
        devicesViewController = nil
    }
    
    func testSanity() {
        XCTAssertNotNil(devicesViewController)
        devicesViewController?.refreshHandler?.refresh.onNext(())
        devicesViewController?.viewModel.endRefreshing.onNext(true)
    }
    
    func testShowRemoveDeviceAlert() {
        XCTAssertNotNil(DevicesViewController.dataSource())
    }
    
    func testShowValidationAlert() {
        XCTAssertNotNil(devicesViewController?.showLoaderView(with: Constants.Common.loading))
    }
    
    func testHeightForHeaderInSection() {
        if let tableView = devicesViewController?.tableView {
            XCTAssertEqual(devicesViewController?.tableView(tableView, heightForHeaderInSection: 0), Constants.Device.connectedDeviceHeaderHeight)
            XCTAssertEqual(devicesViewController?.tableView(tableView, heightForHeaderInSection: 1), Constants.Device.removedDeviceHeaderHeight)
        }
    }
    
    func testHeightForRowAtSection() {
        if let tableView = devicesViewController?.tableView {
            let indexPath = IndexPath(row: 0, section: 0)
            XCTAssertEqual(devicesViewController?.tableView(tableView, heightForRowAt: indexPath),
                           Constants.Device.cellHeight)
        }
    }
}
