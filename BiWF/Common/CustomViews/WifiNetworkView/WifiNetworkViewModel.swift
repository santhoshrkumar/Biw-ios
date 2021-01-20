//
//  WifiNetworkViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 30/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
/*
WifiNetworkViewModel to handle network information
*/
class WifiNetworkViewModel {
    
    /// Input structure
    struct Input {
        let expandQRCodeObserver: AnyObserver<Void>
        let networkEnableDisableObserver: AnyObserver<Void>
    }
    
    /// Output structure
    struct Output {
        let networkNameDriver: Driver<String>
        let scanToJoinDriver: Driver<String>
        let tapCodeDriver: Driver<String>
        let qrCodeImage: Driver<UIImage?>
        let networkEnableDisableImage: Driver<UIImage>
        let expandQRCodeObservable: Observable<Void>
        let networkEnableDisableObservable: Observable<Void>
    }
    
    /// Input/Output structure variables
    let input: Input
    let output: Output
    
    /// Subject to handle qrcode expand tap
    private let expandQRCodeTapSubject = PublishSubject<Void>()

    /// Subject to handle network enable disable button tap
    private let networkEnableDisableTapSubject = PublishSubject<Void>()
    
    /// Initializes a new instance of WiFiNetwork
    /// - Parameter networkInfo : contains all values of wifinetwork
    init(with data: WiFiNetwork) {
        input = Input(expandQRCodeObserver: expandQRCodeTapSubject.asObserver(),
                      networkEnableDisableObserver: networkEnableDisableTapSubject.asObserver())
        
        output = Output(networkNameDriver: .just(data.name),
                        scanToJoinDriver: .just(data.isGuestNetwork ? Constants.WifiNetwork.scanToJoinGuestNetwork : Constants.WifiNetwork.scanToJoinNetwork),
                        tapCodeDriver: .just(Constants.WifiNetwork.tapToViewFullScreen),
                        qrCodeImage: .just(QRCodeUtility.generateQRCodeWithColor(from: data.qrCodeGeneratorString())),
                        networkEnableDisableImage: .just(UIImage(named: data.isEnabled ? "on" : "off") ?? UIImage()),
                        expandQRCodeObservable: expandQRCodeTapSubject.asObservable(),
                        networkEnableDisableObservable: networkEnableDisableTapSubject.asObservable())
    }
}
