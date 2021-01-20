//
//  TabCoordinator.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/1/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxFeedback
/**
 Implemetation of the Tab Coordinator, enabling simple navigation within and across Tab related screens
 */
class TabCoordinator: Coordinator {
    
    /// Define different states stage/events within or across the coordinator
    struct State {
        let stage: Stage
        let event: Event
    }
    
    /// Define different stages of coordinator navigation within or across
    enum Stage {
        case tab
    }
    
    /// Define different event within Tab coordinator
    enum Event {
        case start
        case goToNotifications
        case goToNotification(String)
        case goToDevices
        case goToDashboard
        case goToAccount
        case goToSupport
        case goToLogout
        case dismiss
    }
    
    /// Defines coordinators initial state
    private let initialState: State = State(stage: .tab, event: .start)
    /// Reduce holds state and event
    private let reduce: (State, Event) -> State
    /// Feedback sequence receives elements
    private var feedback: ((ObservableSchedulerContext<State>) -> Observable<Event>)!
    /// Contained disposables disposal
    private let disposeBag = DisposeBag()
    /// Complete subject and observable for logout event complete
    private let completeSubject = PublishSubject<LoginCoordinator.Event>()
    let complete: Observable<LoginCoordinator.Event>
    /// Holds the coordinators with a strong reference
    var childCoordinator: Coordinator?
    private let accountCoordinator: AccountCoordinator
    private let dashboardCoordinator: DashboardCoordinator
    private let deviceCoordinator: DeviceCoordinator
    /// Make the navigationController with a strong reference
    var navigationController: UINavigationController
    /// Holds the tabController with a strong reference
    private var tabController: TabViewController
    /// Holds the repositories with a strong reference
    private let appointmentRepository: AppointmentRepository
    private let networkRepository: NetworkRepository
    private let deviceRepository: DeviceRepository
    
    /// Initialise the coordinator
    /// - Parameters:
    ///   - navigationController: navigation stack of UINavigationController
    ///   - appointmentRepository: appointmentRepository initialised object
    ///   - networkRepository: networkRepository initialised object
    ///   - deviceRepository: deviceRepository initialised object
    init(
        navigationController: UINavigationController,
        appointmentRepository: AppointmentRepository = AppointmentRepository(),
        networkRepository: NetworkRepository = NetworkRepository(),
        deviceRepository: DeviceRepository = DeviceRepository()
    ) {
        self.navigationController = navigationController
        self.appointmentRepository = appointmentRepository
        self.networkRepository = networkRepository
        self.deviceRepository = deviceRepository
        
        let accountNavController = RootNavigationController()
        let dashboardNavController = RootNavigationController()
        let deviceNavController = RootNavigationController()
        
        accountCoordinator = AccountCoordinator(navigationController: accountNavController)
        dashboardCoordinator = DashboardCoordinator(navigationController: dashboardNavController, appointmentRepository: appointmentRepository, networkRepository: networkRepository, deviceRepository: deviceRepository)
        deviceCoordinator = DeviceCoordinator(navigationController: deviceNavController, deviceRepository: deviceRepository,  networkRepository: networkRepository)
        
        dashboardCoordinator.start()
        accountCoordinator.start()
        deviceCoordinator.start()
        
        tabController = TabViewController(accountNavController: accountNavController, dashboardNavController: dashboardNavController, deviceNavController: deviceNavController)
        tabController.setViewModel(to: TabViewModel(appointmentRepository: appointmentRepository, networkRepository: networkRepository))
        
        complete = completeSubject.asObservable()
        
        /// combination of all state, event and returns current state
        reduce = { state, event -> State in
            switch event {
            default:
                return State(stage: .tab, event: event)
            }
        }
        
        feedback = bind(self) { me, state -> Bindings<Event> in
            let events: [Observable<Event>] = [state.flatMap { state -> Observable<Event> in
                switch state.stage {
                case .tab:
                    switch state.event {
                    /// On start push to tabController
                    case .start:
                        me.dashboardCoordinator.showDevicesTabObservable.subscribe(onNext: { (didShowDevicesTab) in
                            me.tabController.showDevicesTab(didShowDevicesTab)
                        }).disposed(by: me.disposeBag)
                        navigationController.setViewControllers([me.tabController], animated: false)
                        
                        return Observable.merge(
                            me.tabController.supportButton.viewModel.output.viewComplete,
                            me.tabController.header.viewModel.output.viewComplete,
                            me.dashboardCoordinator.complete,
                            me.accountCoordinator.complete,
                            me.deviceCoordinator.complete,
                            me.tabController.viewModel.output.viewComplete
                        )
                    /// Navigate to Notification view controller using Notification coordinators event
                    case .goToNotifications:
                        let navigationController = UINavigationController()
                        navigationController.modalPresentationStyle = .fullScreen
                        let coordinator = NotificationCoordinator(navigationController: navigationController)
                        coordinator.start()
                        coordinator.readyForPresentation.subscribe(onNext: { _ in
                            me.navigationController.present(navigationController, animated: true)
                        }).disposed(by: me.disposeBag)
                        return coordinator.complete
                    /// Navigate to Notification view controller using Notification coordinators event with url
                    case .goToNotification(let url):
                        let navigationController = UINavigationController()
                        navigationController.modalPresentationStyle = .fullScreen
                        let coordinator = NotificationCoordinator(navigationController: navigationController, notificationURL: url)
                        coordinator.start()
                        coordinator.readyForPresentation.subscribe(onNext: { _ in
                            me.navigationController.present(navigationController, animated: true)
                        }).disposed(by: me.disposeBag)
                        return coordinator.complete
                    /// Navigate to Devices tab using Devices coordinators event
                    case .goToDevices:
                        me.tabController.showTab(.device)
                        return Observable.empty()
                    /// Navigate to Dashboard tab using Dashboard coordinators event
                    case .goToDashboard:
                        me.tabController.showTab(.dashboard)
                        return Observable.empty()
                    /// Navigate to Account tab using Account coordinators event
                    case .goToAccount:
                        me.tabController.showTab(.account)
                        return Observable.empty()
                    /// Navigate to Support tab using Support coordinators event
                    case .goToSupport:
                        let supportNavigationController = UINavigationController()
                        supportNavigationController.modalPresentationStyle = .fullScreen
                        let coordinator = SupportCoordinator(navigationController: supportNavigationController, networkRepository: me.networkRepository)
                        coordinator.start()
                        coordinator.readyForPresentation.subscribe(onNext: { _ in
                            me.navigationController.present(supportNavigationController, animated: true)
                        }).disposed(by: me.disposeBag)

                        return coordinator.complete
                    /// Logout user
                    case .goToLogout:
                        //Clear the accountID & AssiaID at logout
                        ServiceManager.shared.set(accountID: nil)
                        ServiceManager.shared.set(assiaID: nil)
                        ServiceManager.shared.set(userID: nil)
                        ServiceManager.shared.set(orgID: nil)
                        
                        me.navigationController.popViewController(animated: true)
                        me.completeSubject.onNext(.logout)
                        return Observable.empty()
                    /// Dismiss presented viewController
                    case .dismiss:
                        me.navigationController.dismiss(animated: true, completion: nil)
                        return Observable.empty()
                    }
                }
            }]
            return Bindings(subscriptions: [], events: events)
        }
    }
    
    /// The start method will actually display the main Tab view/screen
    func start() {
        Observable.system(
            initialState: initialState,
            reduce: reduce,
            scheduler: MainScheduler.instance,
            feedback: feedback
        ).subscribe()
        .disposed(by: disposeBag)
    }
}
