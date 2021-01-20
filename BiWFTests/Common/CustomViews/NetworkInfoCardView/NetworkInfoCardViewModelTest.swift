//
//  NetworkInfoCardViewModelTest.swift
//  BiWFTests
//
//  Created by varun.b.r on 11/11/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import XCTest
import RxSwift
@testable import BiWF

class NetworkInfoCardViewModelTest: XCTestCase {
    var wifiNetwork: WiFiNetwork!
    var subject: NetworkInfoCardViewModel!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        wifiNetwork = WiFiNetwork(name: "WiFiNetwork", password: "1234", isGuestNetwork: true)
        subject = NetworkInfoCardViewModel(with: wifiNetwork)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        super.tearDown()

        subject = nil
        wifiNetwork = nil
        disposeBag = nil
    }
    /*
    func testNetworkInfoCardViewModelOutput() {
        let expectedQRCodeImageData = QRCodeUtility.generateQRCodeWithColor(from: wifiNetwork.qrCodeGeneratorString())?.pngData()

        XCTAssertEqual(try subject.output.networkNameDriver.toBlocking().first(), "WiFiNetwork")
        XCTAssertEqual(try subject.output.scanToJoinDriver.toBlocking().first(), Constants.WifiNetwork.scanToJoin)
        XCTAssertEqual(try subject.output.tapCodeDriver.toBlocking().first(), Constants.WifiNetwork.tapToViewFullScreen)
        XCTAssertEqual(try subject.output.qrCodeImage.toBlocking().first()??.pngData(), expectedQRCodeImageData)
        XCTAssertEqual(try subject.output.networkEnableDisableImage.toBlocking().first(), UIImage(named: wifiNetwork.isEnabled ? "on" : "off"))
        XCTAssertEqual(try subject.output.networkHeaderDriver.toBlocking().first(), Constants.NetworkInfo.guestInformation)
    }*/

    func testNetworkInfoCardViewModelInput() {
        var expandQRCodeEventReceived = false
        var networkEnableDisableEventReceived = false

        let expandQRCodeEventObservable = PublishSubject<Void>()
        let networkEnableDisableEventObservable = PublishSubject<Void>()

        expandQRCodeEventObservable
            .bind(to: subject.input.expandQRCodeObserver)
            .disposed(by: disposeBag)

        subject.output.expandQRCodeObservable.subscribe(onNext: { _ in
            expandQRCodeEventReceived = true
            XCTAssertTrue(expandQRCodeEventReceived)
        }).disposed(by: disposeBag)

        expandQRCodeEventObservable.onNext(())

        networkEnableDisableEventObservable
            .bind(to: subject.input.networkEnableDisableObserver)
            .disposed(by: disposeBag)

        subject.output.networkEnableDisableObservable.subscribe(onNext: { _ in
            networkEnableDisableEventReceived = true
            XCTAssertTrue(networkEnableDisableEventReceived)
        }).disposed(by: disposeBag)

        networkEnableDisableEventObservable.onNext(())
    }
}
