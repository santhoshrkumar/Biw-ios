//
//  LoginCoordinator.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 3/24/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxFeedback
import AppAuth
/**
 Implemetation of the Login Coordinator, enabling simple navigation within and across Login related screens
 */
class LoginCoordinator: Coordinator {
    
    /// Define different states stage/events within or across the coordinator
    struct State {
        let stage: Stage
        let event: Event
    }
    
    /// Define different stages of coordinator navigation within or across
    enum Stage {
        case login
        case logout
        case tab
        case password
        case learnMore
    }
    
    /// Define different event within Login coordinator
    enum Event {
        case start
        case logout
        case goToTabView
        case goToPassword
        case goToLearnMore
    }
    
    /// Defines coordinators initial state
    private let initialState: State = State(stage: .login, event: .start)
    /// Reduce holds state and event
    private let reduce: (State, Event) -> State
    /// Feedback sequence receives elements
    private var feedback: ((ObservableSchedulerContext<State>) -> Observable<Event>)!
    /// Contained disposables disposal
    private let disposeBag = DisposeBag()
    /// Complete subject and observable for view event complete
    private let completeSubject = PublishSubject<MainCoordinator.Event>()
    let complete: Observable<MainCoordinator.Event>
    /// Holds the childCoordinator with a strong reference
    var childCoordinator: Coordinator?
    /// Holds the navigationController with a strong reference
    var navigationController: UINavigationController
    /// Holds the AccountRepository repository with a strong reference
    let accountRepository: AccountRepository
    
    /// Initialise the coordinator
    /// - Parameters:
    ///   - navigationController: navigation stack of UINavigationController
    ///   - networkRepository: accountRepository passed object from previous coordinator
    init(navigationController: UINavigationController, accountRepository: AccountRepository) {
        self.navigationController = navigationController
        self.accountRepository = accountRepository
        complete = completeSubject.asObservable()
        
        /// combination of all state, event and returns current state
        reduce = { state, event -> State in
            switch event {
            case .start:
                return State(stage: .login, event: event)
            case .logout:
                return State(stage: .logout, event: event)
            case .goToTabView:
                return State(stage: .tab, event: event)
            case .goToPassword:
                return State(stage: .password, event: event)
            case .goToLearnMore:
                return State(stage: .learnMore, event: event)
            }
        }
        
        feedback = bind(self) { me, state -> Bindings<Event> in
            let events: [Observable<Event>] = [state.flatMap { state -> Observable<Event> in
                switch state.stage {
                case .login:
                    /// Initially check if user is authorised and token is valid
                    /// If not open SF login page in LoginViewController
                    /// else Check for biometirc if enable open biometric validations/if not directly navigate to tab view
                    let loginSubject = ReplaySubject<Event>.create(bufferSize: 1)
                    let isUserAuthorised = TokenManager.shared.isUserAuthorised()
                    if (!isUserAuthorised) {
                        var loginViewController = LoginViewController.instantiate(fromStoryboardNamed: String(describing: LoginViewController.self))
                        loginViewController.setViewModel(to: LoginViewModel())
                        loginViewController.modalPresentationStyle = .overCurrentContext
                        loginViewController.modalTransitionStyle = .crossDissolve
                        me.navigationController.present(loginViewController, animated: true)
                        loginSubject.onCompleted()
                        return loginViewController.viewModel.output.viewComplete
                    } else {
                        if Biometrics.isBiometricEnabled() {
                            loginSubject.onNext(.goToTabView)
                            loginSubject.onCompleted()
                        } else {
                            loginSubject.onNext(.goToTabView)
                            loginSubject.onCompleted()
                        }
                    }
                    return loginSubject.asObservable()
                /// Logout user and clear token and other user specific details stored in keychain
                case .logout:
                    TokenManager.shared.signOutUser()
                    return Observable.just(.start)
                /// Dismiss login and open tab view
                case .tab:
                    me.navigationController.dismiss(animated: true, completion: nil)
                    let tabCoordinator = TabCoordinator(navigationController: me.navigationController)
                    tabCoordinator.start()
                    return tabCoordinator.complete
                case .password:
                    print("Navigate to Forget Password view")
                    return Observable.empty()
                case .learnMore:
                    print("Navigate to Learn More view")
                    return Observable.empty()
                }
                }]
            return Bindings(subscriptions: [], events: events)
        }
    }
    
    /// The start method will actually display the main Login view/screen
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
