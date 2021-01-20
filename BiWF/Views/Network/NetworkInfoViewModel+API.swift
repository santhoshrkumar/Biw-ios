//
//  NetworkViewModel+API.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 20/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
/*
 NetworkInfoViewModel extension for API calling and other methode.
 **/
extension NetworkInfoViewModel {
    
    ///Update SSID for different network bands
    /// - Parameters:
    /// - interface: band value
    /// - newSSID: SSID service set identifier to update with
    func updateSSID(forInterface interface: String, newSSID: String) {
        
        //Assign band as per main/guest network
        let bands = getBandValues(forInterface: interface)
        let bandValue = bands.firstBand
        let anotherBandValue = bands.secondBand

        networkRepository.updateNetworkSSID(newSSID: newSSID, forInterface: bandValue)
            .subscribe(onNext: {[weak self] (status, error, responseInterface) in
                guard let self = self else { return }
                if let status = status, status == true {
                    if (responseInterface == bandValue) {
                        self.descreaseCountAndUpdateUI()
                        self.networkRepository.updateNetworkSSID(newSSID: newSSID, forInterface: anotherBandValue)
                            .subscribe(onNext: {[weak self] (status, error, nextInterface) in
                                guard self != nil else {return}
                                if let status = status, status == true {
                                    self?.descreaseCountAndUpdateUI()
                                }
                                if let error = error {
                                    let errorState = ViewStatus.error(errorMsg: error, retryButtonHandler: nil)
                                    self?.viewStatusSubject.onNext(errorState)
                                }
                            }).disposed(by: self.disposeBag)
                    }
                }
                if let error = error {
                    let errorState = ViewStatus.error(errorMsg: error, retryButtonHandler: nil)
                    self.viewStatusSubject.onNext(errorState)
                }
            }).disposed(by: self.disposeBag)
    }
    
    ///Update password for different network bands
    /// - Parameters:
    /// - interface: band value
    /// - newPassword: new password to update
    func updatePassword(forInterface interface: String, newPassword: String) {
        //Assign band as per main/guest network
        let bands = getBandValues(forInterface: interface)
        let bandValue = bands.firstBand
        let anotherBandValue = bands.secondBand

        networkRepository.updateNetworkPassword(newPassword: newPassword, forInterface: bandValue)
            .subscribe(onNext: {[weak self] (status, error, responseInterface) in
                guard let self = self else { return }
                if let status = status, status == true {
                    if (responseInterface == bandValue) {
                        self.descreaseCountAndUpdateUI()
                        self.networkRepository.updateNetworkPassword(newPassword: newPassword, forInterface: anotherBandValue)
                            .subscribe(onNext: {[weak self] (status, error, nextInterface) in
                                guard self != nil else {return}
                                if let status = status, status == true {
                                    self?.descreaseCountAndUpdateUI()
                                }
                                if let error = error {
                                    let errorState = ViewStatus.error(errorMsg: error, retryButtonHandler: nil)
                                    self?.viewStatusSubject.onNext(errorState)
                                }
                            }).disposed(by: self.disposeBag)
                    }
                }
                if let error = error {
                    let errorState = ViewStatus.error(errorMsg: error, retryButtonHandler: nil)
                    self.viewStatusSubject.onNext(errorState)
                }
            }).disposed(by: self.disposeBag)
    }
    
