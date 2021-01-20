//
//  DeviceDetailTableCellViewModel.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 18/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class DeviceDetailTableCellViewModel {
    
    struct Input {
    }
    
    /// Output structure
    struct Output {
        let connectedDevices: Driver<String>
        let retryNetworkInfoObservable: Observable<DeviceInfo>
        let pauseResumeObservable: Observable<DeviceInfo>
    }
    
    /// Input & Output structure variable
    let input: Input
    let output: Output

    // MARK: - Subject
    /// Subject to handle error
    let errorTapSubject = BehaviorSubject<Bool>(value: false)
    /// Subject to handle enable disable tap
    let enablePauseResumeSubject = BehaviorSubject<Bool>(value: false)
    /// Subject to retry network information
    let retryNetworkInfoTapSubject = PublishSubject<DeviceInfo>()
    /// Subject to pause resume
    let pauseResumeSubject = PublishSubject<DeviceInfo>()
    let showLoading = BehaviorRelay<Bool>(value: true)
    private let disposeBag = DisposeBag()

    /// Variables
    var isBlockedDevice = true
    var networkStregthImage = UIImage()
    let deviceRepository: DeviceRepository
    var deviceInfo: DeviceInfo
    let isOnline: Bool
    
    /// Initializes a new instance of DeviceDetailTableCell viewmodel with
    /// - Parameter device: device information
    ///             isOnline:  Flag bool for network online/offline
    ///             repository: Device repository to call API
    init(withDevice device: DeviceInfo, isOnline: Bool, repository: DeviceRepository) {
        deviceRepository = repository
        deviceInfo = device
        isBlockedDevice = device.blocked ?? true
        self.isOnline = isOnline
        input = Input()
        output = Output(connectedDevices: .just(device.nickName ?? (device.hostname ?? "" )),
                        retryNetworkInfoObservable: retryNetworkInfoTapSubject.asObserver(), pauseResumeObservable: pauseResumeSubject.asObserver()
        )
        
        if deviceInfo.networStatus != .loading || deviceInfo.connectedInterface == "Ethernet" {
            self.networkStregthImage = deviceInfo.strengthStatusImage(isOnline: isOnline)
            self.showLoading.accept(false)
        }
        
        ///depend on isShowErrorPauseImage flag variable showing reload error imagee 
        if deviceInfo.networStatus == .error && !isBlockedDevice && deviceInfo.connectedInterface != "Ethernet" {
            self.networkStregthImage = UIImage(named: Constants.LoaderErrorView.reloadImageName) ?? UIImage()
            self.showLoading.accept(false)
        }
        
    }
}
