//
//  TabViewModel.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/6/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
import LocalAuthentication
/*
 TabViewModel to handle the tab bars
 */
struct TabViewModel {
    
    enum Tabs: Int {
        case account = 0
        case dashboard
        case device
    }
    
    /// Input structure
    struct Input {
        let goToDevicesObserver: AnyObserver<Void>
        let addDeviceTabObserver: AnyObserver<Bool>
    }
    
    /// Output structures
    struct Output {
        let headerViewModelObservable: Observable<TabHeaderViewModel>
        let supportButtonViewModelObservable: Observable<SupportButtonViewModel>
        let viewComplete: Observable<TabCoordinator.Event>
    }
    
    /// Input/Output structure variables
    let input: Input
    let output: Output
    
    /// Subject to handle device screen navigation
    private let goToDevicesSubject = PublishSubject<Void>()
    
    /// Subject to handle logout
    let logoutSubject = PublishSubject<Void>()
    
    /// Subject to handle biometric
    let checkBiometricAuthSubject = PublishSubject<Void>()
    
    /// Subject to handle device screen addition in scrollview
    private let addDeviceTabSubject = PublishSubject<Bool>()
    
    private let disposeBag = DisposeBag()
    
    var biometricTypeString: String {
        if Biometrics.enabledBiometricType() == .faceID {
            return Constants.Biometric.welcomeAlertMessageFaceID
        }
        return Constants.Biometric.welcomeAlertMessageTouchID
    }
    
    /// Initializes a new instance of AppointmentRepository and NetworkRepository
    /// - Parameter appointmentRepository : to get api values on appointment
    /// networkRepository : to get api values on network
    init(appointmentRepository: AppointmentRepository, networkRepository: NetworkRepository) {
        input = Input(
            goToDevicesObserver: goToDevicesSubject.asObserver(),
            addDeviceTabObserver: addDeviceTabSubject.asObserver()
        )
        
        let headerViewModel = TabHeaderViewModel(
            appointmentRepository: appointmentRepository,
            networkRepository: networkRepository
        )
        let logoutObservable = logoutSubject.asObservable().map  { _  in
            return TabCoordinator.Event.goToLogout
        }
        
        let viewCompleteObservable = Observable.merge(logoutObservable)
        
        output = Output(
            headerViewModelObservable: Observable.just(headerViewModel),
            supportButtonViewModelObservable: Observable.just(SupportButtonViewModel()),
            viewComplete: viewCompleteObservable
        )
        
        goToDevicesSubject.asObservable()
            .bind(to: headerViewModel.input.goToDevicesObserver)
            .disposed(by: disposeBag)
        
        checkBiometricAuthSubject.subscribe(onNext: {_ in
            Biometrics.checkBiometricAuthentication()
        }).disposed(by: disposeBag)
    }
}
