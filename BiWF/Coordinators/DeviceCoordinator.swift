//
//  DeviceCoordinator.swift
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
 Implemetation of the Dashboard Coordinator, enabling simple navigation within and across Dashboard related screens
 */
class DeviceCoordinator: Coordinator {
    
    /// Define different states stage/events within or across the coordinator
    struct State {
        let stage: Stage
        let event: Event
    }
    
    /// Define different stages of coordinator navigation within or across
    enum Stage {
        case devices
        case deviceManagement(DeviceInfo, [String], Bool)
    }
    
    /// Define different event within Device coordinator
    enum Event {
        case start
        case openDeviceManagement(DeviceInfo, [String], Bool)
        case dismiss
    }
    
    /// Defines coordinators initial state
    private let initialState: State = State(stage: .devices, event: .start)
    /// Reduce holds state and event
    private let reduce: (State, Event) -> State
    /// Feedback sequence receives elements
    private var feedback: ((ObservableSchedulerContext<State>) -> Observable<Event>)!
    /// Contained disposables disposal
    private let disposeBag = DisposeBag()
    /// Complete subject and observable for view event complete
    private let completeSubject = PublishSubject<TabCoordinator.Event>()
    let complete: Observable<TabCoordinator.Event>
    /// Holds the childCoordinator with a strong reference
    var childCoordinator: Coordinator?
    /// Holds the navigationController with a strong reference
    var navigationController: UINavigationController
    
    /// Initialise the coordinator
    /// - Parameters:
    ///   - navigationController: navigation stack of UINavigationController
    ///   - deviceRepository: deviceRepository passed object from previous coordinator
    ///   - networkRepository: networkRepository passed object from previous coordinator
    init(navigationController: UINavigationController, deviceRepository: DeviceRepository, networkRepository: NetworkRepository) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
        complete = completeSubject.asObservable()
        
        /// combination of all state, event and returns current state
        reduce = { state, event -> State in
            switch event {
            case .start:
                return State(stage: .devices, event: event)
            case .openDeviceManagement(let deviceInfo, let deviceNameArray, let isModemOnline):
                return State(stage: .deviceManagement(deviceInfo, deviceNameArray, isModemOnline), event: event)
            case .dismiss:
                return State(stage: .devices, event: event)
            }
        }
        
        feedback = bind(self) { coordinator, state -> Bindings<Event> in
            let events: [Observable<Event>] = [state.flatMap { state -> Observable<Event> in
                switch state.stage {
                case .devices:
                    switch state.event {
                    /// On start push to DevicesViewController initially
                    case .start:
                        var viewController = DevicesViewController.instantiate(fromStoryboardNamed: String(describing: "Device"))
                        viewController.setViewModel(to: DevicesViewModel(withRepository: deviceRepository,
                                                                         networkRepository: networkRepository))
                        navigationController.pushViewController(viewController, animated: false)
                        return viewController.viewModel.output.viewComplete
                    /// Dismiss presented viewController
                    case .dismiss:
                        coordinator.navigationController.dismiss(animated: true, completion: nil)
                        return Observable.empty()
                    default:
                        return Observable.empty()
                    }
                /// Push to DeviceManagement(UsageDetailsViewController) sceens
                case .deviceManagement(let deviceInfo, let deviceNameArray, let isModemOnline):
                    
                    var viewController = UsageDetailsViewController.instantiate(fromStoryboardNamed: "Device")
                    let viewModel = UsageDetailsViewModel(with: deviceInfo,
                                                          deviceRepository: DeviceRepository(),
                                                          networkRepository: networkRepository,
                                                          isModemOnline: isModemOnline)
                    viewModel.devicesNameArray = deviceNameArray
                    viewController.setViewModel(to: viewModel)
                    let navController = UINavigationController(rootViewController: viewController)
                    navController.navigationBar.defaultSetup()
                    navController.modalPresentationStyle = .fullScreen
                    coordinator.navigationController.present(navController, animated: true)
                    return viewModel.output.viewComplete
                }
            }]
            return Bindings(subscriptions: [], events: events)
        }
    }
    
    /// The start method will actually display the main Device view/screen
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
