//
//  NetworkRepositoryTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 14/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class NetworkRepositoryTest: XCTestCase {
    
    var networkRepository: NetworkRepository?
    
    func testInitialisationEvent() {
        XCTAssertNotNil(networkRepository = NetworkRepository.init(networkServiceManager:MockNetworkServiceManager()))
    }
    
    func testGetNetworkStatus() {
        networkRepository = NetworkRepository.init(networkServiceManager: MockNetworkServiceManager())
        XCTAssertNotNil(networkRepository?.getNetworkStatus())
    }
    
    func testRestartModem() {
        networkRepository = NetworkRepository.init(networkServiceManager: MockNetworkServiceManager())
        XCTAssertNotNil(networkRepository?.restartModem())
    }
    
    func testRunSpeedTest() {
        networkRepository = NetworkRepository.init(networkServiceManager: MockNetworkServiceManager())
        XCTAssertNotNil(networkRepository?.runSpeedTest())
    }
    
    func testEnableNetwork() {
        networkRepository = NetworkRepository.init(networkServiceManager: MockNetworkServiceManager())
        XCTAssertNotNil(networkRepository?.enableNetwork(forInterface: "Band2G"))
    }
    
    func testDisableNetwork() {
        networkRepository = NetworkRepository.init(networkServiceManager: MockNetworkServiceManager())
        XCTAssertNotNil(networkRepository?.disableNetwork(forInterface: "Band2G"))
    }
    
    func testGetNetworkPassword() {
        networkRepository = NetworkRepository.init(networkServiceManager: MockNetworkServiceManager())
        XCTAssertNotNil(networkRepository?.getNetworkPassword(forInterface: "Band2G"))
    }
    
    func testUpdateNetworkPassword() {
        networkRepository = NetworkRepository.init(networkServiceManager: MockNetworkServiceManager())
        XCTAssertNotNil(networkRepository?.updateNetworkPassword(newPassword: "test123",
                                                                 forInterface: "Band2G"))
    }
    
    func testUpdateNetworkSSID() {
        networkRepository = NetworkRepository.init(networkServiceManager: MockNetworkServiceManager())
        XCTAssertNotNil(networkRepository?.updateNetworkSSID(newSSID: "CenturyLink123",
                                                             forInterface: "Band2G"))
    }
}
