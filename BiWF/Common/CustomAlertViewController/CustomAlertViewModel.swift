//
//  CustomAlertViewModel.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 27/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
/*
 CustomAlertViewModel to handle custom alert
 */
class CustomAlertViewModel {
    
    /// Output Structure
    struct Output {
        let titleTextDriver: Driver<String>
        let messageTextDriver: Driver<NSAttributedString>
        let buttonTitleTextDriver: Driver<String>
        let viewComplete: Observable<AccountCoordinator.Event>
        let complete: Observable<SubscriptionCoordinator.Event>
        let viewCompleteForDashboardCoordinator: Observable<DashboardCoordinator.Event>
    }
    
    /// Input Structure
    struct Input {
        let buttonTapObserver: AnyObserver<Void>
        let closeButtonTapObserver: AnyObserver<Void>
    }
    
    /// Subject to handle button tap
    private let buttonTapSubject = PublishSubject<Void>()
    
    /// Subject to handle close button tap
    private let closeButtonSubject = PublishSubject<Void>()
    
    /// Subject to handle dissmiss the alert
    let dismissSubject = PublishSubject<Void>()
    var isPresentedFromWindow = false
    private let disposeBag = DisposeBag()
    
    /// Input/Output Structure variables
    let output: Output
    let input: Input
    
    /// Initializes a new instance
    /// - Parameter title : title of the alert
    /// message : message description
    /// buttonTitleText : title of the button
    /// isPresentedFromWindow : Bool
    init(withTitle title: String, message: NSAttributedString, buttonTitleText: String, isPresentedFromWindow: Bool) {
        self.isPresentedFromWindow = isPresentedFromWindow
        input = Input(
            buttonTapObserver: buttonTapSubject.asObserver(),
            closeButtonTapObserver: closeButtonSubject.asObserver()
        )
        
        let buttonTapEventObservable = buttonTapSubject.asObserver().map { _  in
            return AccountCoordinator.Event.goBackToPersonalInfo
        }
        
        let completeEventObservable = buttonTapSubject.asObserver().map { _  in
            return SubscriptionCoordinator.Event.dismissAlert
        }
        
        let viewCompleteForDashboardEventObservable = buttonTapSubject.asObserver().map { _  in
            return DashboardCoordinator.Event.dismissAlert
        }
        
        output = Output(
            titleTextDriver: .just(title),
            messageTextDriver: .just(message),
            buttonTitleTextDriver: .just(buttonTitleText),
            viewComplete: buttonTapEventObservable,
            complete: completeEventObservable,
            viewCompleteForDashboardCoordinator: viewCompleteForDashboardEventObservable
        )
        closeButtonSubject.subscribe(onNext: { [weak self] in
            self?.dismissSubject.onNext(())
        }).disposed(by: disposeBag)
    }
}
