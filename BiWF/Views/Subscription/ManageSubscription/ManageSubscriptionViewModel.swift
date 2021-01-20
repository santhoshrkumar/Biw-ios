
//
//  ManageSubscriptionViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 14/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class ManageSubscriptionViewModel {
/*
     ManageSubscriptionViewModel to handle the manage subscription
     */
    
    /// Input Structure
    struct Input {
        let continueTapObserver: AnyObserver<Void>
        let cancelTapObserver: AnyObserver<Void>
        let backTapObserver: AnyObserver<Void>
    }
    
    /// Output Structure
    struct Output {
        let headerTextDriver: Driver<String>
        let descriptionTextDriver: Driver<String>
        let continueBtnTextDriver: Driver<String>
        let viewComplete: Observable<SubscriptionCoordinator.Event>
    }
    
    /// Subject to handle continue button tap
    private let continueTapSubject = PublishSubject<Void>()
    
    /// Subject to handle cancel button tap
    private let cancelTapSubject = PublishSubject<Void>()
    
    /// Subject to handle done button tap
    private let backTapSubject = PublishSubject<Void>()
    
    /// Subject to handle cancel subscription
    private let goToCancelSubscription = PublishSubject<Account>()
    
    /// Input & Output structure variable
    let input: Input
    let output: Output
    
    /// Holds account with strong reference
    private var account: Account
    
    private let disposeBag = DisposeBag()
    
    /// Initializes a new instance of Account
    /// - Parameter Account : Contains all account values
    init(withAccount account: Account) {
        let subscriptionEndDate: Date = Date().dateAfterDays(7) ?? Date()
        
        self.account = account
        self.account.subscriptionEndDate = subscriptionEndDate.toString(withFormat: DateFormat.MMMMddyyyy)
        input = Input(
            continueTapObserver: continueTapSubject.asObserver(),
            cancelTapObserver: cancelTapSubject.asObserver(),
            backTapObserver: backTapSubject.asObserver()
        )
        
        let cancelEventObservable = cancelTapSubject.asObservable().map { _ in
            return SubscriptionCoordinator.Event.goBackToAccount
        }
        
        let backEventObservable = backTapSubject.asObservable().map { _ in
            return SubscriptionCoordinator.Event.goBack
        }
        
        let continueEventObservable = goToCancelSubscription.asObservable().map { account in
            return SubscriptionCoordinator.Event.goToCancelSubscription(account)
        }

        let viewCompleteObservable = Observable.merge(cancelEventObservable,
                                                      backEventObservable,
                                                      continueEventObservable)
        
        //TODO:- To be replaced with the actual subscription end date
        let descText = "\(Constants.Subscription.descriptionText) \(subscriptionEndDate.toString(withFormat: DateFormat.MMMMddyyyy))."
        
        output = Output(headerTextDriver: Observable.just(Constants.Subscription.headerText).asDriver(onErrorJustReturn: Constants.Subscription.headerText),
                        descriptionTextDriver: Observable.just(descText).asDriver(onErrorJustReturn: descText),
                        continueBtnTextDriver: Observable.just(Constants.Subscription.continueCancelText)
                            .asDriver(onErrorJustReturn: Constants.Subscription.continueCancelText),
                        viewComplete: viewCompleteObservable)
        
        continueTapSubject.subscribe(onNext: {[weak self] rating in
            guard let self = self else { return }
            self.goToCancelSubscription.onNext(self.account)
        }).disposed(by: disposeBag)
    }
}
