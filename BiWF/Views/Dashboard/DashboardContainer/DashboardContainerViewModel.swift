//
//  DashboardContainerViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 27/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
/*
DashboardContainerViewModel to handle contents on Dashboard
*/
class DashboardContainerViewModel {
    
    /// Output structure
    struct Output {
        let viewStatusObservable: Observable<ViewStatus>
        let newUserDashboaedViewModelObservable: Observable<CommonDashboardViewModel>
        let dashboardViewModelObservable: Observable<DashboardViewModel>
        let viewComplete: Observable<DashboardCoordinator.Event>
    }
    
    /// Input structure
    struct Input {
        let showNewUserDashboardWithDevicesTabObserver: AnyObserver<Bool>
        let showDashboardObserver: AnyObserver<Void>
    }
    
    /// Subject to view the status
    let viewStatusSubject = PublishSubject<ViewStatus>()
    
    /// Subject to show new user dashboard
    let showNewUserDashboardWithDevicesTabSubject = PublishSubject<Bool>()
    
    /// Subject to show  user dashboard
    let showDashboardSubject = PublishSubject<Void>()
    
    /// Holds newUserDashboardViewModel with stong reference
    let commonDashboardViewModel: CommonDashboardViewModel
    
    /// Holds dashboardViewModel with stong reference
    let dashboardViewModel: DashboardViewModel
    
    /// Input/Output structure variables
    let output: Output
    let input: Input
    
    /// Holds accountRepository with stong reference
    let accountRepository: AccountRepository
    
    /// Holds appointmentRepository with stong reference
    let appointmentRepository: AppointmentRepository
    let disposeBag = DisposeBag()
    
    /// Initializes a new instance of AccountRepository, AppointmentRepository, NotificationRepository, NetworkRepository and DeviceRepository
    /// - Parameter accountRepository : to get api values on account
    /// appointmentRepository : to get api values on appointment
    /// notificationRepository : to get api values on notification
    /// networkRepository : to get api values on network
    /// deviceRepository : to get api values on device
    init(
        accountRepository: AccountRepository,
        appointmentRepository: AppointmentRepository,
        notificationRepository: NotificationRepository,
        networkRepository: NetworkRepository,
        deviceRepository: DeviceRepository
    ) {
        self.accountRepository = accountRepository
        self.appointmentRepository = appointmentRepository
        self.commonDashboardViewModel = CommonDashboardViewModel(with: appointmentRepository)
        self.dashboardViewModel = DashboardViewModel(commonDashboardViewModel: commonDashboardViewModel, notificationRepository: notificationRepository, networkRepository: networkRepository, deviceRepository: deviceRepository)
        
        input = Input(
            showNewUserDashboardWithDevicesTabObserver: showNewUserDashboardWithDevicesTabSubject.asObserver(),
            showDashboardObserver: showDashboardSubject.asObserver()
        )
        
        let showDashboardEventObservable = showDashboardSubject.asObservable().map { _ in
            return DashboardCoordinator.Event.goToStandardDashboard
        }
        
        let showNewUserDashboardEventObservable = showNewUserDashboardWithDevicesTabSubject.asObservable().map { didShowDevicesTab in
            return DashboardCoordinator.Event.goToNewUserDashboard(didShowDevicesTab)
        }
        
        let viewCompleteObservable = Observable.merge(showNewUserDashboardEventObservable,
                                                      showDashboardEventObservable)
        
        output = Output(viewStatusObservable: viewStatusSubject.asObservable(),
                        newUserDashboaedViewModelObservable: .just(commonDashboardViewModel),
                        dashboardViewModelObservable: .just(dashboardViewModel),
                        viewComplete: viewCompleteObservable
        )
        getUser()
        getError()
    }
}


