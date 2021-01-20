//
//  RestartModemViewModel.swift
//  BiWF
//
//  Created by Amruta Mali on 09/11/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift
/*
 RestartModemViewModel to handle the restart modem when speed test is not available
 */
class RestartModemViewModel {
    /// Input structure to handle input events
    struct Input {
        let restartModemObserver: AnyObserver<Void>
    }
    /// Output structure  lo handle output events
    struct Output {
        let restartModemTextDriver: Driver<String>
        let restartButtonStateDriver: Driver<ModemRestartManager.ModemState>
    }
    
    /// restartModem subject to handle restart modem tap tap
    let restartModemSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let networkRepository: NetworkRepository
    private(set) var isModemOnline: Bool = false
    
    var style: ButtonStyle {
     isModemOnline ? .bordered : .disabledBordered
    }
    
    let output: Output
    let input: Input
    
    /// Initialize a new instance of  RestartModemViewModel
    init(networkRepository: NetworkRepository) {
        self.networkRepository = networkRepository
        let restartButtonState: ModemRestartManager.ModemState = ModemRestartManager.shared.isModemRebooting() ? .restarting : .restartModem
        let restartButtonStateSubject = BehaviorSubject<ModemRestartManager.ModemState>(value: restartButtonState)
        
        input = Input(restartModemObserver: restartModemSubject.asObserver())
        
        output = Output(restartModemTextDriver: .just(Constants.SpeedTest.troubleshootingRestartModemText),
                        restartButtonStateDriver: restartButtonStateSubject.asDriver(onErrorJustReturn: .restartModem))
        
        
        ///Handle restart modem tap
        restartModemSubject.subscribe(onNext: { _ in
            restartButtonStateSubject.onNext(.restarting)
            self.restartModem()
        }).disposed(by: disposeBag)
        
        ///Suscribe restartModemStatusSubject of ModemRestartManager for getting response of modem state
        ModemRestartManager.shared.restartModemStatusSubject.subscribe(onNext: { success in
            if success {
                restartButtonStateSubject.onNext(.restartModem)
            } else {
                restartButtonStateSubject.onNext(.restarting)
            }
        }).disposed(by: self.disposeBag)
        
        // Check if modem is online
        networkRepository.isModemOnlineSubject.asObservable().subscribe(onNext: {[weak self] isOnline in
            guard let self = self else { return }
            self.isModemOnline = isOnline
        }).disposed(by: disposeBag)
    }
    
    ///Restart Modem callling function of ModemRestartManager to restart
    func restartModem() {
        ModemRestartManager.shared.restartModem()
    }
    
    ///Calling ModemRestartManager function to check status of modem
    func checkModemStatus() {
        ModemRestartManager.shared.checkModemStatusPoll(subscribeAfter: Constants.Common.modemSubscribeDispatchTime)
    }
}
