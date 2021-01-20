//
//  NotificationDetailViewModel.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 03/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
/*
 NotificationDetailViewModel to handle notificaton details
 */
class NotificationDetailViewModel {
    
    /// Variables/Constans
    var url: String?

    private enum Constants {
        static let titleText = "Notifications details".localized
    }

    /// Input Structure
    struct Input {
        let closeObserver: AnyObserver<Void>
        let backObserver: AnyObserver<Void>
    }

    /// Output Structure
    struct Output {
        let titleTextDriver: Driver<String>
        let viewComplete: Observable<NotificationCoordinator.Event>
        let notificationDriver: Observable<Notification>
    }
    
    /// Input & Output structure variable
    let input: Input
    let output: Output

    /// Subject to handle close button tap
    private let closeSubject = PublishSubject<Void>()
    
    /// Subject to handle back button tap
    private let backSubject = PublishSubject<Void>()
    
    /// Subject to handle notification
    private let notificationSubject = PublishSubject<Notification>()
    
    private let disposeBag = DisposeBag()

    /// Initializes a new instance of detailUrl
    /// - Parameter detailUrl : url of webview to be loaded
    init(withDetailsUrl detailUrl: String) {
        input = Input(
            closeObserver: closeSubject.asObserver(),
            backObserver: backSubject.asObserver()
        )
        let closeEventObservable = closeSubject.asObservable().map { _ in
            return NotificationCoordinator.Event.goBackToTabView
        }
        let backEventObservable = backSubject.asObservable().map { _ in
            return NotificationCoordinator.Event.goBack
        }
        
        let viewCompleteObservable = Observable.merge(closeEventObservable, backEventObservable)
        
        output = Output(
            titleTextDriver: Observable.just(Constants.titleText).asDriver(onErrorJustReturn: Constants.titleText),
            viewComplete: viewCompleteObservable,
            notificationDriver: notificationSubject)
    }
}

