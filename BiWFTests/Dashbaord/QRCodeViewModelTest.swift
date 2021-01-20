//
//  QRCodeViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 20/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class QRCodeViewModelTest: XCTestCase {
    
    let disposeBag = DisposeBag()

    func testGotoUserDashboard() {
        let testExpectation = expectation(description: "Go to user dashboard")
        let viewModel = QRCodeViewModel(wifiNetwork: WiFiNetwork(name: "Varun", password: "1234", isGuestNetwork: true))
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goBackToDashboard = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.doneTapObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
}
