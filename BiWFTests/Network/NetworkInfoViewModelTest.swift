//
//  NetworkInfoViewModelTest.swift
//  BiWFTests
//
//  Created by Varun.b.r on 16/09/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class NetworkInfoViewModelTest: XCTestCase {
    
    let disposeBag = DisposeBag()
    var viewModel : NetworkInfoViewModel!
    
    func testDoneEvent() {
        let testExpectation = expectation(description: "Done with network info and dismiss view")
        let viewModel = NetworkInfoViewModel(with: WiFiNetwork(name: "varun", password: "1234", isGuestNetwork: true), guestNetwork: WiFiNetwork(name: "abc", password: "65432", isGuestNetwork: true), networkRepository: NetworkRepository(), and: ["abc":"xyz"])
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .dismissNetwork = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.input.doneObserver.onNext(Void())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testErrorSavingChangesEvent() {
        
        let testExpectation = expectation(description: "Recieve event to error saving changes")
        let viewModel = NetworkInfoViewModel(with: WiFiNetwork(name: "varun", password: "1234", isGuestNetwork: true), guestNetwork: WiFiNetwork(name: "abc", password: "65432", isGuestNetwork: true), networkRepository: NetworkRepository(), and: ["abc":"xyz"])
        viewModel.output.viewComplete.subscribe(onNext: { event in
            guard case .errorSavingChangesAlert = event else {
                XCTFail()
                return
            }
            testExpectation.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.errorSavingChangesSubject.onNext(())
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testSetSections() {
        let viewModel = NetworkInfoViewModel(with: WiFiNetwork(name: "varun", password: "1234", isGuestNetwork: true), guestNetwork: WiFiNetwork(name: "abc", password: "65432", isGuestNetwork: true), networkRepository: NetworkRepository(), and: ["abc":"xyz"])
        XCTAssertNotNil(viewModel.setSections())
    }
    
    func testValidateFields() {
        let viewModel = NetworkInfoViewModel(with: WiFiNetwork(name: "varun", password: "1234", isGuestNetwork: true), guestNetwork: WiFiNetwork(name: "abc", password: "65432", isGuestNetwork: true), networkRepository: NetworkRepository(), and: ["abc":"xyz"])
        XCTAssertNotNil(viewModel.validateFields())
    }
    
    func testShouldShowSaveChangesAlert() {
        let viewModel = NetworkInfoViewModel(with: WiFiNetwork(name: "Test123", password: "1234", isGuestNetwork: true), guestNetwork: WiFiNetwork(name: "abc", password: "65432", isGuestNetwork: true), networkRepository: NetworkRepository(), and: ["abc":"xyz"])
        XCTAssertNotNil(viewModel.shouldShowSaveChangesAlert())
        
    }
    
    func testUpdateSSID() {
        let viewModel = NetworkInfoViewModel(with: WiFiNetwork(name: "Test123", password: "1234", isGuestNetwork: true), guestNetwork: WiFiNetwork(name: "abc", password: "65432", isGuestNetwork: true), networkRepository: NetworkRepository(), and: ["abc":"xyz"])
        XCTAssertNotNil(viewModel.updateSSID(forInterface: NetworkRepository.Bands.Band2G.rawValue, newSSID: "New_test_SSID"))
    }
    
    func testEnableDisableNetwork() {
        let viewModel = NetworkInfoViewModel(with: WiFiNetwork(name: "Test123", password: "1234", isGuestNetwork: true), guestNetwork: WiFiNetwork(name: "abc", password: "65432", isGuestNetwork: true), networkRepository: NetworkRepository(), and: ["abc":"xyz"])
        
        XCTAssertNotNil(viewModel.enableNetwork(forInterface: NetworkRepository.Bands.Band2G.rawValue))
        XCTAssertNotNil(viewModel.disableNetwork(forInterface: NetworkRepository.Bands.Band2G.rawValue))
    }
    
    func testUpdateEnableDisableUI() {
        let viewModel = NetworkInfoViewModel(with: WiFiNetwork(name: "Test123", password: "1234", isGuestNetwork: true), guestNetwork: WiFiNetwork(name: "abc", password: "65432", isGuestNetwork: true), networkRepository: NetworkRepository(), and: ["abc":"xyz"])
        
        XCTAssertNotNil(viewModel.updateEnableDisableUI(for: NetworkRepository.Bands.Band2G.rawValue, isEnabled: true))
    }
    
    func testCompareValuesAndCallAPI() {
        let viewModel = NetworkInfoViewModel(with: WiFiNetwork(name: "Test123", password: "1234", isGuestNetwork: true), guestNetwork: WiFiNetwork(name: "abc", password: "65432", isGuestNetwork: true), networkRepository: NetworkRepository(), and: ["abc":"xyz"])
        
        XCTAssertNotNil(viewModel.compareValuesAndCallAPI())
    }
    
    func testDescreaseCountAndUpdateUI() {
        let viewModel = NetworkInfoViewModel(with: WiFiNetwork(name: "Test123", password: "1234", isGuestNetwork: true), guestNetwork: WiFiNetwork(name: "abc", password: "65432", isGuestNetwork: true), networkRepository: NetworkRepository(), and: ["abc":"xyz"])
        
        XCTAssertNotNil(viewModel.descreaseCountAndUpdateUI())
    }
}
