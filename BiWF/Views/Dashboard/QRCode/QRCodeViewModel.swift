//
//  QRCodeViewModel.swift
//  BiWF
//
//  Created by Amruta Mali on 03/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
/*
 QRCodeViewModel to handle the qrcode
 */
class QRCodeViewModel {
    
    /// Input structure
    struct Input {
        let doneTapObserver: AnyObserver<Void>
    }
    
    /// Output structure
    struct Output {
        let qrCodeImageDriver: Driver<UIImage?>
        let scanToJoinTextDriver: Driver<String>
        let wifiNetworkNameTextDriver: Driver<String>
        let infoSubtitleTextDriver: Driver<String>
        let addToWallettextDriver: Driver<String>
        let viewComplete: Observable<DashboardCoordinator.Event>
    }
    
    /// Input/Output structure variables
    let input: Input
    let output: Output
    
    private let disposeBag = DisposeBag()
    
    /// Holds WiFiNetwork with strong reference
    private var wifiNetwork: WiFiNetwork
    
    /// Subject to handle done button tap
    private let doneTapSubject = PublishSubject<Void>()
    
    /// Initializes a new instance of wifiNetwork
    /// - Parameter wifiNetwork : details of wifiNetwork
    init(wifiNetwork: WiFiNetwork) {
        self.wifiNetwork = wifiNetwork
        input = Input(doneTapObserver: doneTapSubject.asObserver())
        
        let doneEventObservable = doneTapSubject.asObservable().map { _ in
            return DashboardCoordinator.Event.goBackToDashboard
        }
        
        output = Output(qrCodeImageDriver: .just(QRCodeUtility.generateQRCodeWithColor(from: wifiNetwork.qrCodeGeneratorString())),
                        scanToJoinTextDriver: .just(Constants.JoinQRCode.scanQRCodeToJoinNetwork),
                        wifiNetworkNameTextDriver: .just(wifiNetwork.name),
                        infoSubtitleTextDriver: .just(Constants.JoinQRCode.qrCodeInfoSubtitle),
                        addToWallettextDriver: .just(Constants.JoinQRCode.addToAppleWallet),
                        viewComplete: doneEventObservable)
    }
}
