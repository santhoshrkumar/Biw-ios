//
//  NetworkInfoViewController.swift
//  BiWFTests
//
//  Created by Amruta Mali on 12/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class NetworkInfoViewControllerTest: XCTestCase {
    
    // instance for NetworkInfoViewController
    var networkInfoViewController: NetworkInfoViewController?
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "NetworkInfoViewController", bundle: nil)
        networkInfoViewController = storyboard.instantiateViewController(withIdentifier: "NetworkInfoViewController")
            as? NetworkInfoViewController
        _ = networkInfoViewController?.view
        let viewModel = NetworkInfoViewModel(with: WiFiNetwork(name: "test123", password: "1234", isGuestNetwork: false), guestNetwork: WiFiNetwork(name: "abc", password: "65432", isGuestNetwork: true), networkRepository: NetworkRepository(), and: ["abc":"xyz"])
        networkInfoViewController?.setViewModel(to: viewModel)
        networkInfoViewController?.viewWillAppear(true)
    }
    
    override func tearDown() {
        super.tearDown()
        networkInfoViewController = nil
    }
    
    // tests if personalInfoViewController initialized
    func testSanity() {
        XCTAssertNotNil(networkInfoViewController)
    }
    
    func testTableViewSectionHeight() {
        XCTAssertNotNil(networkInfoViewController?.dataSource())
    }

}
