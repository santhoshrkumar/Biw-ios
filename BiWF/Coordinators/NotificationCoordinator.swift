//
//  NotificationCoordinator.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 26/03/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxFeedback
/**
 Implemetation of the Notification Coordinator, enabling simple navigation within and across Notification related screens
 */
class NotificationCoordinator: Coordinator {
    
    /// Define different states stage/events within or across the coordinator
    struct State {
        let stage: Stage
        let event: Event
    }
    
    /// Define different stages of coordinator navigation within or across
    enum Stage {
        case notification
        case notificationDetails(String)
        case back
        case backToTabView
    }
    
    /// Define different event within Notification coordinator
    enum Event {
        case start
        case goToDetails(String)
        case goBack
        case goBackToTabView
    }
    
    /// Defines coordinators initial state
    private let initialState: State
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
    /// Complete subject and observable for readyForPresentation
    private let readyForPresentationSubject = PublishSubject<Void>()
    let readyForPresentation: Observable<Void>
    /// Holds the NotificationRepository repository with a strong reference
    let repository = NotificationRepository()
    
    /// Initialise the coordinator
    /// - Parameters:
    ///   - navigationController: navigation stack of UINavigationController
    ///   - notificationURL: If initialising via dashboard
    init(navigationController: UINavigationController, notificationURL: String? = nil) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
        complete = completeSubject.asObservable()
        readyForPresentation = readyForPresentationSubject.asObservable()

        if let url = notificationURL {
            initialState = State(stage: .notificationDetails(url), event: .start)
        } else {
            initialState = State(stage: .notification, event: .start)
        }

        /// combination of all state, event and returns current state
        reduce = { state, event -> State in
            switch event {
            case .start:
                return State(stage: .notification, event: event)
            case .goToDetails(let detailUrl):
                return State(stage: .notificationDetails(detailUrl), event: event)
            case .goBack:
                return State(stage: .back, event: event)
            case .goBackToTabView:
                return State(stage: .backToTabView, event: event)
            }
        }

        feedback = bind(self) { coordinator, state -> Bindings<Event> in
            let events: [Observable<Event>] = [state.flatMap { state -> Observable<Event> in
                switch state.stage {
                /// On start push to NotificationViewController initailly
                case .notification:
                    var viewController = NotificationViewController.instantiate(
                        fromStoryboardNamed: String(describing: "Notification".self))
                    
                    let viewModel = NotificationViewModel(withRepository: self.repository)
                    viewController.setViewModel(to: viewModel)
                    coordinator.navigationController.pushViewController(viewController, animated: true)
                    if !coordinator.readyForPresentationSubject.isDisposed {
                        coordinator.readyForPresentationSubject.onNext(())
                        coordinator.readyForPresentationSubject.onCompleted()
                    }
                    return viewModel.output.viewComplete
                case .notificationDetails(let detailUrl):
                    /// Push to NotificationDetailViewController
                    if detailUrl != "" {
                        var viewController = NotificationDetailViewController.instantiate(
                            fromStoryboardNamed: String(describing: "Notification".self))
                        
                        let viewModel = NotificationDetailViewModel(withDetailsUrl: detailUrl)
                        viewController.setViewModel(to: viewModel)
                        viewModel.url = detailUrl
                        coordinator.navigationController.pushViewController(viewController, animated: true)
                        if !coordinator.readyForPresentationSubject.isDisposed {
                            coordinator.readyForPresentationSubject.onNext(())
                            coordinator.readyForPresentationSubject.onCompleted()
                        }
                        return viewModel.output.viewComplete
                    } else { return Observable.empty() }
                /// Pop back to base view controller
                case .back:
                    if coordinator.navigationController.viewControllers.count <= 1 {
                        return Observable.just(.goBackToTabView)
                    } else {
                        coordinator.navigationController.popViewController(animated: true)
                        return Observable.empty()
                    }
                /// Dismiss presented viewController
                case .backToTabView:
                    coordinator.navigationController.dismiss(animated: true)
                    return Observable.empty()
                }
                }]
            return Bindings(subscriptions: [], events: events)
        }
    }
    
    /// The start method will actually display the main Notification view/screen
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
