//
//  ModemRestartManager.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 06/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa

class ModemRestartManager {
    
    enum ModemState {
        case restartModem
        case restarting
        case isOnline
    }
    
    let restartModemStatusSubject = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    
    var networkRepository: NetworkRepository?
    var isModemOnline = false
    var isRebooting: ModemState = .restartModem
    
    static let shared: ModemRestartManager = {
        let instance = ModemRestartManager()
        return instance
    }()
    
    func restartModem() {
        updateInitialValues()
        subscribeRebootResponse()
        networkRepository?.restartModem()
    }
    
    func subscribeRebootResponse() {
        networkRepository?.errorMessageModemRestartSubject
            .subscribe(onNext: { error in
                self.updateErrorState(shouldDisplayAlert: true)
            }).disposed(by: self.disposeBag)
        
        networkRepository?.isModemRestartedSubject
            .subscribe(onNext: { isRebooting in
                if isRebooting {
                    self.checkModemStatusPoll(subscribeAfter: Constants.Common.modemStatusDispatchTime)
                } else {
                    self.updateErrorState(shouldDisplayAlert: true)
                }
            }).disposed(by: self.disposeBag)
    }
}

//MARK:- Show alerts and handle initial/error/sucess conditions
extension ModemRestartManager {
    
    func showAlert() {
        AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.restartModemFailure)
        AlertPresenter.showRetryErrorAlert(title: Constants.Common.restartComplete,
                                           message: Constants.Common.restartCompleteMessage,
                                           retryAction: {
                                                self.restartModem()
                                           },
                                           cancelAction: {
                                               self.updateErrorState(shouldDisplayAlert: false)
                                           }, leftButtonTitle:  Constants.Common.cancel.capitalized,
                                              rightButtonTitle: Constants.Common.retry)
    }
    
    func showSuccessAlert() {
        AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.restartModemSuccess)
        AlertPresenter.showCustomAlertViewController(title: Constants.SpeedTest.successAlert,
                                                     message: Constants.SpeedTest.modemRebooting.attributedString(),
                                                     buttonText: Constants.SpeedTest.close.capitalized)
    }
    
    func updateInitialValues() {
        isModemOnline = false
        networkRepository = NetworkRepository()
        isRebooting = .restarting
        ModemRestartManager.setValueInDefaults(value: true,
                                               forKey: Constants.Common.isModemRebootingDefualtsKey)
        restartModemStatusSubject.onNext(false)
    }
    
    func updateErrorState(shouldDisplayAlert: Bool) {
        ModemRestartManager.setValueInDefaults(value: false,
                                               forKey: Constants.Common.isModemRebootingDefualtsKey)
        isRebooting = .restartModem
        restartModemStatusSubject.onNext(true)
        if shouldDisplayAlert {
            showAlert()
        }
        networkRepository = nil
    }
    
    func updateSuccessState() {
        isRebooting = .restartModem
        ModemRestartManager.setValueInDefaults(value: false,
                                               forKey: Constants.Common.isModemRebootingDefualtsKey)
        restartModemStatusSubject.onNext(true)
        networkRepository = nil
        showSuccessAlert()
    }
    
    //Provide is modem state as rebooting/not
    func isModemRebooting() -> Bool {
        return ModemRestartManager.getValueFromDefaults(forKey: Constants.Common.isModemRebootingDefualtsKey)
    }

}

//MARK:- Modem status handling
extension ModemRestartManager {
    
    func checkModemStatusPoll(subscribeAfter: Int) {
        if networkRepository == nil {
            networkRepository = NetworkRepository()
        }
        
        //Dispatch after sometime to handle instant response just after triggering which may be online and triggered by poll at same instance
        let dispatchAfter = DispatchTimeInterval.seconds(subscribeAfter)
        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) {
            self.subscribeModemResponse()
        }
        //Check if timer till 5 minutes
        DispatchQueue.main.asyncAfter(deadline: .now() + (5 * 60)) {
            if self.isModemRebooting() {
                if self.isModemOnline {
                    self.updateSuccessState()
                } else {
                    self.updateErrorState(shouldDisplayAlert: true)
                }
            }
        }
    }
    
    func subscribeModemResponse() {

        networkRepository?.errorMessageSubject
            .subscribe(onNext: { error in
                //Nothing to be done until 5 minute
            }).disposed(by: self.disposeBag)

        networkRepository?.isModemOnlineSubject
            .subscribe(onNext: { isOnline in
                if isOnline && self.isModemRebooting() {
                    self.isModemOnline = true
                    self.updateSuccessState()
                }
            }).disposed(by: self.disposeBag)
    }
    
    static func setValueInDefaults(value: Bool, forKey key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    static func getValueFromDefaults(forKey key: String) -> Bool {
        let value = UserDefaults.standard.bool(forKey: key)
        return value
    }
}
