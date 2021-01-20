//
//  NetworkViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 12/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
/*
NetworkViewModel to handle network information
*/
class NetworkViewModel {
    
    /// Input structure
    struct Input {
        let enableDisableTapObserver: AnyObserver<Void>
        let networkNameObserver: AnyObserver<String>
        let networkPasswordObserver: AnyObserver<String>
        let textFieldDidBeginEditingObserver: AnyObserver<Void>
        let textFieldDidEndEditingObserver: AnyObserver<Void>
    }
    
    /// Output structure
    struct Output {
        let titleDriver: Driver<String>
        let errorDriver: Driver<String>
        let networkNameDriver: Driver<String>
        let networkNameValueDriver: Driver<String>
        let passwordDriver: Driver<String>
        let passwordValueDriver: Driver<String>
        let passwordDescriptionDriver: Driver<String>
        let buttonTextDriver: Driver<String>
        let tapToEnableDisableDriver: Driver<String>
        let networkEnableDisableDriver: Driver<Bool>
        let networkNameStateDriver: Driver<ViewState>
        let networkPasswordStateDriver: Driver<ViewState>
        let enableDisableTapObservable: Observable<Void>
        let networkNameObservable: Observable<String>
        let networkPasswordObservable: Observable<String>
        let textFieldDidBeginEditingObservable: Observable<Void>
        let textFieldDidEndEditingObservable: Observable<Void>
    }
    
    /// Subject to handle enable/disable button tap
    private let enableDisableTapSubject = PublishSubject<Void>()
    
    /// Subject to handle network names
    private let networkNameSubject =  PublishSubject<String>()
    
    /// Subject to handle network password
    private let networkPasswordSubject =  PublishSubject<String>()
    
    /// Subject to handle textField delegates
    private let textFieldDidBeginEditingSubject = PublishSubject<Void>()
    private let textFieldDidEndEditingSubject = PublishSubject<Void>()
    
    /// Input/Output structure variables
    let input: Input
    let output: Output
    
    /// Holds WiFiNetwork with strong reference
    let networkInfo: WiFiNetwork
    
    /// Initializes a new instance of WiFiNetwork
    /// - Parameter networkInfo : contains all values of wifinetwork
    init(with networkInfo: WiFiNetwork) {
        self.networkInfo = networkInfo
        
        input = Input(enableDisableTapObserver: enableDisableTapSubject.asObserver(),
                      networkNameObserver: networkNameSubject.asObserver(),
                      networkPasswordObserver: networkPasswordSubject.asObserver(),
                      textFieldDidBeginEditingObserver: textFieldDidBeginEditingSubject.asObserver(),
                      textFieldDidEndEditingObserver: textFieldDidEndEditingSubject.asObserver())
        
        let title = networkInfo.isGuestNetwork ? Constants.NetworkInfo.guestNetwork : Constants.NetworkInfo.wifiNetwork
        let tapToEnableDisableText = "\(networkInfo.isEnabled ? Constants.NetworkInfo.tapToDisable : Constants.NetworkInfo.tapToEnable) \(networkInfo.isGuestNetwork ? Constants.NetworkInfo.guestNetwork : Constants.NetworkInfo.network)"
        
        output = Output(titleDriver: .just(title),
                        errorDriver: .just(Constants.Common.fieldRequired),
                        networkNameDriver: .just(networkInfo.isGuestNetwork ? Constants.NetworkInfo.guestNetworkName : Constants.NetworkInfo.networkName),
                        networkNameValueDriver: .just(networkInfo.name),
                        passwordDriver: .just(networkInfo.isGuestNetwork ? Constants.NetworkInfo.guestNetworkPassword : Constants.NetworkInfo.networkPassword),
                        passwordValueDriver: .just(networkInfo.password),
                        passwordDescriptionDriver: .just(Constants.NetworkInfo.networkPasswordDescription),
                        buttonTextDriver: .just("\(title) \(networkInfo.isEnabled ? Constants.NetworkInfo.enabled : Constants.NetworkInfo.disabled)"),
                        tapToEnableDisableDriver: .just(tapToEnableDisableText.lowercased()),
                        networkEnableDisableDriver: .just(networkInfo.isEnabled),
                        networkNameStateDriver: .just(networkInfo.nameState),
                        networkPasswordStateDriver: .just(networkInfo.passwordState),
                        enableDisableTapObservable: enableDisableTapSubject.asObservable(),
                        networkNameObservable: networkNameSubject.asObservable(),
                        networkPasswordObservable: networkPasswordSubject.asObservable(),
                        textFieldDidBeginEditingObservable: textFieldDidBeginEditingSubject.asObservable(),
                        textFieldDidEndEditingObservable: textFieldDidEndEditingSubject.asObservable())
    }
}
