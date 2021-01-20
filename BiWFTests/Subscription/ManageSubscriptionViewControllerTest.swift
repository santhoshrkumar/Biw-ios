//
//  ManageSubscriptionViewControllerTest.swift
//  BiWFTests
//
//  Created by pooja.q.gupta on 17/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class ManageSubscriptionViewControllerTest: XCTestCase {
    
    var manageSubscriptionViewController: ManageSubscriptionViewController?
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
        manageSubscriptionViewController = storyboard.instantiateViewController(withIdentifier: "ManageSubscriptionViewController")
            as? ManageSubscriptionViewController
        _ = manageSubscriptionViewController?.view
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
        let viewModel = ManageSubscriptionViewModel.init(withAccount: account)
        manageSubscriptionViewController?.setViewModel(to: viewModel)
        manageSubscriptionViewController?.viewWillAppear(true)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        manageSubscriptionViewController = nil
    }
    
    // tests if personalInfoViewController initialized
    func testSanity() {
        XCTAssertNotNil(manageSubscriptionViewController)
    }
    
    func testButtonTap() {
        _ = manageSubscriptionViewController?.backButton.target?.perform(manageSubscriptionViewController?.backButton.action, with: nil)
    }
}
