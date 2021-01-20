
//
//  NetworkRepository.swift
//  BiWF
//
//  Created by pooja.q.gupta on 09/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import DPProtocols
/**
 Assists in the implemetation of the NetworkRepository, enabling an abstraction of data
 */
class NetworkRepository: Repository {
    
    /// Enum of available  network bands
    enum Bands: String {
        case Band2G = "Band2G"
        case Band5G = "Band5G"
        case Band5G_Guest = "Band5G_Guest4"
        case Band2G_Guest = "Band2G_Guest4"
    }
    
    /// PublishSubject notification is broadcasted to all subscribed observers when responses come as Bool/Objects/ error
    let isOnlineSubject = BehaviorSubject<Bool>(value: false)
    let isModemOnlineSubject = BehaviorSubject<Bool>(value: false)
    let serialNumberSubject = BehaviorSubject<String>(value: "")
    let ssidInfoSubject = PublishSubject<(myNetworkName: String, guestNetworkName: String)>()
    let bssidMapSubject = PublishSubject<[String: String]>()
    let isModemRestartedSubject = PublishSubject<Bool>()
    let isRunningSpeedTestSubject = BehaviorSubject<Bool>(value: false)
    let speedTestSubject = BehaviorSubject<SpeedTest?>(value: nil)
    let errorMessageSubject = PublishSubject<String>()
    let errorMessageModemRestartSubject = PublishSubject<String>()
    let errorMessageSpeedTestSubject = PublishSubject<String>()
    let isSpeedTestEnableSubject = BehaviorSubject<Bool>(value: false)

    /// Contained disposables disposal
    private let disposeBag = DisposeBag()
    /// Time poll for reccursive API calls
    private let pollNetworkStatusCheckTime = 30
    private let pollSpeedTestStatusCheckTime = 5
    /// Holds the networkServiceManager with a strong reference
    private let networkServiceManager: NetworkServiceManager
    
    /// Initialise the networkServiceManager
    /// - Parameters:
    ///   - networkServiceManager: shared object of networkServiceManager
    init(networkServiceManager: NetworkServiceManager = NetworkAssiaServiceManager.shared) {
        self.networkServiceManager = networkServiceManager
        pollNetworkStatus()
        createSpeedTestErrorMessageSubscription()
    }
    
