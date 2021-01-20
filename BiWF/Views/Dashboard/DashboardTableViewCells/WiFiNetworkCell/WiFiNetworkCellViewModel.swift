//
//  WiFiNetworkCellViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 29/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
/*
 WiFiNetworkCellViewModel handles wifi network
 */
class WiFiNetworkCellViewModel {
    
    /// Input structure
    struct Input {
        let expandQRCodeObserver: AnyObserver<WiFiNetwork>
    }
    
    /// Output structure
    struct Output {
        let myNetworkViewModelObservable: Observable<WifiNetworkViewModel>
        let guestNetworkViewModelObservable: Observable<WifiNetworkViewModel>
        let expandQRCodeObservable: Observable<WiFiNetwork>
        let neworkButtonTapObservable: Observable<WiFiNetwork>
    }
    
    /// Input/Output structure variables
    let input: Input
    let output: Output
    
    /// Subject to handle expand qr code
    private let expandQRCodeTapSubject = PublishSubject<WiFiNetwork>()
    
    /// Subject to handle network button tap
    private let neworkButtonTapSubject = PublishSubject<WiFiNetwork>()
    
    private let disposeBag = DisposeBag()
    
    /// Initializes a new instance of AppointmentRepository and NetworkRepository
    /// - Parameter myNetwork  : gets the wifi network values
    /// guestNetwork : gets the guest network  values
    init(with myNetwork: WiFiNetwork, and guestNetwork: WiFiNetwork) {
        input = Input(expandQRCodeObserver: expandQRCodeTapSubject.asObserver())

        let myNetworkViewModel = WifiNetworkViewModel(with: myNetwork)
        let guestNetworkViewModel = WifiNetworkViewModel(with: guestNetwork)
        
        output = Output(myNetworkViewModelObservable: .just(myNetworkViewModel),
                        guestNetworkViewModelObservable: .just(guestNetworkViewModel),
                        expandQRCodeObservable: expandQRCodeTapSubject.asObservable(),
                        neworkButtonTapObservable: neworkButtonTapSubject.asObservable())
        
        myNetworkViewModel.output.expandQRCodeObservable.subscribe(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.expandQRCodeTapSubject.onNext(myNetwork)
        }).disposed(by: disposeBag)
        
        guestNetworkViewModel.output.expandQRCodeObservable.subscribe(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.expandQRCodeTapSubject.onNext(guestNetwork)
        }).disposed(by: disposeBag)
        
        myNetworkViewModel.output.networkEnableDisableObservable.subscribe(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.neworkButtonTapSubject.onNext(myNetwork)
        }).disposed(by: disposeBag)
        
        guestNetworkViewModel.output.networkEnableDisableObservable.subscribe(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.neworkButtonTapSubject.onNext(guestNetwork)
        }).disposed(by: disposeBag)
    }
}
