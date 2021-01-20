//
//  SelectTimeModelView.swift
//  BiWF
//
//  Created by Amruta Mali on 14/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
/*
  SelectTimeViewController to handle time information required for schedule call back
*/
class SelectTimeViewModel {
    
    /// Input structure
    struct Input {
        let cancelTapObserver: AnyObserver<Void>
        let backTapObserver: AnyObserver<Void>
        let callMeTapObserver: AnyObserver<Void>
        let isAsapTimeSelectTapObserver: AnyObserver<Bool>
        let selectedDateObserver: AnyObserver<Date?>
        let selectedTimeObserver: AnyObserver<Date?>
    }
    
    /// Output structure
    struct Output {
        let callUsTextDriver: Driver<String>
        let nextAvailableTimeTextDriver: Driver<String>
        let availabelTimeInfoSubHeaderTextDriver: Driver<String>
        let dateObservable: Observable<Date?>
        let timeObservable: Observable<Date?>
        let isSelectedAsapTimeDriver: Observable<Bool>
        let startLoadingIndicatorObserver: Observable<Bool>
        let viewComplete: Observable<SupportCoordinator.Event>
    }
    
    /// Subject to handle cancel button tap
    private let cancelTapSubject = PublishSubject<Void>()
    
    /// Subject to handle back button tap
    private let backTapSubject = PublishSubject<Void>()
    
    /// Subject to handle call me button tap
    private let callMeTapSubject = PublishSubject<Void>()
    
    /// Subject to handle success on call me
    private let callMeSuccessSubject = PublishSubject<Void>()
    
    /// Subject to handle to view the status
    private let viewStatusSubject = PublishSubject<ViewStatus>()
    
    /// BehaviorSubject to select time and date
    private let selectDateSubject =  BehaviorSubject<Date?>(value: nil)
    private let selectTimeSubject =  BehaviorSubject<Date?>(value: nil)
    private let isAsapTimeSelectedSubject = BehaviorSubject<Bool>(value: true)
    private let startLoadingIndicatorSubject = BehaviorSubject<Bool>(value: false)
    let disposeBag = DisposeBag()
    
    /// Holds SupportRepository with strong reference
    private let supportRepository: SupportRepository

    /// Input/Output structure
    let input: Input
    let output: Output
    
    /// Holds ScheduleCallback with strong reference
    var scheduleCallbackInfo: ScheduleCallback
    
    /// Initialize a new instance of SupportRepository and NetworkRepository
    /// - Parameter supportRepository : gives the api values with respect to support
    /// scheduleCallbackInfo : contains all the values with scheduling a call
    init(with supportRepository: SupportRepository, scheduleCallbackInfo: ScheduleCallback) {
        self.supportRepository = supportRepository
        self.scheduleCallbackInfo = scheduleCallbackInfo
        input = Input(cancelTapObserver: cancelTapSubject.asObserver(),
                      backTapObserver: backTapSubject.asObserver(),
                      callMeTapObserver: callMeTapSubject.asObserver(),
                      isAsapTimeSelectTapObserver: isAsapTimeSelectedSubject.asObserver(),
                      selectedDateObserver: selectDateSubject.asObserver(),
                      selectedTimeObserver: selectTimeSubject.asObserver()
        )
        
        let cancelEventObservable = cancelTapSubject.asObservable().map { _ in
            return SupportCoordinator.Event.goBackToTabView
        }
        
        let backEventObservable = backTapSubject.asObservable().map { _ in
            return SupportCoordinator.Event.goBack
        }
        
        let callMeSuccessEventObservable = callMeSuccessSubject.asObservable().map { _ in
            return SupportCoordinator.Event.goBackToTabView
        }
        
        let viewCompleteObservable = Observable.merge(cancelEventObservable,
                                                      backEventObservable,
                                                      callMeSuccessEventObservable)
        
        
        output = Output(callUsTextDriver: .just(Constants.SelectTimeScheduleCallback.whenUsToCall),
                        nextAvailableTimeTextDriver: .just(Constants.SelectTimeScheduleCallback.nextAvailableTime),
                        availabelTimeInfoSubHeaderTextDriver: .just(Constants.SelectTimeScheduleCallback.availabelTimeSubHeader),
                        dateObservable: selectDateSubject.asObservable(),
                        timeObservable: selectTimeSubject.asObservable(),
                        isSelectedAsapTimeDriver: isAsapTimeSelectedSubject.asObservable(),
                        startLoadingIndicatorObserver: startLoadingIndicatorSubject.asObservable(),
                        viewComplete: viewCompleteObservable)
        
        callMeTapSubject.subscribe(onNext: { [weak self] (_) in
            guard let self = self else {return}
            self.startLoadingIndicatorSubject.onNext(true)
            self.scheduleCallBack(with: self.scheduleCallbackInfo)
        }).disposed(by: self.disposeBag)
    }
    
    func scheduleCallBack(with supportScheduleCallbackInfo: ScheduleCallback) {
        supportRepository.scheduleSupportCallBack(scheduleCallbackInfo: supportScheduleCallbackInfo)
        supportRepository.scheduleCallbackResult.subscribe(onNext: { (scheduleCallbackResponse) in
            self.startLoadingIndicatorSubject.onNext(false)
            self.callMeSuccessSubject.onNext(())
        }).disposed(by: self.disposeBag)
        
        supportRepository.errorMessage.subscribe(onNext: { (error) in
            AlertPresenter.showCustomAlertViewController(title: Constants.Common.anErrorOccurred, message: error.attributedString(), buttonText: Constants.Common.ok)
            self.startLoadingIndicatorSubject.onNext(false)
        }).disposed(by: self.disposeBag)
    }
}