    /// Pool for API call to check network/modem status after every 30 sec
    private func pollNetworkStatus() {
        getNetworkStatus()
        Observable<Int>.interval(.seconds(pollNetworkStatusCheckTime), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.getNetworkStatus()
            }).disposed(by: disposeBag)
    }
   
    /// Present error popup anywhere on the app, if speed test api response is error
    private func createSpeedTestErrorMessageSubscription() {
        errorMessageSpeedTestSubject.subscribe(onNext: { [weak self] message in
            guard let self = self else { return }
            AlertPresenter.showRetryErrorAlert(
                title: Constants.SpeedTest.speedTestError,
                message: message,
                retryAction: self.runSpeedTest,
                cancelAction: nil,
                leftButtonTitle: Constants.Common.cancel.capitalized,
                rightButtonTitle: Constants.Common.retry
            )
        }).disposed(by: disposeBag)
    }
    
    /// Call method of network service manager which gives network/modem online/offline status
    func getNetworkStatus() {
        
        /// Initial check if account ID is not present no call is made
        if ServiceManager.shared.accountID == nil {
            self.isOnlineSubject.onNext(false)
            self.isModemOnlineSubject.onNext(false)
            return
        }
        
        networkServiceManager.getNetworkStatus().subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                ///Trach event for getNetworkStatus API call
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.modemInfoSuccess)
                do {
                    let networkStatusResponse = try JSONDecoder().decode(NetworkStatusResponse.self, from: data)
                    /// Check status data at index 1
                    if let networkStatus = networkStatusResponse.data.apInfos.first {
                        /// Publish subject with values
                        self.isOnlineSubject.onNext(networkStatus.isOnline)
                        self.isModemOnlineSubject.onNext(networkStatus.isModemOnline)
                        self.serialNumberSubject.onNext(networkStatus.serialNumber)
                        self.isSpeedTestEnableSubject.onNext(networkStatus.isSpeedTestEnable ?? false)
                        var myNetworkName = networkStatus.ssidMap.band2G
                        /// Keep both band2G band5G main network name same
                        if let networkName = networkStatus.ssidMap.band5G {
                            myNetworkName = networkName
                        }
                        /// Keep both band2gGuest4 band5gGuest4 guest network name same
                        var guestNetworkName = networkStatus.ssidMap.band2gGuest4
                        if let networkName = networkStatus.ssidMap.band5gGuest4 {
                            guestNetworkName = networkName
                        }
                        /// Pusblish ssidInfoSubject with network name for guest and main network
                        self.ssidInfoSubject.onNext((myNetworkName: myNetworkName ?? "", guestNetworkName: guestNetworkName ?? ""))
                        /// Publish bssidMap dict
                        if let bssidMap = networkStatus.bssidMap {
                            self.bssidMapSubject.onNext(bssidMap)
                        }
                        /// TODO: validate if we can remove this as now, info is coming from SF API
                        ServiceManager.shared.set(assiaID: networkStatus.serialNumber)
                    }
                } catch {
                    self.errorMessageSubject.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            case .failure(let error):
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.modemInfoFailure)
                self.errorMessageSubject.onNext(ServiceManager.getErrorMessage(forError: error))
            }
        }).disposed(by: disposeBag)
    }
    
    /// Call method of network service manager to restartModem
    func restartModem() {
        networkServiceManager.restartModem().subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let isModemRestarted = try JSONDecoder().decode(RestartModem.self, from: data)
                    self.isModemRestartedSubject.onNext(isModemRestarted.code == Constants.Common.modemRebootingSucessStatusCode ? true : false)
                } catch {
                    self.errorMessageModemRestartSubject.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            case .failure(let error):
                self.errorMessageModemRestartSubject.onNext(ServiceManager.getErrorMessage(forError: error))
            }
        }).disposed(by: disposeBag)
    }
    
    /// Call method of network service manager to run/initiate speed test
    /// Once initiated check for speed test result and call consequent API after that
    func runSpeedTest() {
        isRunningSpeedTestSubject.onNext(true)
        networkServiceManager.runSpeedTest().subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.startSpeedTestSuccess)
                do {
                    let response = try JSONDecoder().decode(RunSpeedTestResponse.self, from: data)
                    if response.success == true && (response.requestId != "" || response.requestId != nil) {
                        self.checkSpeedTestStatus(requestId: String(format: response.requestId ?? ""))
                    } else {
                        self.isRunningSpeedTestSubject.onNext(false)
                        self.errorMessageSpeedTestSubject.onNext(Constants.Common.unknownErrorOccurred)
                    }
                } catch {
                    self.isRunningSpeedTestSubject.onNext(false)
                    self.errorMessageSpeedTestSubject.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            case .failure(let error):
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.startSpeedTestFailure)
                self.isRunningSpeedTestSubject.onNext(false)
                self.errorMessageSpeedTestSubject.onNext(ServiceManager.getErrorMessage(forError: error))
            }
        }).disposed(by: disposeBag)
    }

    /// Call method of network service manager to get speed test results
    /// - Parameters:
    ///   - requestId: came from ablove API hit to check speed test
    private func checkSpeedTestStatus(requestId: String) {
        var finished = false
        let downResultSubject = BehaviorSubject<DownloadSpeedSummary?>(value: nil)
        let upResultSubject = BehaviorSubject<UploadSpeedSummary?>(value: nil)
        
        /// Combine the results and return upload speed, download speed and timstamp for the request
        Observable.combineLatest(upResultSubject, downResultSubject)
            .filter { upResult, downResult in
                return upResult != nil && downResult != nil
            }.map { [weak self] upResult, downResult -> SpeedTest? in
                guard let self = self, let upResult = upResult, let downResult = downResult else { return nil }
                /// Is speed test is running flag to false
                self.isRunningSpeedTestSubject.onNext(false)
                
                /// Extract  upload speed, download speed and timstamp for the request
                let uploadData = upResult.uploadData?.list?.first
                let downloadData = downResult.downloadData?.list?.first
                return SpeedTest(uploadSpeed: String((uploadData?.average ?? 0)/1000),
                                 downloadSpeed: String((downloadData?.average ?? 0)/1000),
                                 timeStamp: uploadData?.timestamp ?? "")
            }.observeOn(MainScheduler.instance)
            .bind(to: speedTestSubject)
            .disposed(by: disposeBag)
        
        /// Set a pool timer of 5 sec until the speed test response return a finished status as true and value as "FINISHED"
        Observable<Int>.interval(.seconds(pollSpeedTestStatusCheckTime), scheduler: MainScheduler.asyncInstance)
            .takeWhile { _ in return !finished }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.networkServiceManager.checkSpeedTestStatus(requestId: requestId).subscribe(onNext: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let data):
                        do {
                            let response = try JSONDecoder().decode(SpeedTestStatusResponse.self, from: data)
                            let data = response.statusResponse?.data
                            /// check for response finished status as true and value as "FINISHED"
                            if (data?.finished ?? false && data?.currentStep == "FINISHED") {
                                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.checkSpeedTestSuccess)
                                finished = true
                                ///Publish upload and download speed data
                                upResultSubject.onNext(response.uploadSpeedSummary)
                                downResultSubject.onNext(response.downloadSpeedSummary)
                            }
                        } catch {
                            AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.checkSpeedTestFailure)
                            self.isRunningSpeedTestSubject.onNext(false)
                            finished = true
                            self.errorMessageSpeedTestSubject.onNext(ServiceManager.getErrorMessage(forError: error))
                        }
                    case .failure(let error):
                        AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.checkSpeedTestFailure)
                        self.isRunningSpeedTestSubject.onNext(false)
                        finished = true
                        self.errorMessageSpeedTestSubject.onNext(ServiceManager.getErrorMessage(forError: error))
                    }
                }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        
    }

    /// Call method of network service manager to get enable network
    /// - Parameters:
    ///   - interface: type of band
    /// - returns:
    ///   - status: status update success API response
    ///   - error: if any error come in API response
    ///   - interface: for which network band
    func enableNetwork(forInterface interface: String) -> Observable<(status: Bool?, error: String?, interface: String?)> {
        let enableNetworkResult = PublishSubject<(status: Bool?, error: String?, interface: String?)>()
        networkServiceManager.enableNetwork(forInterface: interface)
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    do {
                        let details = try JSONDecoder().decode(NetworkEnableDisableResponse.self, from: response)
                        if Int(details.code) == Constants.Common.networkResponseSucessStatusCode {
                            enableNetworkResult.onNext((true, nil, interface))
                        } else {
                            enableNetworkResult.onNext((false, details.message?.description, interface))
                        }
                        enableNetworkResult.onCompleted()
                    } catch {
                        enableNetworkResult.onNext((nil, ServiceManager.getErrorMessage(forError: error), interface))
                        enableNetworkResult.onCompleted()
                    }
                case .failure(let error):
                    enableNetworkResult.onNext((nil, ServiceManager.getErrorMessage(forError: error), interface))
                    enableNetworkResult.onCompleted()
                }
            })
            .disposed(by: disposeBag)
        return enableNetworkResult.asObservable()
    }

    /// Call method of network service manager to get disable network
    /// - Parameters:
    ///   - interface: type of band
    /// - returns:
    ///   - status: status update success API response
    ///   - error: if any error come in API response
    ///   - interface: for which network band
    func disableNetwork(forInterface interface: String) -> Observable<(status: Bool?, error: String?, interface: String?)> {
        let disableNetworkResult = PublishSubject<(status: Bool?, error: String?, interface: String?)>()
        networkServiceManager.disableNetwork(forInterface: interface)
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    do {
                        let details = try JSONDecoder().decode(NetworkEnableDisableResponse.self, from: response)
                        if Int(details.code) == Constants.Common.networkResponseSucessStatusCode {
                            disableNetworkResult.onNext((true, nil, interface))
                        } else {
                            disableNetworkResult.onNext((false, details.message?.description, interface))
                        }
                        disableNetworkResult.onCompleted()
                    } catch {
                        disableNetworkResult.onNext((nil, ServiceManager.getErrorMessage(forError: error), interface))
                        disableNetworkResult.onCompleted()
                    }
                case .failure(let error):
                    disableNetworkResult.onNext((nil, ServiceManager.getErrorMessage(forError: error), interface))
                    disableNetworkResult.onCompleted()
                }
            })
            .disposed(by: disposeBag)
        return disableNetworkResult.asObservable()
    }
    
    /// Call method of network service manager to get network password from server
    /// - Parameters:
    ///   - interface: type of band
    /// - returns:
    ///   - password: value of password for the network API response
    ///   - error: if any error come in API response
    ///   - interface: for which network band
    func getNetworkPassword(forInterface interface: String) -> Observable<(password: String?, error: String?, interface: String?)> {
        let networkPasswordResult = PublishSubject<(password: String?, error: String?, interface: String?)>()
        networkServiceManager.getNetworkPassword(forInterface: interface)
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    do {
                        let passwordResponse = try JSONDecoder().decode(NetworkPasswordResponse.self, from: response)
                        networkPasswordResult.onNext((passwordResponse.data?.values.first, nil, interface))
                        networkPasswordResult.onCompleted()
                    } catch {
                        networkPasswordResult.onNext((nil, ServiceManager.getErrorMessage(forError: error), interface))
                        networkPasswordResult.onCompleted()
                    }
                case .failure(let error):
                    networkPasswordResult.onNext((nil, ServiceManager.getErrorMessage(forError: error), interface))
                    networkPasswordResult.onCompleted()
                }
            })
            .disposed(by: disposeBag)
        return networkPasswordResult.asObservable()
    }
    
    /// Call method of network service manager to update password netwrok on server
    /// - Parameters:
    ///   - newPassword: Entered network password by user
    ///   - interface: type of band
    /// - returns:
    ///   - status: status update success API response
    ///   - error: if any error come in API response
    ///   - interface: for which network band
    func updateNetworkPassword(newPassword: String, forInterface interface: String) -> Observable<(status: Bool?, error: String?, interface: String?)> {
        let updateNetworkPasswordResult = PublishSubject<(status: Bool?, error: String?, interface: String?)>()
        networkServiceManager.updateNetworkPassword(newPassword: newPassword, forInterface: interface)
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    do {
                        let details = try JSONDecoder().decode(NetworkResponse.self, from: response)
                        if details.code == Constants.Common.networkResponseSucessStatusCode {
                            updateNetworkPasswordResult.onNext((true, nil, interface))
                        } else {
                            updateNetworkPasswordResult.onNext((false, details.message?.description, interface))
                        }
                        updateNetworkPasswordResult.onCompleted()
                    } catch {
                        updateNetworkPasswordResult.onNext((nil, ServiceManager.getErrorMessage(forError: error), interface))
                        updateNetworkPasswordResult.onCompleted()
                    }
                case .failure(let error):
                    updateNetworkPasswordResult.onNext((nil, ServiceManager.getErrorMessage(forError: error), interface))
                    updateNetworkPasswordResult.onCompleted()
                }
            })
            .disposed(by: disposeBag)
        return updateNetworkPasswordResult.asObservable()
    }
    
    /// Call method of network service manager to update SSID/network name on server
    /// - Parameters:
    ///   - newSSID: Entered network name by user
    ///   - interface: type of band
    /// - returns:
    ///   - status: status update success API response
    ///   - error: if any error come in API response
    ///   - interface: for which network band
    func updateNetworkSSID(newSSID: String, forInterface interface: String) -> Observable<(status: Bool?, error: String?, interface: String?)> {
        let updateNetworkSSIDResult = PublishSubject<(status: Bool?, error: String?, interface: String?)>()
        networkServiceManager.updateNetworkSSID(newSSID: newSSID, forInterface: interface)
            .subscribe(onNext: { result in
                switch result {
                case .success(let response):
                    do {
                        let details = try JSONDecoder().decode(NetworkResponse.self, from: response)
                        if details.code == Constants.Common.networkResponseSucessStatusCode {
                            updateNetworkSSIDResult.onNext((true, nil, interface))
                        } else {
                            updateNetworkSSIDResult.onNext((false, details.message?.description, interface))
                        }
                        updateNetworkSSIDResult.onCompleted()
                    } catch {
                        updateNetworkSSIDResult.onNext((nil, ServiceManager.getErrorMessage(forError: error), interface))
                        updateNetworkSSIDResult.onCompleted()
                    }
                case .failure(let error):
                    updateNetworkSSIDResult.onNext((nil, ServiceManager.getErrorMessage(forError: error), interface))
                    updateNetworkSSIDResult.onCompleted()
                }
            })
            .disposed(by: disposeBag)
        return updateNetworkSSIDResult.asObservable()
    }
}
