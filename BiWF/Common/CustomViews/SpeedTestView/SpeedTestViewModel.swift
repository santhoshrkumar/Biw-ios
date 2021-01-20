//
//  SpeedTestViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 13/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
/*
    SpeedTestViewModel to handle SpeedTest details
**/
class SpeedTestViewModel {
    
    /// Enum for localized string  
    enum Constants {
        static let lastTestText = "LastSpeedTest".localized
        static let runNewTestText = "RunNewTest".localized
        static let uploadMbpsText = "mbpsUpload".localized
        static let downloadMbpsText = "mbpsDownload".localized
    }
    
    /// Output structure  lo handle output events
    struct Output {
        let lastTestTextDriver: Driver<NSAttributedString>
        let runNewTestTextDriver: Driver<String>
        let uploadSpeedTextDriver: Driver<String>
        let downloadSpeedTextDriver: Driver<String>
        let uploadMbpsTextDriver: Driver<String>
        let downloadMbpsTextDriver: Driver<String>
        let runSpeedTestObservable: Observable<Void>
        let isSpeedTestRunningDriver: Driver<Bool>
        let enableSpeedTestDriver: Driver<Bool>
    }
    
    /// Input structure to handle input events
    struct Input {
        let runSpeedTestObserver: AnyObserver<Void>
        let isSpeedTestRunningObserver: AnyObserver<Bool>
    }
    
    /// Input/Output structure variables
    let output: Output
    let input: Input
    private let runSpeedTestSubject = PublishSubject<Void>()
    private let isSpeedTestRunningSubject = BehaviorSubject<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    /// Initializes a new instance of SpeedTestViewModel
    /// - Parameter
    ///     - speedTest : speed test detail
    init(with speedTest: SpeedTest?) {
        let speedTest = speedTest ?? SpeedTest(uploadSpeed: "- -", downloadSpeed: "- -", timeStamp: "- -")
        
        let lastTestText = NSMutableAttributedString(string: Constants.lastTestText, attributes:  [.font: UIFont.bold(ofSize: 12),
                                                                                                   .foregroundColor: UIColor.BiWFColors.med_grey])
        let testDateTime = NSAttributedString(string: speedTest.formattedTime, attributes:  [.font: UIFont.regular(ofSize: 12),
                                                                                         .foregroundColor: UIColor.BiWFColors.med_grey])
        
        ///Creating lastTestText attributed string with different font and text color for view
        lastTestText.append(testDateTime)

        let isModemRestartingSubject = BehaviorSubject<Bool>(value: ModemRestartManager.shared.isModemRebooting())

        let enableSpeedTestDriver = Observable.combineLatest(isModemRestartingSubject, isSpeedTestRunningSubject)
            .map { isRestarting, isTestRunning -> Bool in
                return !isTestRunning && !isRestarting
            }.asDriver(onErrorJustReturn: true)
        
        output = Output(lastTestTextDriver: .just(lastTestText),
                        runNewTestTextDriver: .just(Constants.runNewTestText),
                        uploadSpeedTextDriver: .just(speedTest.uploadSpeed),
                        downloadSpeedTextDriver: .just(speedTest.downloadSpeed),
                        uploadMbpsTextDriver: .just(Constants.uploadMbpsText),
                        downloadMbpsTextDriver: .just(Constants.downloadMbpsText),
                        runSpeedTestObservable: runSpeedTestSubject.asObservable(),
                        isSpeedTestRunningDriver: isSpeedTestRunningSubject.asDriver(onErrorJustReturn: false),
                        enableSpeedTestDriver: enableSpeedTestDriver
        )
        
        input = Input(runSpeedTestObserver: runSpeedTestSubject.asObserver(),
                      isSpeedTestRunningObserver: isSpeedTestRunningSubject.asObserver()
        )

        ///restartModemStatusSubject bind to isModemRestartingSubject to get modem state
        ModemRestartManager.shared.restartModemStatusSubject
            .map { !$0 }
            .bind(to: isModemRestartingSubject)
            .disposed(by: disposeBag)
    }
}

