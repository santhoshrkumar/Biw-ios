//
//  AccountViewModelTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 15/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class AccountViewModelTest: XCTestCase {

    let disposeBag = DisposeBag()
    var viewModel: AccountViewModel?
    let accountManager = MockAccountServiceManager()
    let subscriptionManager = MockSubscriptionServiceManager()
    
    // intial setup before every unit test case
    override func setUp() {
        super.setUp()
        viewModel = AccountViewModel(
            withRepository: AccountRepository(accountServiceManager: accountManager),
            subscriptionRepository: SubscriptionRepository(subscriptionServiceManager: subscriptionManager)
        )
        viewModel?.account = accountManager.getAccountDetails()
        viewModel?.paymentInfo = subscriptionManager.mockPaymentInfo()
        viewModel?.fiberPlanInfo = subscriptionManager.mockFiberPlanInfo()
        viewModel?.setSections()
    }

    func testGoToSubscriptionEvent() {
        let testExpectation = expectation(description: "Open subscription screen")
        viewModel?.output.viewComplete.subscribe(onNext: { event in
                guard case .goToSubscription = event else {
                    XCTFail()
                    return
                }
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        viewModel?.input.cellSelectionObserver.onNext(IndexPath(row: AccountViewModel.CardType.subscription.rawValue, section: 0))
        wait(for: [testExpectation], timeout: 5)
    }

    func testGoToPersonalInfoEvent() {
        let testExpectation = expectation(description: "Open Personal Info screen")
        viewModel?.output.viewComplete.subscribe(onNext: { event in
                guard case .goToPersonalInfo = event else {
                    XCTFail()
                    return
                }
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        viewModel?.input.cellSelectionObserver.onNext(IndexPath(row: AccountViewModel.CardType.personalInfo.rawValue, section: 0))
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testSection() {
        let testExpectation = expectation(description: "Receive sections from view model")
        viewModel?.sections.subscribe(onNext: { sections in
                if !sections.isEmpty {
                    testExpectation.fulfill()
                }
            }).disposed(by: disposeBag)

         wait(for: [testExpectation], timeout: 5)
    }

    func testLogoutEvent() {
        let testExpectation = expectation(description: "Receive event to logout")
        viewModel?.output.viewComplete.subscribe(onNext: { event in
                guard case .logout = event else {
                    XCTFail()
                    return
                }
                testExpectation.fulfill()
            }).disposed(by: disposeBag)

        viewModel?.logoutSuccessSubject.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testGetAccountInformation() {
        XCTAssertNotNil(viewModel?.getAccountInformation(forAccountId: viewModel?.account?.accountId ?? ""))
    }
    
    func testUpdateContactInformation() {
        XCTAssertNotNil(viewModel?.updateContactNumber())
    }
    
    func testGetPaymentInformation() {
        XCTAssertNotNil(viewModel?.getPaymentInformation(forAccountId: viewModel?.account?.accountId ?? ""))
    }
    
    func testGetContactInformation() {
        XCTAssertNotNil(viewModel?.getContactInformation(forContactId: viewModel?.account?.accountId ?? ""))
    }
    
    func testGetLogoutUser() {
        XCTAssertNotNil(viewModel?.getLogoutUser())
    }
    
    func testUpdateAccount() {
        XCTAssertNotNil(viewModel?.updateAccount(forAccountDetails:(viewModel?.account!)!))
        viewModel?.repository.accountPreferenceDetailsUpdate.onNext(true)
        viewModel?.repository.errorMessageAccountPreference.onNext("No Error")
    }
    
    func testUpdateContacts() {
        XCTAssertNotNil(viewModel?.updateContacts(forContactDetails: Contact(contactId: "1", marketingEmailOptIn: true, marketingCallOptIn: true, cellPhoneOptIn: false, mobileNumber: "1111111111"), account: (viewModel?.account!)!))
        viewModel?.repository.contactPreferenceDetailsUpdate.onNext(true)
        
    }
    
    func testShowAlert() {
        XCTAssertNotNil(viewModel?.showAlert(withMessage: Constants.Biometric.alertTitleError))
    }
    
    func testUpdateValues() {
        XCTAssertNotNil(viewModel?.updateValues(toggle: true, toggleType: AccountViewModel.ToggleType.serviceCall))
    }
}
