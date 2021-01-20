//
//  CancelSubscriptionViewControllerTest.swift
//  BiWFTests
//
//  Created by pooja.q.gupta on 17/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class CancelSubscriptionViewControllerTest: XCTestCase {
    
    var cancelsubscriptionViewController: CancelSubscriptionViewController?
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
        cancelsubscriptionViewController = storyboard.instantiateViewController(withIdentifier: "CancelSubscriptionViewController")
            as? CancelSubscriptionViewController
        _ = cancelsubscriptionViewController?.view
        let account = Account.init(accountId: "001q000001HdaIEAAZ",
                                   name: "Client",
                                   firstName: "Client",
                                   billingAddress: BillingAddress.init(street: "1234 Main St",
                                                                       city: "Denver",
                                                                       state: "CO",
                                                                       postalCode: "77731"),
                                   marketingEmailOptIn: true,
                                   marketingCallOptIn: true,
                                   cellPhoneOptIn: true,
                                   productName: "Fiber Gigabit",
                                   productPlanName: "Best in world fiber",
                                   email: "nick@centurylink.com",
                                   lineId: "0101100408",
                                   serviceCity: "Denver",
                                   servicrCountry: "CO",
                                   serviceState: "CO",
                                   serviceStreet: "1234 Main St",
                                   serviceZipCode: "77731",
                                   serviceUnit: "CO",
                                   nextPaymentDate: "2020-07-29")
        
        let viewModel = CancelSubscriptionViewModel.init(withAccount: account, subscriptionRepository: SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager()))
        cancelsubscriptionViewController?.setViewModel(to: viewModel)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        cancelsubscriptionViewController = nil
    }
    
    func testSanity() {
        XCTAssertNotNil(cancelsubscriptionViewController)
    }
    
    func testValidDate() {
        cancelsubscriptionViewController?.cancellationDateView.textField.text = "22/03/2020"
        let result = cancelsubscriptionViewController?.isValidDate()
        let expectedResult = true
        XCTAssertEqual(result, expectedResult)
    }
    
    func testTextFieldsShouldBeginEditing() {
        if let textField = cancelsubscriptionViewController?.cancellationDateView.textField {
           let isEditable = cancelsubscriptionViewController?.textFieldShouldBeginEditing(textField)
           let expectedResult = true
            XCTAssertEqual(isEditable, expectedResult)
        }
    }
    
    func testShowValidationError() {
        XCTAssertNotNil(cancelsubscriptionViewController?.showValidationError(true))
        XCTAssertEqual(cancelsubscriptionViewController?.constraintErrorLabelTop.constant, Constants.CancelSubscription.errorLabelTopSpace)
        
        XCTAssertNotNil(cancelsubscriptionViewController?.showValidationError(false))
        XCTAssertEqual(cancelsubscriptionViewController?.constraintErrorLabelTop.constant, 0)

    }
    
    func testHideCancellationReasonView() {
        XCTAssertNotNil(cancelsubscriptionViewController?.hideCancellationReasonView(true))
    }
    
    func testShowCancellationReasonView() {
        XCTAssertNotNil(cancelsubscriptionViewController?.hideCancellationReasonView(false))
    }

    func testHideValidationError() {
           XCTAssertNotNil(cancelsubscriptionViewController?.showValidationError(false))
       }
    
    func testShowConfirmationAlert() {
        XCTAssertNotNil(cancelsubscriptionViewController?.showConfirmationAlert())
        cancelsubscriptionViewController?.viewModel.keepServiceTapSubject.onNext(())
    }
}
