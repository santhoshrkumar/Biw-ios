//
//  NewUserDashboardViewController.swift
//  BiWFTests
//
//  Created by pooja.q.gupta on 17/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class NewUserDashboardViewControllerTest: XCTestCase {
    
    var newUserDashboardViewController: NewUserDashboardViewController?
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "NewUserDashboard", bundle: nil)
        newUserDashboardViewController = storyboard.instantiateViewController(withIdentifier: "NewUserDashboardViewController") as? NewUserDashboardViewController
        
        let viewModel = CommonDashboardViewModel.init(with: AppointmentRepository(appointmentServiceManager: MockAppointmentServiceManager()))
        newUserDashboardViewController?.setViewModel(to: viewModel)
        XCTAssertNotNil(newUserDashboardViewController?.view)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        newUserDashboardViewController = nil
    }
    
    func testSanity() {
        XCTAssertNotNil(newUserDashboardViewController)
    }
    
    func testDatasource() {
        XCTAssertNotNil(newUserDashboardViewController?.dataSource())
    }
    
    func testBindDatasource() {
        XCTAssertNotNil(newUserDashboardViewController?.bindDataSource())
    }
    
    func testShowAlert() {
        XCTAssertNotNil(newUserDashboardViewController?.showAlert(with: Constants.NewUserDashboard.cancelAppointmentConfirmationTitle,
                       message: Constants.NewUserDashboard.cancelAppointmentAlertDescription,
                       leftButtonTitle: Constants.NewUserDashboard.keepIt,
                       rightButtonTitle: Constants.NewUserDashboard.cancelIt,
                       rightButtonStyle: .cancel,
                       rightButtonDidTap: {[weak self] in
                        self?.newUserDashboardViewController?.viewModel.input.cancelAppointmentObserver.onNext(())
        }))
    }
    
}
