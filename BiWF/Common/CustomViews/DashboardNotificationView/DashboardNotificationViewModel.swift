//
//  DashboardNotificationViewModel.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/20/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa

/*
    DashboardNotificationViewModel to handle notification on dashboard
**/
struct DashboardNotificationViewModel {
    
    /// Input structure to handle input events
    struct Input {
        let closeTappedObvserver: AnyObserver<Void>
        let openNotificationDetailsObserver: AnyObserver<Void>
    }
    
    /// Output structure  lo handle output events
    struct Output {
        let nameTextDriver: Driver<String>
        let descriptionTextDriver: Driver<String>
        let closeViewObservable: Observable<Void>
        let openNotificationDetailsObservable: Observable<String>
    }

    /// Input/Output structure variables
    let input: Input
    let output: Output
    
    /// Subject to close the notification
    private let closeTappedSubject = PublishSubject<Void>()
    /// Subject to open the notification
    private let openNotificationDetailsSubject = PublishSubject<Void>()
    let disposeBag = DisposeBag()

    /// Initializes a new instance of DashboardNotificationViewModel
    /// - Parameter
    ///     - notification : notification detail
    init(notification: Notification) {
        input = Input(
            closeTappedObvserver: closeTappedSubject.asObserver(),
            openNotificationDetailsObserver: openNotificationDetailsSubject.asObserver()
        )

        let openNotificationDetailsObservable = openNotificationDetailsSubject.asObservable().map { _ in
            return notification.detailUrl
        }

        output = Output(
            nameTextDriver: .just(notification.name),
            descriptionTextDriver: .just(notification.description),
            closeViewObservable: closeTappedSubject.asObservable(),
            openNotificationDetailsObservable: openNotificationDetailsObservable
        )

    }
}
