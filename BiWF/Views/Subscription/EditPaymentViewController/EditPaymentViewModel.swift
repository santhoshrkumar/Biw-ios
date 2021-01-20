//
//  EditPaymentViewModel.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 7/20/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
/*
 EditPaymentViewModel to handle edited payment
 */
struct EditPaymentViewModel {
    
    /// Input Structure
    struct Input {
        let backTappedObserver: AnyObserver<Void>
        let doneTappedObserver: AnyObserver<Void>
    }

    /// Output Structure
    struct Output {
        let urlStringDriver: Driver<String>
        let viewComplete: Observable<SubscriptionCoordinator.Event>
    }

    /// Input & Output structure variable
    let input: Input
    let output: Output

    /// Subject to handle back button tap
    private let backTapSubject = PublishSubject<Void>()
    
    /// Subject to handle done button tap
    private let doneTapSubject = PublishSubject<Void>()

    /// Initializes a new instance
    init() {
        input = Input(
            backTappedObserver: backTapSubject.asObserver(),
            doneTappedObserver: doneTapSubject.asObserver()
        )

        let doneEventObservable = doneTapSubject.asObservable().map { _ in
            return SubscriptionCoordinator.Event.goBackToAccount
        }
        
        let backEventObservable = backTapSubject.asObservable().map { _ in
            return SubscriptionCoordinator.Event.popEditPayment
        }

        let viewCompletObservable = Observable.merge(doneEventObservable, backEventObservable)

        output = Output(
            urlStringDriver: .just(Constants.EditPayment.editPaymentURL+(ServiceManager.shared.userID ?? "")),
            viewComplete: viewCompletObservable
        )
    }
}
