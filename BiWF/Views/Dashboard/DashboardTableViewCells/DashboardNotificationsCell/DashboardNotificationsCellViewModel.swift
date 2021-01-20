//
//  DashboardNotificationsCellViewModel.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/21/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
/*
DashboardNotificationsCell handles the notification on dashboard
*/
class DashboardNotificationsCellViewModel {
    
    /// Input structure
    struct Input {
        
    }

    /// Output structure
    struct Output {
        let topViewModelObservable: Observable<DashboardNotificationViewModel?>
        let hideViewObservable: Observable<Bool>
        let hideSecondViewObservable: Observable<Bool>
        let hideThirdViewObservable: Observable<Bool>
        let openNotificationDetailObservable: Observable<String>
    }

    /// Input/Output structure variables
    let input: Input
    let output: Output

    /// Subject to handle the notification at top of dashboard
    private let topViewModelSubject = BehaviorSubject<DashboardNotificationViewModel?>(value: nil)
    
    /// Subject to handle hide the notification view
    private let hideViewSubject = PublishSubject<Bool>()
    
    /// Subject to handle hide second notification view
    private let hideSecondViewSubject = PublishSubject<Bool>()
    
    /// Subject to handle hide third notification view
    private let hideThirdViewSubject = PublishSubject<Bool>()
    
    /// Subject to handle open notification
    private let openNotificationDetialsSubject = PublishSubject<String>()
    private var disposeBag = DisposeBag()

    private var notifications: [Notification]

    /// Initializes a new instance of AppointmentRepository and NetworkRepository
    /// - Parameter notifications : array of notifications
    init(notifications: [Notification]) {
        self.notifications = notifications
        input = Input()
        output = Output(
            topViewModelObservable: topViewModelSubject.asObservable(),
            hideViewObservable: hideViewSubject.asObservable(),
            hideSecondViewObservable: hideSecondViewSubject.asObservable(),
            hideThirdViewObservable: hideThirdViewSubject.asObservable(),
            openNotificationDetailObservable: openNotificationDetialsSubject.asObservable()
        )

        updateTopViewModel()
        updateHideSubjects()
    }

    /// Updating every notifications
    private func updateTopViewModel() {
        guard let topNotification = notifications.first else { return }
        let viewModel = DashboardNotificationViewModel(notification: topNotification)
        topViewModelSubject.onNext(viewModel)
        disposeBag = DisposeBag()
        viewModel.output.closeViewObservable.subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.removeTopViewModel()
            }).disposed(by: disposeBag)

        viewModel.output.openNotificationDetailsObservable.subscribe(onNext: { [weak self] url in
                guard let self = self else { return }
                self.openNotificationDetialsSubject.onNext(url)
            }).disposed(by: disposeBag)
    }

    /// Removing the notification from top
    private func removeTopViewModel() {
        guard !notifications.isEmpty else { return }
        notifications.removeFirst()
        updateHideSubjects()
        updateTopViewModel()
    }

    /// Updating the hide notification
    private func updateHideSubjects() {
        hideViewSubject.onNext(notifications.isEmpty)
        hideSecondViewSubject.onNext(notifications.count < 2)
        hideThirdViewSubject.onNext(notifications.count < 3)
    }
}
