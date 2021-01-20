//
//  TabHeaderViewModel.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/5/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa

class TabHeaderViewModel {

    /// Input structure to handle input events
    struct Input {
        let accountTapObserver: AnyObserver<Void>
        let dashboardTapObserver: AnyObserver<Void>
        let devicesTapObserver: AnyObserver<Void>
        let goToDevicesObserver: AnyObserver<Void>
        let notificationTapObserver: AnyObserver<Void>
    }

    /// Output structure  lo handle output events
    struct Output {
        let accountSelectedObservable: Observable<Bool>
        let dashboardSelectedObservable: Observable<Bool>
        let devicesSelectedObservable: Observable<Bool>
        let showDevicesTabObservable: Observable<Bool>
        let isOnlineObservable: Observable<Bool>
        let hideNotificationBadgeObservable: Observable<Bool>
        let notificationBadgeTextDriver: Driver<String>
        let accountTitleDriver: Driver<String>
        let dashboardTitleDriver: Driver<String>
        let devicesTitleDriver: Driver<String>
        let statusTextDriver: Driver<String>
        let viewComplete: Observable<TabCoordinator.Event>
    }

    /// Input/Output structure variables
    let input: Input
    let output: Output

    ///accountTap Subject to handle account tab button tap event
    private let accountTapSubject = PublishSubject<Void>()
    ///dashboardTap Subject to handle dashboard tab button tap event
    private let dashboardTapSubject = PublishSubject<Void>()
    ///devicesTap Subject to handle device tab button tap event
    private let devicesTapSubject = PublishSubject<Void>()
    private let goToDevicesSubject = PublishSubject<Void>()
    private let notificationTapSubject = PublishSubject<Void>()
    let showDevicesTabSubject = PublishSubject<Bool>()
    private let accountSelectedSubject = BehaviorSubject<Bool>(value: false)
    private let dashboardSelectedSubject = BehaviorSubject<Bool>(value: true)
    private let devicesSelectedSubject = BehaviorSubject<Bool>(value: false)
    private let disposeBag = DisposeBag()

    /// Initializes a new instance of TabHeader ViewModel
    /// - Parameter
    ///     - appointmentRepository : to call api  on appointment repository
    ///     - networkRepository : to call api  on network repository
    init(appointmentRepository: AppointmentRepository, networkRepository: NetworkRepository) {
        input = Input(
            accountTapObserver: accountTapSubject.asObserver(),
            dashboardTapObserver: dashboardTapSubject.asObserver(),
            devicesTapObserver: devicesTapSubject.asObserver(),
            goToDevicesObserver: goToDevicesSubject.asObserver(),
            notificationTapObserver: notificationTapSubject.asObserver()
        )

        let accountEventObservable = accountTapSubject.asObservable().map { _ in
            return TabCoordinator.Event.goToAccount
        }

        let dashboardEventObservable = dashboardTapSubject.asObservable().map { _ in
            return TabCoordinator.Event.goToDashboard
        }

        let devicesEventObservable = devicesTapSubject.asObservable().map { _ in
            return TabCoordinator.Event.goToDevices
        }

        let notificationEventObservable = notificationTapSubject.asObserver().map { _  in
            return TabCoordinator.Event.goToNotifications
        }

        let viewCompleteObservable = Observable.merge(
            accountEventObservable,
            dashboardEventObservable,
            devicesEventObservable,
            notificationEventObservable
        )
        
        // Check if modem is online
        let isOnlineObservable = networkRepository.isOnlineSubject.asObservable()
        let statusTextDriver = isOnlineObservable.map { isOnline in
            return isOnline ? Constants.Tab.internetOnline : Constants.Tab.internetOffline
        }.asDriver(onErrorJustReturn: Constants.Tab.internetOffline)

        // Check how many notification the user has
        let notificationCountObservable = Observable.just(4)
        let notificationBadgeTextDriver = notificationCountObservable.map { String($0) }.asDriver(onErrorJustReturn: "")
        let hideNotificationBadgeObservable = notificationCountObservable.map { $0 < 1 }

        output = Output(
            accountSelectedObservable: accountSelectedSubject.asObservable(),
            dashboardSelectedObservable: dashboardSelectedSubject.asObservable(),
            devicesSelectedObservable: devicesSelectedSubject.asObservable(),
            showDevicesTabObservable: showDevicesTabSubject.asObservable(),
            isOnlineObservable: isOnlineObservable,
            hideNotificationBadgeObservable: hideNotificationBadgeObservable,
            notificationBadgeTextDriver: notificationBadgeTextDriver,
            accountTitleDriver: Driver.just(Constants.Tab.account),
            dashboardTitleDriver: Driver.just(Constants.Tab.dashboard),
            devicesTitleDriver: Driver.just(Constants.Tab.devices),
            statusTextDriver: statusTextDriver,
            viewComplete: viewCompleteObservable
        )

        ///Handle account tab button tap
        accountTapSubject.subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.accountSelectedSubject.onNext(true)
                self.dashboardSelectedSubject.onNext(false)
                self.devicesSelectedSubject.onNext(false)
            }).disposed(by: disposeBag)

        ///Handle dashboard tab button tap
        dashboardTapSubject.subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.accountSelectedSubject.onNext(false)
                self.dashboardSelectedSubject.onNext(true)
                self.devicesSelectedSubject.onNext(false)
            }).disposed(by: disposeBag)

        ///Handle device tab button tap
        let devicesSelctionObservable = Observable.merge(devicesTapSubject, goToDevicesSubject)
        
        devicesSelctionObservable.subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.accountSelectedSubject.onNext(false)
                self.dashboardSelectedSubject.onNext(false)
                self.devicesSelectedSubject.onNext(true)
            }).disposed(by: disposeBag)
    }
}
