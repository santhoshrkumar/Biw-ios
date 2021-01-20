//
//  DevicesViewModel+API.swift
//  BiWF
//
//  Created by pooja.q.gupta on 17/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
/*
  DevicesViewModel handles devices API call 
**/
extension DevicesViewModel {
    ///Get device list connect with the modem
    func getConnectedDevices() {
        repository.getDeviceList()
    }
    
    ///Get device list with mac address id
    func getMacDeviceList(_ deviceList: DeviceList) {
        repository.getDeviceListWithMacDevicesId(deviceList)
    }
    
    ///Get device network state information whether it is pause or not for device list
    func getNetworkInfo() {
        if let list = self.deviceList?.deviceList {
            for item in list {
                self.getDeviceNetworkInfo(item)
            }
        }
    }
    
    ///Get device list with nick name
    func getMacDeviceInfoList(_ deviceList: DeviceList) {
        repository.getMacDeviceInfoList(deviceList)
    }
    
    ///Get device network state information whether it is pause or not
    /// When user click on retry button for single device
    /// - Parameters:
    //     - deviceInfo: device detail of selected device
    func getDeviceNetworkInfo(_ deviceInfo: DeviceInfo) {
        
        if let _ = deviceInfo.macDeviceId {
            repository.getNetworkInfo(deviceInfo)
        } else {
            repository.errorNetworkInfoSubject.onNext((deviceInfo, ""))
        }
    }
    
