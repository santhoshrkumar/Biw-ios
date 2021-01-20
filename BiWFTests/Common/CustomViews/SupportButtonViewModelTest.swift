//
//  SupportButtonViewModelTest.swift
//  BiWFTests
//
//  Created by pooja.q.gupta on 17/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class SupportButtonViewModelTest: XCTestCase {
    let disposeBag = DisposeBag()
    
    func testGoToSupportEvent() {
        let testExpectation = expectation(description: "Recieve event go to support")
        let viewModel = SupportButtonViewModel.init()
        
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goToSupport = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.tapObserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
}