    ///Enable network for different network bands
    /// - Parameters:
    /// - interface: band value
    func enableNetwork(forInterface interface: String) {
        
        //Assign band as per main/guest network
        let bands = getBandValues(forInterface: interface)
        var bandValue = bands.firstBand
        var anotherBandValue = bands.secondBand
        
        //Check if the band is already in enabled(bssid) list
        if self.bssidInfo.values.contains(bandValue) {
            bandValue = anotherBandValue
            anotherBandValue = ""
        } else if self.bssidInfo.values.contains(anotherBandValue) {
            anotherBandValue = ""
        }
        indicatorViewStatusSubject.onNext(true)
        //Api call for first band
        networkRepository.enableNetwork(forInterface: bandValue)
            .subscribe(onNext: {[weak self] (status, error, responseInterface) in
                guard let self = self else { return }
                if let status = status, status == true {
                    //Check for the response interface network and if next band value is not empty
                    if (responseInterface == bandValue && anotherBandValue != "") {
                        //Call the second API after 1 minutes
                        DispatchQueue.main.asyncAfter(deadline: .now() + (Constants.Common.networkApiDelay)) {
                            self.networkRepository.enableNetwork(forInterface: anotherBandValue)
                                .subscribe(onNext: {[weak self] (status, error, nextInterface) in
                                    guard let self = self else { return }
                                    if let status = status, status == true {
                                        self.checkBandValue(interface: anotherBandValue, status: status, errorMessage: error, isEnabled: true)
                                    } else {
                                        self.indicatorViewStatusSubject.onNext(false)
                                        self.showErrorAlertSubject.onNext((true, bandValue))
                                    }
                                }).disposed(by: self.disposeBag)
                        }
                    }  else {
                        self.checkBandValue(interface: anotherBandValue, status: status, errorMessage: error, isEnabled: true)
                    }
                }
                if error != nil {
                    self.indicatorViewStatusSubject.onNext(false)
                    self.showErrorAlertSubject.onNext((true, bandValue))
                }
            }).disposed(by: self.disposeBag)
    }
    
    ///Disable network for different network bands
    /// - Parameters:
    /// - interface: band value
    func disableNetwork(forInterface interface: String) {
        
        //Assign band as per main/guest network
        let bands = getBandValues(forInterface: interface)
        var bandValue = bands.firstBand
        var anotherBandValue = bands.secondBand
        
        //Check if the band is in enabled(bssid) list
        if !self.bssidInfo.values.contains(bandValue) {
            bandValue = anotherBandValue
            anotherBandValue = ""
        } else if !self.bssidInfo.values.contains(anotherBandValue) {
            anotherBandValue = ""
        }
        
        indicatorViewStatusSubject.onNext(true)
        
        networkRepository.disableNetwork(forInterface: bandValue)
            .subscribe(onNext: {[weak self] (status, error, responseInterface) in
                guard let self = self else { return }
                
                if let status = status, status == true {
                    //Check for the response interface network and if next band value is not empty
                    if (responseInterface == bandValue && anotherBandValue != "") {
                        //Call the second API after 1 minutes
                        DispatchQueue.main.asyncAfter(deadline: .now() + (Constants.Common.networkApiDelay)) {
                            self.networkRepository.disableNetwork(forInterface: anotherBandValue)
                                .subscribe(onNext: {[weak self] (status, error, nextInterface) in
                                    guard let self = self else { return }
                                    if let status = status, status == true {
                                        self.checkBandValue(interface: anotherBandValue, status: status, errorMessage: error, isEnabled: false)
                                    } else {
                                        self.indicatorViewStatusSubject.onNext(false)
                                        self.showErrorAlertSubject.onNext((false, bandValue))
                                    }
                                }).disposed(by: self.disposeBag)
                        }
                    } else {
                        self.checkBandValue(interface: anotherBandValue, status: status, errorMessage: error, isEnabled: false)
                    }
                }
                if error != nil {
                    self.indicatorViewStatusSubject.onNext(false)
                    self.showErrorAlertSubject.onNext((false, bandValue))
                }
            }).disposed(by: self.disposeBag)
    }
    
    /// Check band value in bssid list
    /// - Parameters:
    /// - interface: band value
    /// - status: status response
    /// - errorMessage: check for error message
    func checkBandValue(interface: String?, status: Bool?, errorMessage: String?, isEnabled: Bool) {
        //Check for the wifi line info API response after 1 minutes, to check band value in bssid list
        DispatchQueue.main.asyncAfter(deadline: .now() + (Constants.Common.networkApiDelay)) {
            self.checkBssidValues(forInterface: interface ?? "").subscribe(onNext: {[weak self] (isBandPresent) in
                guard let self = self else { return }
                self.indicatorViewStatusSubject.onNext(false)
                if isBandPresent {
                    self.updateEnableDisableUI(for: interface ?? "", isEnabled: isEnabled)
                } else {
                    self.showErrorAlertSubject.onNext((isForEnable: isEnabled, interface: interface ?? ""))
                }
            }).disposed(by: self.disposeBag)
        }
    }
    
