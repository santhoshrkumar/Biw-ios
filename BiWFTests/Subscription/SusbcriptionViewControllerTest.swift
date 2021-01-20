//
//  SusbcriptionViewControllerTest.swift
//  BiWFTests
//
//  Created by pooja.q.gupta on 17/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class SusbcriptionViewControllerTest: XCTestCase {
    
    // instance for subscriptionViewController
    var subscriptionViewController: SubscriptionViewController?
    
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
    
    private let paymentInfo = PaymentInfo(card: "Visa ************8291",
                                          billCycleDay: "29th of the month",
                                          nextRenewalDate: "2020-07-29",
                                          id: "a1Ff0000001hp33EAA")
    
    private let fiberPlanInfo = FiberPlanInfo(internetSpeed: "Speeds up to 940Mbps", productName: "Fiber Internet", id: "a1Yf0000002hH8iEAE", zuoraPrice: 65.0, extendedAmount: 65.0)
    
    private var subscription: Subscription {
        return Subscription(account: account, paymentInfo: paymentInfo, fiberPlanInfo: fiberPlanInfo)
    }
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Subscription", bundle: nil)
        subscriptionViewController = storyboard.instantiateViewController(withIdentifier: "SubscriptionViewController")
            as? SubscriptionViewController
        _ = subscriptionViewController?.view        
        let viewModel = SubscriptionViewModel(with: subscription,
                                              repository: SubscriptionRepository.init(subscriptionServiceManager: MockSubscriptionServiceManager()))

            
        subscriptionViewController?.setViewModel(to: viewModel)
        subscriptionViewController?.viewWillAppear(true)
        subscriptionViewController?.viewDidLayoutSubviews()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        subscriptionViewController = nil
    }
    
    // tests if AccountViewController initialized
    func testSanity() {
        XCTAssertNotNil(subscriptionViewController)
    }
    
    func testHeightForHeaderInSection() {
        
        if let tableView = subscriptionViewController?.tableView {
            XCTAssertEqual(subscriptionViewController?.tableView(tableView, heightForHeaderInSection: SubscriptionViewModel.SectionType.planDetail.rawValue), 0)
        }
    }
    
    func testCreationDataSource() {
        XCTAssertNotNil(SubscriptionViewController.dataSource())
    }
    
    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertNotNil(subscriptionViewController?.conforms(to: UITableViewDelegate.self))
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(subscriptionViewController?.tableView.dataSource)
    }

}
