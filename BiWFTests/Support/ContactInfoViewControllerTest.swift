//
//  ContactInfoViewControllerTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 22/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class ContactInfoViewControllerTest: XCTestCase {
    
    // instance for SupportViewController
    var contactInfoViewController: ContactInfoViewController?
    var  scheduleCallback = ScheduleCallback(phone: "", asap: true, customerCareOption: "", handleOption: true, callbackTime: "", callbackReason: "")
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Support", bundle: nil)
        contactInfoViewController = storyboard.instantiateViewController(withIdentifier: "ContactInfoViewController")
            as? ContactInfoViewController
        let viewModel = ContactInfoViewModel(scheduleCallBack: scheduleCallback)
        contactInfoViewController?.setViewModel(to: viewModel)
        _ = contactInfoViewController?.view
        contactInfoViewController?.viewWillAppear(true)
    }
    
    override func tearDown() {
        super.tearDown()
        contactInfoViewController = nil
    }
    
    func testSanity() {
        XCTAssertNotNil(contactInfoViewController)
    }
    
    func testMobileTextFieldValidation() {
        contactInfoViewController?.loadViewIfNeeded()
        let field = contactInfoViewController?.mobileNumberTextField.textField ?? UITextField ()

        let result = field.delegate?.textField?(field, shouldChangeCharactersIn: NSRange(), replacementString: "1")
        XCTAssertEqual(result, true)
        
        let result2 = field.delegate?.textField?(field, shouldChangeCharactersIn: NSRange(location: 0,length: 1), replacementString: "1")
        XCTAssertEqual(result2, false)
        
        
    }
    
    func testMobileTextFieldShouldReturn() {
        contactInfoViewController?.loadViewIfNeeded()
        let field = contactInfoViewController?.mobileNumberTextField.textField ?? UITextField ()

        let result = field.delegate?.textFieldShouldReturn?(field)
        XCTAssertEqual(result, true)        
    }
    
    func testButtonTap() {
        XCTAssertNotNil(contactInfoViewController?.contactInfoNextButton.sendActions(for: .touchUpInside))
        XCTAssertNotNil(contactInfoViewController?.selectOtherPhoneButton.sendActions(for: .touchUpInside))
        
        contactInfoViewController?.viewModel.mobileNumber = ""
        XCTAssertNotNil(contactInfoViewController?.selectMobileButton.sendActions(for: .touchUpInside))

        contactInfoViewController?.viewModel.mobileNumber = "12345"
        XCTAssertNotNil(contactInfoViewController?.selectMobileButton.sendActions(for: .touchUpInside))

        contactInfoViewController?.viewModel.mobileNumber = "1234567890"
        XCTAssertNotNil(contactInfoViewController?.selectMobileButton.sendActions(for: .touchUpInside))

    }
}


