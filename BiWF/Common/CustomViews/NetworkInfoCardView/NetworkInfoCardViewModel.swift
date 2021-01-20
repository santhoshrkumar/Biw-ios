//
//  NetworkInfoCardViewModel.swift
//  BiWF
//
//  Created by varun.b.r on 10/11/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
/*
 NetworkInfoCardViewModel to handle network information
 */
class NetworkInfoCardViewModel {
    
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
        let networkHeaderDriver: Driver<String>
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
                        scanToJoinDriver: .just(Constants.WifiNetwork.scanToJoin),
                        tapCodeDriver: .just(Constants.WifiNetwork.tapToViewFullScreen),
                        qrCodeImage: .just(QRCodeUtility.generateQRCodeWithColor(from: data.qrCodeGeneratorString())),
                        networkEnableDisableImage: .just(UIImage(named: data.isEnabled ? "on" : "off") ?? UIImage()),
                        expandQRCodeObservable: expandQRCodeTapSubject.asObservable(),
                        networkHeaderDriver: .just(data.isGuestNetwork ? Constants.NetworkInfo.guestInformation :  Constants.NetworkInfo.networkInformation),
                        networkEnableDisableObservable: networkEnableDisableTapSubject.asObservable())
    }
}
