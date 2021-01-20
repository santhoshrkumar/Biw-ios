//
//  PersonalInfoViewControllerTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 17/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF
/**
 Executes unit test cases for the PersonalInfoViewController
 */
class PersonalInfoViewControllerTest: XCTestCase {
    
    // instance for PersonalInfoViewController
    var personalInfoViewController: PersonalInfoViewController?
    let manager = MockAccountServiceManager()

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "AccountViewController", bundle: nil)
        personalInfoViewController = storyboard.instantiateViewController(withIdentifier: "PersonalInfoViewController")
            as? PersonalInfoViewController
        _ = personalInfoViewController?.view
        let viewModel = PersonalInfoViewModel(withRepository: AccountRepository(), accountInfo: manager.getAccountDetails())
        personalInfoViewController?.setViewModel(to: viewModel)
        personalInfoViewController?.viewWillAppear(true)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        personalInfoViewController = nil
    }
    
    // tests if personalInfoViewController initialized
    func testSanity() {
        XCTAssertNotNil(personalInfoViewController)
    }
    
    // tests for validateFields
    func testValidateFields() {
        personalInfoViewController?.viewModel.input.confirmPasswordObserver.onNext("123456")
        personalInfoViewController?.viewModel.input.passwordObserver.onNext("123456")
        personalInfoViewController?.viewModel.input.moblieNumberObserver.onNext("1234567890")
        personalInfoViewController?.viewModel.input.doneObserver.onNext(())
        let result = personalInfoViewController?.validateFields()
        let expectedResult = false
        XCTAssertEqual(result, expectedResult)
    }
    
    func testUpdateSecurityText() {
        if let confirmPasswordTextField = personalInfoViewController?.confirmPasswordView.textField {
            personalInfoViewController?.updateSecurityText(forTextField: confirmPasswordTextField)
            let result = confirmPasswordTextField.isSecureTextEntry
            let expectedResult = false
            XCTAssertEqual(result, expectedResult)
        }
    }
    
    func testTextFieldsShouldBeginEditing() {
        if let confirmPasswordTextField = personalInfoViewController?.confirmPasswordView.textField {
           let isEditable = personalInfoViewController?.textFieldShouldBeginEditing(confirmPasswordTextField)
           let expectedResult = true
            XCTAssertEqual(isEditable, expectedResult)
        }
        if let emailViewTextField = personalInfoViewController?.emailView.textField {
            emailViewTextField.tag = PersonalInfoViewController.TextFieldType.email.rawValue
           let isEditable = personalInfoViewController?.textFieldShouldBeginEditing(emailViewTextField)
           let expectedResult = false
            XCTAssertEqual(isEditable, expectedResult)
        }
    }
    
    func testTextFieldsShouldReturn() {
        if let confirmPasswordTextField = personalInfoViewController?.confirmPasswordView.textField {
           let isEditable = personalInfoViewController?.textFieldShouldReturn(confirmPasswordTextField)
           let expectedResult = true
           XCTAssertEqual(isEditable, expectedResult)
        }
    }
    
    func testButtonTapEvent() {
        XCTAssertNotNil(personalInfoViewController?.emailView.rightButton?.sendActions(for: .touchUpInside))
        XCTAssertNotNil(personalInfoViewController?.passwordView.rightButton?.sendActions(for: .touchUpInside))

        XCTAssertNotNil(personalInfoViewController?.confirmPasswordView.rightButton?.sendActions(for: .touchUpInside))

    }
    
    func testTextFieldDelegateMethod() {
        personalInfoViewController?.loadViewIfNeeded()
        let field = personalInfoViewController?.confirmPasswordView.textField ?? UITextField ()
        field.tag = (PersonalInfoViewController.TextFieldType.mobile).rawValue
        field.text = "1234567890"
        XCTAssertNotNil(field.delegate?.textFieldDidChangeSelection?(field))
        
    }
    
    func testMobileTextFieldShouldReturn() {
        personalInfoViewController?.loadViewIfNeeded()
        let field = personalInfoViewController?.confirmPasswordView.textField ?? UITextField ()
        field.tag = (PersonalInfoViewController.TextFieldType.confirmPassword).rawValue
        let result = field.delegate?.textFieldShouldReturn?(field)
        XCTAssertEqual(result, true)
        
        field.tag = (PersonalInfoViewController.TextFieldType.password).rawValue
        let result2 = field.delegate?.textFieldShouldReturn?(field)
        XCTAssertEqual(result2, true)
    }
    
    func testIsValidPhone() {
        let viewModel = PersonalInfoViewModel(withRepository: AccountRepository(), accountInfo: manager.getAccountDetails())
        XCTAssertFalse(viewModel.isValidPhone(phone: "12345"))
        XCTAssertTrue(viewModel.isValidPhone(phone: "1234567890"))
    }
    
    func testResponse() {
        let accountRepository = AccountRepository()
        personalInfoViewController?.viewModel.input.confirmPasswordObserver.onNext("123456")
        personalInfoViewController?.viewModel.input.doneObserver.onNext(())
        let viewModel = PersonalInfoViewModel(withRepository: accountRepository, accountInfo: manager.getAccountDetails())
        accountRepository.changedPassword.onNext(true)
        accountRepository.changedPassword.onNext(false)
        accountRepository.errorMessage.onNext("test error")
        XCTAssertNotNil(viewModel)  
    }
}
