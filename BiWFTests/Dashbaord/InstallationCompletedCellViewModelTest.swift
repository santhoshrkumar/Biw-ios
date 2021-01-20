//
//  InstallationCompletedCellViewModelTest.swift
//  BiWFTests
//
//  Created by pooja.q.gupta on 15/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class InstallationCompletedCellViewModelTest: XCTestCase {
    
    let disposeBag = DisposeBag()
    
    func testGetStartedEvent() {
        let testExpectation = expectation(description: "Receive event to get started")
        let viewModel = InstallationCompletedCellViewModel(appointmentType: .service)
        
        viewModel.output.getStartedObservable.subscribe(onNext: { _ in
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.getStartedTappedObvserver.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
}