    /// Restore remove devices
    /// - Parameters:
    ///     - deviceInfo: device detail of selected device
    func restoreDevice(_ deviceInfo: DeviceInfo) {
        let loading = ViewStatus.loading(loadingText: Constants.Common.restoring)
        viewStatusSubject.onNext(loading)
        
        repository.unblockDevice(deviceInfo.stationMac)
            .subscribe(onNext: {[weak self] (status, error) in
                guard let self = self else { return }
                if let status = status, status == true {
                    AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.unblockDevicesListSuccess)
                    self.getConnectedDevices()
                }
                if let error = error {
                    AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.unblockDevicesListFailure)
                    self.viewStatusSubject.onNext(.loaded)
                    self.showAlert(withMessage: error,
                                   deviceInfo: deviceInfo)
                }
            }).disposed(by: self.disposeBag)
    }
    
    ///Subscription for repository observer to get API response and error.
    func subscribeObservers() {
        ///Subscribe deviceListSubject observer of device repository to get device list response
        repository.deviceListSubject
            .subscribe({ [weak self] details in
                guard let self = self else { return }
                do {
                    AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.devicesDetailsSuccess)
                    if let list = details.element?.deviceList, list.count > 0 {
                        self.getMacDeviceList(details.element ?? DeviceList())
                    } else {
                        self.viewStatusSubject.onNext(ViewStatus.loaded)
                        self.endRefreshing.onNext(false)
                        self.setSections()
                    }
                }
            }).disposed(by: self.disposeBag)
        
        ///Subscribe errorMessageSubject observer of device repository to error message
        repository.errorMessageSubject
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                do {
                    AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.devicesDetailsFailure)
                    let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                        let loading = ViewStatus.loading(loadingText: Constants.Common.loading)
                        self.viewStatusSubject.onNext(loading)
                        self.getConnectedDevices()
                    }
                    self.endRefreshing.onNext(true)
                    self.viewStatusSubject.onNext(error)
                }
            }).disposed(by: self.disposeBag)
        
        ///Subscribe deviceListWithMacDeviceIdSubject observer of device repository to get device list with mac address id response
        repository.deviceListWithMacDeviceIdSubject
            .subscribe({ [weak self] deviceList in
                guard let self = self else { return }
                do {
                    self.getMacDeviceInfoList(deviceList.element ?? DeviceList())
                }
            }).disposed(by: self.disposeBag)
        
        ///Subscribe errorDeviceListWithMacDeviceIdSubject observer of device repository to error message
        repository.errorDeviceListWithMacDeviceIdSubject
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                do {
                    let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                        let loading = ViewStatus.loading(loadingText: Constants.Common.loading)
                        self.viewStatusSubject.onNext(loading)
                        self.getConnectedDevices()
                    }
                    self.endRefreshing.onNext(true)
                    self.viewStatusSubject.onNext(error)
                }
            }).disposed(by: self.disposeBag)
        
        ///Subscribe macDeviceInfoListSubject observer of device repository to get device list  with nickname info response
        repository.macDeviceInfoListSubject
            .subscribe(onNext: {[weak self] (deviceList) in
                guard let self = self else { return }
                do {
                    self.deviceList = deviceList
                    self.getNetworkInfo()
                    self.viewStatusSubject.onNext(ViewStatus.loaded)
                    self.endRefreshing.onNext(false)
                    self.setSections()
                }
            }).disposed(by: self.disposeBag)
        
        ///Subscribe errorMacDeviceInfoListSubject observer of device repository to error message
        repository.errorMacDeviceInfoListSubject
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                do {
                    let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                        let loading = ViewStatus.loading(loadingText: Constants.Common.loading)
                        self.viewStatusSubject.onNext(loading)
                        self.getConnectedDevices()
                    }
                    self.endRefreshing.onNext(true)
                    self.viewStatusSubject.onNext(error)
                }
            }).disposed(by: self.disposeBag)
        
        ///Subscribe macDeviceInfoListSubject observer of network repository to check if modem is online
        networkRepository.isModemOnlineSubject.asObservable().subscribe(onNext: {[weak self] isOnline in
            guard let self = self else { return }
            self.isModemOnline = isOnline
        }).disposed(by: disposeBag)
        
        ///Subscribe networkInfoSubject observer of device repository to get device network info response whether it pause or resume
        repository.networkInfoSubject
            .subscribe(onNext: { (deviceInfo) in
                
                guard let row = self.deviceList?.deviceList?.firstIndex(where: {$0.macDeviceId == deviceInfo.macDeviceId}) else {
                    self.setSections()
                    return
                }
                DispatchQueue.main.async {
                    self.deviceList?.deviceList?[row].networStatus = deviceInfo.networStatus
                    self.setSections()
                }
            }).disposed(by: self.disposeBag)
        
        ///Subscribe errorNetworkInfoSubject observer of device repository to error message
        repository.errorNetworkInfoSubject
            .subscribe(onNext: { (device, error) in
                guard let row = self.deviceList?.deviceList?.firstIndex(where: {$0.stationMac == device.stationMac}) else {
                    return
                }
                self.deviceList?.deviceList?[row].networStatus = .error
                self.setSections()
            }).disposed(by: disposeBag)
    }
    
    /// Pause resume devices network
    /// - Parameters:
    ///     - deviceInfo: device detail of selected device
    ///     - shouldPauseDevice: flag bool value define to pause/resume
    func pauseResumeDevice(_ deviceInfo: DeviceInfo, _ shouldPauseDevice: Bool) {
        repository.pauseResumeDevice(deviceInfo.parent ?? "", deviceInfo.macDeviceId ?? "", shouldPauseDevice)
            .subscribe(onNext: {[weak self] (response, error) in
                guard let self = self else {return}
                if response?.code == "\(McAfeeStatusCode.ok.rawValue)" {
                    guard let row = self.deviceList?.deviceList?.firstIndex(where: {$0.macDeviceId == deviceInfo.macDeviceId}) else {
                        self.setSections()
                        return
                    }
                    self.deviceList?.deviceList?[row].networStatus = shouldPauseDevice ? .paused : .connected
                } else {
                    self.showPauseResumeFailureAlert(withMessage: error ?? response?.message ?? "", deviceInfo: deviceInfo)
                }
                DispatchQueue.main.async {
                    self.setSections()
                }
            }).disposed(by: self.disposeBag)
    }
    
    /// Showing alert for response error and retry get data.
    func showAlert(withMessage errorMessage: String, deviceInfo: DeviceInfo) {
        AlertPresenter.showRetryErrorAlert(title: Constants.Biometric.alertTitleError,
                                           message: errorMessage,
                                           retryAction: {
                                            self.restoreDevice(deviceInfo)
        },                                 cancelAction: nil,
                                           leftButtonTitle: Constants.Common.cancel.capitalized,
                                           rightButtonTitle: Constants.Common.retry)
    }
    
    /// Showing alert for pause resume response error and retry get data.
    func showPauseResumeFailureAlert(withMessage errorMessage: String, deviceInfo: DeviceInfo) {
        AlertPresenter.showRetryErrorAlert(title: Constants.Biometric.alertTitleError,
                                           message: errorMessage,
                                           retryAction: {
                                            self.pauseResumeDevice(deviceInfo, deviceInfo.networStatus == .paused)
        },                                 cancelAction: nil,
                                           leftButtonTitle: Constants.Common.cancel.capitalized,
                                           rightButtonTitle: Constants.Common.retry)
    }
}
