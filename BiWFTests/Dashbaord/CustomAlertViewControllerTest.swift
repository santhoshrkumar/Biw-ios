//
//  CustomAlertViewControllerTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 29/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class CustomAlertViewControllerTest: XCTestCase {

    let disposeBag = DisposeBag()
    var customAlertViewController: CustomAlertViewController?
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "AccountViewController", bundle: nil)
        customAlertViewController = storyboard.instantiateViewController(withIdentifier: "CustomAlertViewController") as? CustomAlertViewController
        
        let viewModel = CustomAlertViewModel(withTitle: Constants.PersonalInformation.title,
                                             message: NSAttributedString(string: Constants.PersonalInformation.message),
                                             buttonTitleText: Constants.PersonalInformation.buttonText,
                                             isPresentedFromWindow: false)
        customAlertViewController?.setViewModel(to: viewModel)
        XCTAssertNotNil(customAlertViewController?.view)
        
        let viewModel2 = CustomAlertViewModel(withTitle: Constants.PersonalInformation.title,
                                             message: NSAttributedString(string: Constants.PersonalInformation.message),
                                             buttonTitleText: Constants.PersonalInformation.buttonText,
                                             isPresentedFromWindow: true)
        customAlertViewController?.setViewModel(to: viewModel2)
        XCTAssertNotNil(customAlertViewController?.view)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        customAlertViewController = nil
    }
    
    func testSanity() {
        XCTAssertNotNil(customAlertViewController)
    }
    
    func testButtonEvent() {
        let testExpectation = expectation(description: "Dismiss custom alert view")
        let viewModel = CustomAlertViewModel(withTitle: Constants.PersonalInformation.title,
                                             message: NSAttributedString(string: Constants.PersonalInformation.message),
                                             buttonTitleText: Constants.PersonalInformation.buttonText,
                                             isPresentedFromWindow: false)
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .goBackToPersonalInfo = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.buttonTapObserver.onNext(Void())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testDismissEvent() {
        let testExpectation = expectation(description: "Dismiss custom alert view")
        let viewModel = CustomAlertViewModel(withTitle: Constants.PersonalInformation.title,
                                             message: NSAttributedString(string: Constants.PersonalInformation.message),
                                             buttonTitleText: Constants.PersonalInformation.buttonText,
                                             isPresentedFromWindow: true)
        
        viewModel.output.viewCompleteForDashboardCoordinator.subscribe(onNext: { event in
            guard case DashboardCoordinator.Event.dismissAlert = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        viewModel.input.buttonTapObserver.onNext(Void())
        wait(for: [testExpectation], timeout: 5)
    }
    
}
