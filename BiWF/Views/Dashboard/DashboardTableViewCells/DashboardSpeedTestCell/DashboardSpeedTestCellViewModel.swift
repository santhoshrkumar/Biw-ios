//
//  DashboardSpeedTestCellViewModel.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/17/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
/*
 DashboardSpeedTestCellViewModel handles the speed test on dashboard
 */
class DashboardSpeedTestCellViewModel {
    
    /// Input structure
    struct Input {

    }

    /// Output structure
    struct Output {
        let speedTestViewModelObservable: Observable<SpeedTestViewModel>
    }

    /// Input/Output structure variables
    let input: Input
    let output: Output
    
    /// Holds networkRepository with strong reference
    private let networkRepository: NetworkRepository
    
    private let speedTestViewModelSubject = BehaviorSubject<SpeedTestViewModel>(value: SpeedTestViewModel(with: nil))
    private let disposeBag = DisposeBag()
    private var speedTestViewModelDisposeBag = DisposeBag()

    /// Initializes a new instance of networkRepository
    /// - Parameter networkRepository : to get api values on network
    init(networkRepository: NetworkRepository) {
        self.networkRepository = networkRepository
        input = Input()
        output = Output(speedTestViewModelObservable: speedTestViewModelSubject.asObservable())
        
        networkRepository.speedTestSubject.map { [weak self] speedTest -> SpeedTestViewModel in
                guard let self = self else { return SpeedTestViewModel(with: nil) }
                let speedTestViewModel = SpeedTestViewModel(with: speedTest)
                self.setupBindings(with: speedTestViewModel)
                return speedTestViewModel
            }.bind(to: speedTestViewModelSubject.asObserver())
            .disposed(by: disposeBag)
    }

    /// Initial setup on speed test run
    private func setupBindings(with speedTestViewModel: SpeedTestViewModel) {
        speedTestViewModelDisposeBag = DisposeBag()
        speedTestViewModel.output.runSpeedTestObservable.subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.networkRepository.runSpeedTest()
            }).disposed(by: speedTestViewModelDisposeBag)

        networkRepository.isRunningSpeedTestSubject
            .bind(to: speedTestViewModel.input.isSpeedTestRunningObserver)
            .disposed(by: speedTestViewModelDisposeBag)
    }
}
