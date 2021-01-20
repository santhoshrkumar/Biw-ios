//
//  SupportRepositoryTest.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 16/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class SupportRepositoryTest: XCTestCase {

    var supportRepository: SupportRepository?

    func testInitialisationEvent() {
        XCTAssertNotNil(supportRepository = SupportRepository.init(supportServiceManager: MockSupportServiceManager()))
    }
    
    func testGetRecordID() {
        supportRepository = SupportRepository.init(supportServiceManager: MockSupportServiceManager())
        XCTAssertNotNil(supportRepository?.getRecordID())
    }
    
    func testGetCustomerCareRecordID() {
        supportRepository = SupportRepository.init(supportServiceManager: MockSupportServiceManager())
        XCTAssertNotNil(supportRepository?.getCustomerCareRecordID())
    }
    
    func testGetFaqTopics() {
        supportRepository = SupportRepository.init(supportServiceManager: MockSupportServiceManager())
        XCTAssertNotNil(supportRepository?.getFaqTopics(forRecordID: "012f0000000l0wrAAA"))
    }
    
    func testGetContactUsOption() {
        supportRepository = SupportRepository.init(supportServiceManager: MockSupportServiceManager())
        XCTAssertNotNil(supportRepository?.getContactUsOptions())
    }
    
    func testScheduleSupportCallBack() {
        supportRepository = SupportRepository.init(supportServiceManager: MockSupportServiceManager())
        XCTAssertNotNil(supportRepository?.scheduleSupportCallBack(scheduleCallbackInfo: ScheduleCallback(phone: "111-111-1111",
                                                                                          asap: true,
                                                                                          customerCareOption: "I want to know more about Fiber Internet",
                                                                                          handleOption: true,
                                                                                          callbackTime: "2020-11-28 02:00:00",
                                                                                          callbackReason: "Test")))
    }
    
    func testGetCustomerCareOptionList() {
        supportRepository = SupportRepository.init(supportServiceManager: MockSupportServiceManager())
        XCTAssertNotNil(supportRepository?.getCustomerCareOptionList(forRecordID: "012f0000000l0wrAAA"))
    }
}
