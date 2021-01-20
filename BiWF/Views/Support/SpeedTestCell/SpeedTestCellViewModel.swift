
//
//  SpeedTestCellViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 10/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxCocoa
import RxSwift
/*
 SpeedTestCellViewModel to handle the speed test 
 */
class SpeedTestCellViewModel {
    
    ///Constants
    enum Constants {
        static let restartModemText = "RestartModem".localized
        static let needHelpText = "NeedHelp".localized
        static let visitWebsiteText = "VisitWebsite".localized
    }
    
    /// Output structure
    struct Output {
        let restartModemTextDriver: Driver<String>
        let needHelpTextDriver: Driver<String>
        let visitWebsiteTextDriver: Driver<String>
        let speedTestViewModelObservable: Observable<SupportSpeedTestViewModel>
    }
    
    /// Output structure constant
    let output: Output
    
    /// Subject to handle run speed test
    let runSpeedTestSubject = PublishSubject<Void>()
    
    /// Subject to handle  restart modem
    let restartModemSubject = PublishSubject<Void>()
    
    /// Subject to handle viewstatus
    let visitWebsiteSubject = PublishSubject<Void>()
    
    let speedTestViewModelSubject = BehaviorSubject<SupportSpeedTestViewModel>(value: SupportSpeedTestViewModel(with: nil))
    
    private let disposeBag = DisposeBag()
    private var speedTestViewModelDisposeBag = DisposeBag()

    /// Holds networkRepository with strong reference
    private let networkRepository: NetworkRepository
    
    /// Initialize a new instance of  NetworkRepository
    /// - Parameter networkRepository : gives the api values with respect to network
    init(with networkRepository: NetworkRepository) {
        self.networkRepository = networkRepository
        
        output = Output(
            restartModemTextDriver: .just(Constants.restartModemText),
            needHelpTextDriver: .just(Constants.needHelpText),
            visitWebsiteTextDriver: .just(Constants.visitWebsiteText),
            speedTestViewModelObservable: speedTestViewModelSubject.asObservable()
        )
        
        networkRepository.speedTestSubject.map { [weak self] speedTest -> SupportSpeedTestViewModel in
                guard let self = self else { return SupportSpeedTestViewModel(with: nil) }
                let speedTestViewModel = SupportSpeedTestViewModel(with: speedTest)
                self.setupBindings(with: speedTestViewModel)
                return speedTestViewModel
            }.bind(to: speedTestViewModelSubject.asObserver())
            .disposed(by: disposeBag)
    }

    ///Binding the speed test run
    /// - Parameter speedTestViewModel : Contains speed test events from support
    private func setupBindings(with speedTestViewModel: SupportSpeedTestViewModel) {
        speedTestViewModelDisposeBag = DisposeBag()
        speedTestViewModel.runSpeedTestSubject.subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.runSpeedTestSubject.onNext(())
            }).disposed(by: speedTestViewModelDisposeBag)

        networkRepository.isRunningSpeedTestSubject
            .bind(to: speedTestViewModel.input.isSpeedTestRunningObserver)
            .disposed(by: speedTestViewModelDisposeBag)
    }
}
