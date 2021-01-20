//
//  NetworkDetailCellViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 13/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NetworkDetailCellViewModel {
    
    struct Input {
    }
    
    /// Output structure
    struct Output {
        let networkViewModelObservable: Observable<NetworkViewModel>
        let networkNameObservable: Observable<String>
        let networkPasswordObservable: Observable<String>
        let textFieldDidBeginEditingObservable: Observable<Void>
        let textFieldDidEndEditingObservable: Observable<Void>
        let enableDisableTapObservable: Observable<Void>
    }
    
    /// Input & Output structure variable
    let input: Input
    let output: Output
    
    // MARK: - Subject
    /// Subject to show network name and password
    private let networkNameSubject =  PublishSubject<String>()
    private let networkPasswordSubject =  PublishSubject<String>()
    /// Subject to handle tesxtField
    private let textFieldDidBeginEditingSubject = PublishSubject<Void>()
    private let textFieldDidEndEditingSubject = PublishSubject<Void>()
    /// Subject to handle enable disable tap
    private let enableDisableTapSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    /// Initializes a new instance of NetworkDetailCell ViewModel with
    /// - Parameter networkInfo: Wifi network information
    init(with networkInfo: WiFiNetwork) {
        input = Input()
        
        let networkViewModel = NetworkViewModel(with: networkInfo)
        output = Output(networkViewModelObservable: .just(networkViewModel),
                        networkNameObservable: networkNameSubject.asObservable(),
                        networkPasswordObservable: networkPasswordSubject.asObserver(),
                        textFieldDidBeginEditingObservable: textFieldDidBeginEditingSubject.asObservable(),
                        textFieldDidEndEditingObservable: textFieldDidEndEditingSubject.asObservable(),
                        enableDisableTapObservable: enableDisableTapSubject.asObservable()
        )
        
        networkViewModel.output.networkNameObservable
            .bind(to: networkNameSubject)
            .disposed(by: disposeBag)
        
        networkViewModel.output.networkPasswordObservable
            .bind(to: networkPasswordSubject)
            .disposed(by: disposeBag)
        
        networkViewModel.output.textFieldDidBeginEditingObservable
            .bind(to: textFieldDidBeginEditingSubject)
            .disposed(by: disposeBag)
        
        networkViewModel.output.textFieldDidEndEditingObservable
            .bind(to: textFieldDidEndEditingSubject)
            .disposed(by: disposeBag)
        
        networkViewModel.output.enableDisableTapObservable
        .bind(to: enableDisableTapSubject)
        .disposed(by: disposeBag)
    }
}
