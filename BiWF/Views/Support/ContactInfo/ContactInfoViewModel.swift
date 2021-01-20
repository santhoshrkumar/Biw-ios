//
//  ContactInfoViewModel.swift
//  BiWF
//
//  Created by varun.b.r on 09/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import DPProtocols
/*
  ContactInfoViewModel handles contact information
**/
class ContactInfoViewModel {
    
    /// Input structure to handle input events
    struct Input {
        let cancelTapObserver: AnyObserver<Void>
        let backTapObserver: AnyObserver<Void>
        let nextContactInfoTapObserver: AnyObserver<ScheduleCallback>
        let isMobileSelectedObserver: AnyObserver<Bool>
    }
    
    /// Output structure  lo handle output events
    struct Output {
        let viewComplete: Observable<SupportCoordinator.Event>
        let contactInfoMainTextDriver: Driver<String>
        let nextButtonTitledriver: Driver<String>
        let defaultNumberDriver: Driver<String>
        let errorMessageDriver: Driver<String>
        let isMobileSelectedObservable: Observable<Bool>
        let shouldShowErrorObservable: Observable<Bool>
        let shouldHideDefaultMobileViewObservable: Observable<Bool>

    }
    
    /// Variables
    private let cancelTapSubject = PublishSubject<Void>()
    private let backTapSubject = PublishSubject<Void>()
    private let nextContactInfoTapSubject =  PublishSubject<ScheduleCallback>()
    private let isMobileSelectedSubject =  BehaviorSubject<Bool>(value: true)
    let shouldShowErrorSubject =  BehaviorSubject<Bool>(value: false)
    private var shouldHideDefaultMobileViewSubject =  BehaviorSubject<Bool>(value: false)
    let disposeBag = DisposeBag()

    let input: Input
    let output: Output
    var scheduleCallBack: ScheduleCallback
    var mobileNumber: String

    /// Initializes a new instance of ContactInfoViewModel
    /// - Parameter
    ///     - scheduleCallBack : ScheduleCallback object contain users information to schedule call back
    init(scheduleCallBack: ScheduleCallback) {
        self.scheduleCallBack = scheduleCallBack
        mobileNumber = self.scheduleCallBack.phone
        shouldHideDefaultMobileViewSubject.onNext(!(self.scheduleCallBack.phone.isEmpty ))
        input = Input(
            cancelTapObserver: cancelTapSubject.asObserver(),
            backTapObserver: backTapSubject.asObserver(),
            nextContactInfoTapObserver: nextContactInfoTapSubject.asObserver(),
            isMobileSelectedObserver: isMobileSelectedSubject.asObserver()
        )
        
        let cancelEventObservable = cancelTapSubject.asObservable().map { _ in
            return SupportCoordinator.Event.goBackToTabView
        }
        
        let backEventObservable = backTapSubject.asObservable().map { _ in
            return SupportCoordinator.Event.goBack
        }
        
        let nextContactInfoObservable = nextContactInfoTapSubject.asObservable().map { scheduleCallbackDetail in
            return SupportCoordinator.Event.goToSelectTimeScheduleCallback(scheduleCallbackDetail)
        }
        
        let viewCompleteObservable = Observable.merge(cancelEventObservable,
                                                      backEventObservable,
                                                      nextContactInfoObservable)
        
        
        output = Output(viewComplete: viewCompleteObservable,
                        contactInfoMainTextDriver: .just(Constants.ContactInfo.contactText),
                        nextButtonTitledriver: .just(Constants.AdditionalInfo.moreInfoNextButton),
                        defaultNumberDriver: .just(self.scheduleCallBack.phone.applyPatternOnNumbers(inGeneralFormat: false)),
                        errorMessageDriver: .just(Constants.ContactInfo.errorMessgae),
                        isMobileSelectedObservable: isMobileSelectedSubject.asObservable(),
                        shouldShowErrorObservable: shouldShowErrorSubject.asObservable(),
                        shouldHideDefaultMobileViewObservable: shouldHideDefaultMobileViewSubject.asObservable())
        
        ///Handles selection of default user mobile or other number
        self.isMobileSelectedSubject.subscribe(onNext: { (isSelectedMobile) in
            self.mobileNumber = isSelectedMobile ? scheduleCallBack.phone : ""
            self.shouldShowErrorSubject.onNext(false)
            }).disposed(by: disposeBag)

    }
}
