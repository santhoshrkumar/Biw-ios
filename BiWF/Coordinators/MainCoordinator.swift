//
//  MainCoordinator.swift
//  TemplateApp
//
//  Created by Steve Galbraith on 9/16/19.
//  Copyright © 2019 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxFeedback
/**
 Implemetation of the Main Coordinator, enabling simple navigation within and across whole application
 */
class MainCoordinator : Coordinator {
    
    /// Define different states stage/events within or across the coordinator
    struct State {
        let stage: Stage
        let event: Event
    }
    
    /// Define different stages of coordinator navigation within or across
    enum Stage {
        case login
    }
    
    /// Define different event within Device coordinator
    enum Event {
        case start
    }
    
    /// Defines coordinators initial state
    private let initialState: State = State(stage: .login, event: .start)
    /// Reduce holds state and event
    private let reduce: (State, Event) -> State
    /// Feedback sequence receives elements
    private var feedback: ((ObservableSchedulerContext<State>) -> Observable<Event>)!
    /// Contained disposables disposal
    private let disposeBag = DisposeBag()
    /// Make the childCoordinator with a strong reference
    var childCoordinator: Coordinator?
    /// Make the navigationController with a strong reference
    var navigationController: UINavigationController
    /// Holds the Repository with a strong reference
    let repository: Repository?
    
    /// Initialise the coordinator
    /// - Parameters:
    ///   - navigationController: navigation stack of UINavigationController
    ///   - repository: Main tRepository initialised object
    init(navigationController: UINavigationController, repository: Repository? = nil) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
        self.repository = repository
        reduce = { state, event -> State in
            return State(stage: .login, event: event)
        }
        feedback = bind(self) { me, state -> Bindings<Event> in
            let events: [Observable<Event>] = [state.flatMap { state -> Observable<Event> in
                /// On start open SplashScreenViewController
                switch state.event {
                case .start:
                    let viewController = SplashScreenViewController.instantiate(fromStoryboardNamed: String(describing: SplashScreenViewController.self))
                    me.navigationController.pushViewController(viewController, animated: false)
                }

                /// Open LoginCoordinator initially
                switch state.stage {
                case .login:
                    let coordinator = LoginCoordinator(navigationController: me.navigationController, accountRepository: AccountRepository())
                    coordinator.start()
                    return coordinator.complete
                }
                }]
            return Bindings(subscriptions: [], events: events)
        }
    }
    
    /// The start method will actually display the main opening view
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
