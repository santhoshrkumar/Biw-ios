//
//  QRCodeViewControllerTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 20/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class QRCodeViewControllerTest: XCTestCase {

    var qrCodeViewController : QRCodeViewController?
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "DashboardViewController", bundle: nil)
        qrCodeViewController = storyboard.instantiateViewController(withIdentifier: "QRCodeViewController")
            as? QRCodeViewController
        _ = qrCodeViewController?.view
        let viewModel = QRCodeViewModel(wifiNetwork: WiFiNetwork(name: "Varun", password: "1234", isGuestNetwork: false))
        qrCodeViewController?.setViewModel(to: viewModel)
        qrCodeViewController?.viewWillAppear(true)
    }
    
    override func tearDown() {
           super.tearDown()
        qrCodeViewController = nil
       }
    
    func testSanity() {
        XCTAssertNotNil(qrCodeViewController)
    }
}
