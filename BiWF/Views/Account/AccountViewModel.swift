//
//  AccountViewModel.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/2/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
/*
 AccountViewModel to provide the user account information
 */
class AccountViewModel {

    /// CardType to select the type of card
    enum CardType: Int {
        case subscription = 1
        case personalInfo
    }
    /// ToggleType to on/off
    enum ToggleType {
        case faceID
        case serviceCall
        case marketingEmail
        case marketingCall
    }

    /// Input Structure
    struct Input {
        let cellSelectionObserver: AnyObserver<IndexPath>
        let changeFaceIDPreferenceObserver: AnyObserver<Bool>
        let changeServiceCallPreferenceObserver: AnyObserver<Bool>
        let changeMarketingCallPreferenceObserver: AnyObserver<Bool>
        let changeMarketingEmailPreferenceObserver: AnyObserver<Bool>
        let changeLogoutPreferenceObserver: AnyObserver<Void>
    }

    /// Output Structure
    struct Output {
        let viewComplete: Observable<AccountCoordinator.Event>
        let faceIdSwitchObeservable: Observable<Bool>
        let viewStatusObservable: Observable<ViewStatus>
        let logoutStatusObservable: Observable<Void>
    }
    
    /// Input & Output structure variable
    let input: Input
    let output: Output

    /// cellSelectionSubject to select the perticular cell on tableview
    private let cellSelectionSubject = PublishSubject<IndexPath>()
    
    /// changeFaceIDSubject to to change faceId
    let changeFaceIDSubject = PublishSubject<Bool>()
    
    /// changeFaceIDSubject to to change service call type
    private let changeServiceCallSubject = PublishSubject<Bool>()
    
    /// changeFaceIDSubject to to change marketing call type
    private let changeMarketingCallSubject = PublishSubject<Bool>()
    
    /// changeFaceIDSubject to to change marketing email
    private let changeMarketingEmailSubject = PublishSubject<Bool>()
    
    /// Constants subjects
    let viewStatusSubject = PublishSubject<ViewStatus>()
    let openPersonalInfoSubject = PublishSubject<Account>()
    let openSubscriptionSubject = PublishSubject<Subscription>()
    let faceIdActionSubject = PublishSubject<Bool>()
    let logoutSubject = PublishSubject<Void>()
    let logoutSuccessSubject = PublishSubject<Void>()
    let disposeBag = DisposeBag()

    /// Holds the AccountRepository with a strong reference
    var repository: AccountRepository
    
    /// Holds the SubscriptionRepository with a strong reference
    var subscriptionRepository: SubscriptionRepository
    
    /// Holds the UserDetails with a strong reference
    var userDetails: UserDetails?
    
    /// Holds the Account with a strong reference
    var account: Account?
    
    /// Holds the Contact with a strong reference
    var contact: Contact?
    
    /// Holds the PaymentInfo with a strong reference
    var paymentInfo: PaymentInfo?
    
    /// Holds the Fiber Internet Info with a strong reference
    var fiberPlanInfo : FiberPlanInfo?
    
    var switchResponse = PublishSubject<Bool>()
    
    var isErrorState = false
    var delay = 2.0
    var updatePhoneNumber: String?

    var sections = BehaviorSubject(value: [TableDataSource]())

    /// Initializes a new instance of AccountRepository and SubscriptionRepository
    /// - Parameter AccountRepository : Gives all the api values to the Account
    /// SubscriptionRepository : Gives all the api values to the Subscription model
    init(withRepository accountRepository: AccountRepository, subscriptionRepository: SubscriptionRepository) {
        input = Input(cellSelectionObserver: cellSelectionSubject.asObserver(),
                      changeFaceIDPreferenceObserver: changeFaceIDSubject.asObserver(),
                      changeServiceCallPreferenceObserver: changeServiceCallSubject.asObserver(),
                      changeMarketingCallPreferenceObserver: changeMarketingCallSubject.asObserver(),
                      changeMarketingEmailPreferenceObserver: changeMarketingEmailSubject.asObserver(),
                      changeLogoutPreferenceObserver: logoutSubject.asObserver())

        self.repository = accountRepository
        self.subscriptionRepository = subscriptionRepository

        let openPersonalInfoEventObservable = openPersonalInfoSubject.asObservable().map { personalInfo in
            return AccountCoordinator.Event.goToPersonalInfo(personalInfo)
        }
        
        let openSubscriptionEventObservable = openSubscriptionSubject.asObservable().map { account in
            return AccountCoordinator.Event.goToSubscription(account)
        }

        let logoutEventObservable = logoutSuccessSubject.asObservable().map { _  in
            return AccountCoordinator.Event.logout
        }

        let viewCompleteObservable = Observable.merge(openPersonalInfoEventObservable,
                                                      openSubscriptionEventObservable,
                                                      logoutEventObservable)
                    
        output = Output(viewComplete: viewCompleteObservable,
                        faceIdSwitchObeservable: faceIdActionSubject.asObservable(),
                        viewStatusObservable: viewStatusSubject.asObservable(),
                        logoutStatusObservable: logoutSubject.asObservable())
        subscribeResponses()
        getUser()

        cellSelectionSubject.subscribe({[weak self] indexPath in
            self?.openNext(indexPath: indexPath.element ?? IndexPath(row: 1, section: 0))
        }).disposed(by: disposeBag)

        changeFaceIDSubject
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] changedValue in
                Biometrics.isPresentedForChangePreferenceAndSettings = true
                do { self?.updateValues(toggle: changedValue, toggleType: ToggleType.faceID) }
            }).disposed(by: disposeBag)
        
        changeServiceCallSubject.subscribe(onNext: { [weak self] changedValue in
            do { self?.updateValues(toggle: changedValue, toggleType: ToggleType.serviceCall) }
        }).disposed(by: disposeBag)
        
        changeMarketingEmailSubject.subscribe(onNext: { [weak self] changedValue in
            do { self?.updateValues(toggle: changedValue, toggleType: ToggleType.marketingEmail) }
        }).disposed(by: disposeBag)
        
        changeMarketingCallSubject.subscribe(onNext: { [weak self] changedValue in
            do { self?.updateValues(toggle: changedValue, toggleType: ToggleType.marketingCall) }
        }).disposed(by: disposeBag)
        
        logoutSubject.subscribe(onNext: { [weak self] _ in
            let loading = ViewStatus.loading(loadingText: Constants.Common.loading)
            self?.viewStatusSubject.onNext(loading)
            accountRepository.logoutUser()
        }).disposed(by: disposeBag)
    }
    
}
