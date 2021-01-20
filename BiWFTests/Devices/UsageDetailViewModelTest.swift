//
//  UsageDetailViewModelTest.swift
//  BiWFTests
//
//  Created by Amruta Mali on 20/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//


import XCTest
import RxSwift
//import RxBlocking

@testable import BiWF

class UsageDetailViewModelTest: XCTestCase {
    let usageDetails = UsageDetails(downLinkTraffic: 32.44, upLinkTraffic: 24.44, interface: "Band 5G")

    func testUsageDetailsForPausedDevice() {
        /*
        let subject = UsageDetailViewModel(with: UsageDetailsList(list: [usageDetails]), isPaused: true)

        XCTAssertEqual(try subject.output.downloadUnitDriver.toBlocking().first(), Constants.Common.mb + "\n" + Constants.UsageDetails.download)
        XCTAssertEqual(try subject.output.downloadDetailsDriver.toBlocking().first(), "- -")
        XCTAssertEqual(try subject.output.uploadUnitDriver.toBlocking().first(), Constants.Common.mb + "\n" + Constants.UsageDetails.upload)
        XCTAssertEqual(try subject.output.uploadDetailsDriver.toBlocking().first(), "- -")
 */
    }

    func testUsageDetails() {
        /*
        let subject = UsageDetailViewModel(with: UsageDetailsList(list: [usageDetails]), isPaused: false)

        XCTAssertEqual(try subject.output.downloadUnitDriver.toBlocking().first(), Constants.Common.mb + "\n" + Constants.UsageDetails.download)
        XCTAssertEqual(try subject.output.downloadDetailsDriver.toBlocking().first(), "32")
        XCTAssertEqual(try subject.output.uploadUnitDriver.toBlocking().first(), Constants.Common.mb + "\n" + Constants.UsageDetails.upload)
        XCTAssertEqual(try subject.output.uploadDetailsDriver.toBlocking().first(), "24")
 */
    }
}
