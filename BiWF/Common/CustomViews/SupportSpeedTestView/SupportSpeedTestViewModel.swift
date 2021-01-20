//
//  SupportSpeedTestViewModel.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 03/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
/*
    SupportSpeedTestViewModel to handle SpeedTest details on support
**/
class SupportSpeedTestViewModel {
    
    /// Input structure to handle input events
    struct Input {
        let runSpeedTestTappedObserver: AnyObserver<Void>
        let restartModemTappedObserver: AnyObserver<Void>
        let isSpeedTestRunningObserver: AnyObserver<Bool>
    }
    
    /// Output structure  lo handle output events
    struct Output {
        let lastTestTextDriver: Driver<NSAttributedString>
        let runNewTestTextDriver: Driver<String>
        let uploadSpeedTextDriver: Driver<String>
        let downloadSpeedTextDriver: Driver<String>
        let uploadMbpsTextDriver: Driver<String>
        let downloadMbpsTextDriver: Driver<String>
        let restartModemTextDriver: Driver<String>
        let isSpeedTestRunningDriver: Driver<Bool>
        let enableSpeedTestDriver: Driver<Bool>
        let restartButtonStateDriver: Driver<ModemRestartManager.ModemState>
    }
    /// runSpeedTest subject to handle run speed test tap
    let runSpeedTestSubject = PublishSubject<Void>()
    
    /// restartModem subject to handle restart modem tap tap
    let restartModemSubject = PublishSubject<Void>()
    
    /// isSpeedTestRunning subject to handle state of UI during speed test enable/disable
    let isSpeedTestRunningSubject = BehaviorSubject<Bool>(value: false)
    let showAlertSubject = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    
    /// Input/Output structure variables
    let output: Output
    let input: Input

    /// Initializes a new instance of SupportSpeedTestViewModel
    /// - Parameter
    ///     - speedTest : speed test detail
    init(with speedTest: SpeedTest?) {
        let speedTest = speedTest ?? SpeedTest(uploadSpeed: "- -", downloadSpeed: "- -", timeStamp: "- -")
        input = Input(runSpeedTestTappedObserver: runSpeedTestSubject.asObserver(),
                      restartModemTappedObserver: restartModemSubject.asObserver(),
                      isSpeedTestRunningObserver: isSpeedTestRunningSubject.asObserver()
        )
        let restartButtonState: ModemRestartManager.ModemState = ModemRestartManager.shared.isModemRebooting() ? .restarting : .restartModem
        let restartButtonStateSubject = BehaviorSubject<ModemRestartManager.ModemState>(value: restartButtonState)
        let lastTestText = NSMutableAttributedString(string: Constants.SpeedTest.lastTestText,
                                                     attributes:  [.font: UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.BiWFColors.dark_grey])
        let testDateTime = NSAttributedString(string: speedTest.formattedTime,
                                              attributes:  [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.BiWFColors.dark_grey])
        lastTestText.append(testDateTime)

        let enableSpeedTestDriver = Observable.combineLatest(restartButtonStateSubject, isSpeedTestRunningSubject)
            .map { restartState, isTestRunning -> Bool in
                return !isTestRunning && restartState != .restarting
            }.asDriver(onErrorJustReturn: true)
        
        output = Output(lastTestTextDriver: .just(lastTestText),
                        runNewTestTextDriver: .just(Constants.SpeedTest.runNewTestText),
                        uploadSpeedTextDriver: .just(speedTest.uploadSpeed),
                        downloadSpeedTextDriver: .just(speedTest.downloadSpeed),
                        uploadMbpsTextDriver: .just(Constants.SpeedTest.supportUploadMbpsText),
                        downloadMbpsTextDriver: .just(Constants.SpeedTest.downloadMbpsText),
                        restartModemTextDriver: .just(Constants.SpeedTest.restartModemText),
                        isSpeedTestRunningDriver: isSpeedTestRunningSubject.asDriver(onErrorJustReturn: false),
                        enableSpeedTestDriver: enableSpeedTestDriver,
                        restartButtonStateDriver: restartButtonStateSubject.asDriver(onErrorJustReturn: .restartModem)
        )
        
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
