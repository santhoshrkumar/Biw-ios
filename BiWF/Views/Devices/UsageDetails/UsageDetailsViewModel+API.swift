//
//  UsageDetailsViewModel+API.swift
//  BiWF
//
//  Created by pooja.q.gupta on 18/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

extension UsageDetailsViewModel {
    
    ///Get daily and last two week usage detail of the device
    func getUsageDetails() {
        if todayUsage == nil {
            let loading = ViewStatus.loading(loadingText: Constants.Common.loading)
            viewStatusSubject.onNext(loading)
            
            getUsageDetails(from: "\(Date().toString(withFormat: Constants.DateFormat.YYYY_MM_dd))T00:00:00-0000",
                to: "", isTodayUsage: true)
        } else if lastTwoWeeksUsage == nil {
            let startDate = "\((Date().dateBeforeDays(Constants.UsageDetails.lastTwoWeeks) ?? Date()).toString(withFormat: Constants.DateFormat.YYYY_MM_dd))T00:00:00-0000"
            let endDate = "\((Date().dateBeforeDays(1) ?? Date()).toString(withFormat: Constants.DateFormat.YYYY_MM_dd))T24:00:00-0000"
            getUsageDetails(from: startDate,
                            to: endDate,
                            isTodayUsage: false)
        } else {
            getNetworkInfo()
        }
    }
    
    ///Get usage detail of the device
    /// - Parameter
    ///   - startDate: started data usage date
    ///   - endDate: end data usage date
    ///   - isTodayUsage: bool flag for getting specific usage detail
    func getUsageDetails(from startDate: String, to endDate: String, isTodayUsage: Bool) {
        
        ///Subscribe usageDetailsSubject to get usage detail response
        repository.usageDetailsSubject
            .subscribe(onNext: {[weak self] response in
                guard let self = self else {return}
                
                if isTodayUsage && (self.todayUsage == nil) {
                    AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.dailyUsageDetailsSuccess)
                    self.todayUsage = response
                } else if !isTodayUsage && self.lastTwoWeeksUsage == nil {
                    AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.weeklyUsageDetailsSuccess)
                    self.lastTwoWeeksUsage = response
                }
                self.getUsageDetails()
                
            }).disposed(by: self.disposeBag)
        
        ///Subscribe errorMessageSubject to get error
        repository.errorMessageSubject
            .subscribe(onNext: {[weak self] error in
                let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                    if isTodayUsage && (self?.todayUsage == nil) {
                        AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.dailyUsageDetailsFailure)
                    } else if !isTodayUsage && self?.lastTwoWeeksUsage == nil {
                        AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.weeklyUsageDetailsFailure)
                    }
                    self?.getUsageDetails()
                }
                self?.viewStatusSubject.onNext(error)
                
                
            }).disposed(by: self.disposeBag)
        
        ///Call Get getUsage Details API
        self.repository.getUsageDetails(for: deviceInfo.stationMac,
                                        from:  startDate,
                                        to: endDate)
        
    }
    
    ///To block specific device
    /// - Parameter
    ///   - deviceInfo: Device info
    func blockDevice(_ deviceInfo: DeviceInfo) {
        let loading = ViewStatus.loading(loadingText: Constants.Common.removing)
        viewStatusSubject.onNext(loading)
        
        repository.blockDevice(deviceInfo.stationMac)
            .subscribe(onNext: {[weak self] (status, error) in
                guard let self = self else {return}
                
                self.viewStatusSubject.onNext(.loaded)
                if let status = status, status == true {
                    AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.blockDevicesListSuccess)
                    self.input.doneTapObserver.onNext(())
                }
                
                if let error = error {
                    AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.blockDevicesListFailure)
                    print(error)
                }
            }).disposed(by: self.disposeBag)
    }
    
    ///Get Device network info whether it is pause or resume
    func getNetworkInfo() {
        /// Suscribe networkInfoSubject to handle pause and resume state
        repository.networkInfoSubject
            .subscribe(onNext: {[weak self] (device) in
                self?.showLoading.accept(false)
                guard let self = self else {return}
                self.deviceInfo.networStatus = self.isModemOnline ? device.networStatus : .offline
                self.enablePauseResumeSubject.onNext(!(device.networStatus == .paused))
                self.viewStatusSubject.onNext(.loaded)
                self.updateUsageDetails()
            }).disposed(by: self.disposeBag)
        
        /// Suscribe errorNetworkInfoSubject to get error
        repository.errorNetworkInfoSubject
            .subscribe(onNext: { [weak self] (_, error) in
                guard let self = self else {return}
                self.showLoading.accept(false)
                self.viewStatusSubject.onNext(.loaded)
                DispatchQueue.main.async {
                    self.deviceInfo.networStatus = .error
                    self.setUpPauseResumeButton()
                }
                self.updateUsageDetails()
            }).disposed(by: disposeBag)
        
        if let _ = deviceInfo.macDeviceId, isModemOnline {
            showLoading.accept(true)
            repository.getNetworkInfo(deviceInfo)
        } else {
            showLoading.accept(false)
            DispatchQueue.main.async {
                self.deviceInfo.networStatus = self.isModemOnline ? .error : .offline
                self.setUpPauseResumeButton()
            }
            self.viewStatusSubject.onNext(.loaded)
            self.updateUsageDetails()
        }
    }
    
    ///To pause resume device
    /// - Parameter
    ///   - deviceInfo: Device info
    ///   - shouldPauseDevice: flag bool value define to pause/resume
    func pauseResumeDevice(_ deviceInfo: DeviceInfo, _ shouldPauseDevice: Bool) {
        let loading = ViewStatus.loading(loadingText: nil)
        viewStatusSubject.onNext(loading)
        repository.pauseResumeDevice(deviceInfo.parent ?? "", deviceInfo.macDeviceId ?? "", shouldPauseDevice)
            .subscribe(onNext: {[weak self] (response, error) in
                guard let self = self else {return}
                
                self.viewStatusSubject.onNext(.loaded)
                
                if response?.code == "\(McAfeeStatusCode.ok.rawValue)" {
                    DispatchQueue.main.async {
                        self.deviceInfo.networStatus = self.isModemOnline ? .offline : (shouldPauseDevice ? .paused : .connected)
                        self.enablePauseResumeSubject.onNext(!shouldPauseDevice)
                        self.updateUsageDetails()
                    }
                } else {
                    self.showAlert(withMessage: error ?? response?.message ?? "", deviceInfo: deviceInfo)
                }
            }).disposed(by: self.disposeBag)
    }
    
    func showAlert(withMessage errorMessage: String, deviceInfo: DeviceInfo) {
        AlertPresenter.showRetryErrorAlert(title: Constants.Biometric.alertTitleError,
                                           message: errorMessage,
                                           retryAction: {
                                            self.pauseResumeDevice(deviceInfo, !(self.deviceInfo.networStatus == .paused))
        },                                 cancelAction: nil,
                                           leftButtonTitle: Constants.Common.cancel.capitalized,
                                           rightButtonTitle: Constants.Common.retry)
    }
}
