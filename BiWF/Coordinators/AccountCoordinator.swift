//
//  AccountCoordinator.swift
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
 Implemetation of the Account Coordinator, enabling simple navigation within and across Account related screens
 */
class AccountCoordinator: Coordinator {
    
    /// Define different states stage/events within or across the coordinator
    struct State {
        let stage: Stage
        let event: Event
    }

    /// Define different stages of coordinator navigation within or across
    enum Stage {
        case account(String?)
        case personalInfo(Account?)
        case subscription(Subscription)
        case customAlert(String, NSMutableAttributedString)
    }
    
    /// Define different event within account coordinator
    enum Event {
        case start
        case goToPersonalInfo(Account)
        case goToSubscription(Subscription)
        case showCustomAlert(String, NSMutableAttributedString)
        case goBackToPersonalInfo
        case goBackToAccount(String?)
        case logout
        case subscriptionDismissed
    }
    
    /// Defines coordinators initial state
    private let initialState: State = State(stage: .account(nil), event: .start)
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
    ///   - navigationController: the initial UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
        complete = completeSubject.asObservable()
        
        /// combination of all state, event and returns current state
        reduce = { state, event -> State in
            switch event {
            case .start:
                return State(stage: .account(nil), event: event)
            case .goToPersonalInfo(let accountInfo):
                return State(stage: .personalInfo(accountInfo), event: event)
            case .goToSubscription(let subscription):
                return State(stage: .subscription(subscription), event: event)
            case .showCustomAlert(let title, let message):
                return State(stage: .customAlert(title, message), event: event)
            case .goBackToPersonalInfo:
                return State(stage: .personalInfo(nil), event: event)
            case .goBackToAccount(let updatedPhoneNumber):
                return State(stage: .account(updatedPhoneNumber), event: event)
            case .logout:
                return State(stage: .account(nil), event: event)
            case .subscriptionDismissed:
                return State(stage: .account(nil), event: event)
            }
        }
        
        feedback = bind(self) { coordinator, state -> Bindings<Event> in
            let events: [Observable<Event>] = [state.flatMap { state -> Observable<Event> in
                switch state.stage {
                case .account:
                    switch state.event {
                    /// Initialise the first coordinator controller
                    case .start:
                        var viewController = AccountViewController.instantiate(fromStoryboardNamed: String(describing: AccountViewController.self))
                        viewController.setViewModel(to: AccountViewModel(withRepository: AccountRepository(), subscriptionRepository: SubscriptionRepository()))
                        coordinator.navigationController.pushViewController(viewController,
                                                                            animated: false)
                        return viewController.viewModel.output.viewComplete
                    /// Back to Account screen
                    case .goBackToAccount(let updatedPhoneNumber):
                        if let accountController = coordinator.navigationController.viewControllers.first as? AccountViewController {
                            accountController.viewModel.updatePhoneNumber = updatedPhoneNumber
                        }
                        coordinator.navigationController.dismiss(animated: true,
                                                                 completion: nil)
                    /// Logout user and navigate to login
                    case .logout:
                        coordinator.completeSubject.onNext(.goToLogout)
                        return Observable.empty()
                    case .subscriptionDismissed:
                        if let accountController = coordinator.navigationController.viewControllers.first as? AccountViewController {
                            if let accountID = accountController.viewModel.account?.accountId {
                                accountController.viewModel.getPaymentInformation(forAccountId: accountID)
                            } else {
                                accountController.viewModel.getUser()
                            }
                        }
                        
                    default: break
                    }
                /// Navigation for/from personal info screen
                case .personalInfo( _):
                    switch state.event {
                    /// Navigation to personal info screen modal presentation
                    case .goToPersonalInfo(let accountInfo):
                        var viewController = PersonalInfoViewController.instantiate(fromStoryboardNamed: String(describing: AccountViewController.self))
                        viewController.setViewModel(to: PersonalInfoViewModel(withRepository: AccountRepository(),
                                                                              accountInfo: accountInfo))
                        
                        let navController = UINavigationController(rootViewController: viewController)
                        navController.navigationBar.defaultSetup()
                        navController.modalPresentationStyle = .fullScreen
                        coordinator.navigationController.present(navController, animated: true)
                        
                        return viewController.viewModel.output.viewComplete
                    /// Navigation back to presenting viewController
                    case .goBackToPersonalInfo:
                        coordinator.navigationController.presentedViewController?.dismiss(animated: true,
                                                                                          completion: nil)
                    default: break
                    }
                    
                case .subscription(let subscription):
                    /// Navigation to subscription screen modal presentation
                    let navigationController = UINavigationController()
                    navigationController.modalPresentationStyle = .fullScreen
                    let subscriptionCoordinator = SubscriptionCoordinator.init(navigationController: navigationController,
                                                                               subscription: subscription,
                                                                               subscriptionRepository: SubscriptionRepository())
                    subscriptionCoordinator.start()
                    subscriptionCoordinator.readyForPresentation.subscribe(onNext: { _ in
                        coordinator.navigationController.present(navigationController, animated: true)
                    }).disposed(by: coordinator.disposeBag)
                    return subscriptionCoordinator.complete
                    
                case .customAlert(let title, let message):
                    /// Open CustomAlertViewController screen modal presentation
                    var viewController = CustomAlertViewController.instantiate(fromStoryboardNamed: String(describing: AccountViewController.self))
                    viewController.setViewModel(to: CustomAlertViewModel(withTitle: title,
                                                                         message: message,
                                                                         buttonTitleText: Constants.PersonalInformation.buttonText,
                                                                         isPresentedFromWindow: false))
                    viewController.modalPresentationStyle = .overCurrentContext
                    coordinator.navigationController.presentedViewController?.present(viewController, animated: true)
                    return viewController.viewModel.output.viewComplete
                }
                return Observable.empty()
            }]
            return Bindings(subscriptions: [], events: events)
        }
    }
    
    /// The start method will actually display the main account view/screen
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