    ///Update UI according to enable disable status.
    /// - Parameters:
    /// - interface: band value
    /// - isEnabled: network status enable or disable
    func updateEnableDisableUI(for interface: String, isEnabled: Bool) {
        
        if interface == NetworkRepository.Bands.Band5G.rawValue || interface == NetworkRepository.Bands.Band2G.rawValue {
            self.myNetworkEnableDisableSubject.onNext(isEnabled)
        }
        
        else  if interface == NetworkRepository.Bands.Band5G_Guest.rawValue || interface == NetworkRepository.Bands.Band2G_Guest.rawValue {
            self.guestNetworkEnableDisableSubject.onNext(isEnabled)
        }
        
        self.setSections()
    }
    
    func compareValuesAndCallAPI() {
        do {
            let myNetworkName = try myNetworkNameSubject.value()
            let myNetworkPassword = try myNetworkPasswordSubject.value()
            let isMyNetworkEnabled = try myNetworkEnableDisableSubject.value()
            let guestNetworkName = try guestNetworkNameSubject.value()
            let guestNetworkPassword = try guestNetworkPasswordSubject.value()
            let isGuestNetworkEnabled = try guestNetworkEnableDisableSubject.value()
            
            if isMyNetworkEnabled {
                if myNetworkName != myNetwork.name {
                    networkAPICallsCount += 1
                    self.updateSSID(forInterface: NetworkRepository.Bands.Band2G.rawValue, newSSID: myNetworkName)
                }
                
                if myNetworkPassword != myNetwork.password {
                    networkAPICallsCount += 1
                    self.updatePassword(forInterface: NetworkRepository.Bands.Band2G.rawValue, newPassword: myNetworkPassword)
                }
            }
            
            if isGuestNetworkEnabled {
                networkAPICallsCount += 1
                if guestNetworkName != guestNetwork.name {
                    self.updateSSID(forInterface: NetworkRepository.Bands.Band2G_Guest.rawValue, newSSID: guestNetworkName)
                }
                
                if guestNetworkPassword != guestNetwork.password {
                    networkAPICallsCount += 1
                    self.updatePassword(forInterface: NetworkRepository.Bands.Band2G_Guest.rawValue, newPassword: guestNetworkPassword)
                }
            }
            if networkAPICallsCount > 0 {
                let loading = ViewStatus.loading(loadingText: "")
                viewStatusSubject.onNext(loading)
            }
        } catch {}
    }
    
    /// checkBssidValues from wifi-line info API response
    /// - Parameters:
    /// - interface: band value
    ///- returns: A Boolean value indicating whether the band is added/removed from bssid list or not
    func checkBssidValues(forInterface interface: String) -> Observable<Bool> {
        let isBandPresent = PublishSubject<Bool>()
        networkRepository.bssidMapSubject.subscribe(onNext: {[weak self] (bssidInfo) in
            guard let self = self else { return }
            self.bssidInfo = bssidInfo
            if bssidInfo.count == 0 {
                isBandPresent.onNext(false)
            } else if (bssidInfo.values.contains(NetworkRepository.Bands.Band2G.rawValue)) {
                isBandPresent.onNext(true)
            }
            isBandPresent.onCompleted()
        }).disposed(by: disposeBag)
        return isBandPresent.asObservable()
    }
    
    func descreaseCountAndUpdateUI() {
        networkAPICallsCount -= 1
        if networkAPICallsCount == 0 {
            self.viewStatusSubject.onNext(ViewStatus.loaded)
            self.input.doneObserver.onNext(())
        }
    }
    
    /// getBandValues
    /// - Parameters:
    /// - forInterface: band value
    ///- returns: both the Bands main/guest
    func getBandValues(forInterface interface: String) -> (firstBand: String, secondBand: String){
        var bandValue = NetworkRepository.Bands.Band2G.rawValue
        var anotherBandValue = NetworkRepository.Bands.Band5G.rawValue
        if (interface == NetworkRepository.Bands.Band2G_Guest.rawValue || interface == NetworkRepository.Bands.Band5G_Guest.rawValue) {
            bandValue = NetworkRepository.Bands.Band2G_Guest.rawValue
            anotherBandValue = NetworkRepository.Bands.Band5G_Guest.rawValue
        }
        return (bandValue, anotherBandValue)
    }
}
