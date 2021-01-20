//
//  SubscriptionCoordinator.swift
//  BiWF
//
//  Created by pooja.q.gupta on 14/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxFeedback
/**
 Implemetation of the Subscription Coordinator, enabling simple navigation within and across Subscription related screens
 */
class SubscriptionCoordinator: Coordinator {
    
    /// Define different states stage/events within or across the coordinator
    struct State {
        let stage: Stage
        let event: Event
    }
    
    /// Define different stages of coordinator navigation within or across
    enum Stage {
        case subscription
        case statementDetail(PaymentRecord)
        case manageSubscription(Account)
        case cancelSubscription(Account)
        case back
        case backToAccount
        case errorSavingChanges
        case editPayment
    }
    
    /// Define different event within Subscription coordinator
    enum Event {
        case start(Subscription)
        case goToStatementDetail(PaymentRecord)
        case goToManageSubscription(Account)
        case goToCancelSubscription(Account)
        case goBack
        case goBackToAccount
        case errorSavingChangesAlert
        case dismissAlert
        case goToEditPayment
        case popEditPayment
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
    private let completeSubject = PublishSubject<AccountCoordinator.Event>()
    let complete: Observable<AccountCoordinator.Event>
    /// Complete subject and observable for readyForPresentation
    private let readyForPresentationSubject = PublishSubject<Void>()
    let readyForPresentation: Observable<Void>
    var childCoordinator: Coordinator?
    /// Holds the navigationController with a strong reference
    var navigationController: UINavigationController
    /// Holds the subscriptionRepository with a strong reference
    let subscriptionRepository: SubscriptionRepository
    
    /// Initialise the coordinator
    /// - Parameters:
    ///   - navigationController: navigation stack of UINavigationController
    ///   - subscription: subscription entity passed from last coordinator
    ///   - networkRepository: SubscriptionRepository passed object from previous coordinator
    init(navigationController: UINavigationController, subscription: Subscription, subscriptionRepository: SubscriptionRepository) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.defaultSetup()
        self.subscriptionRepository = subscriptionRepository
        /// Defines coordinators initial state
        initialState = State(stage: .subscription, event: .start(subscription))
        
        complete = completeSubject.asObservable()
        readyForPresentation = readyForPresentationSubject.asObservable()
        
        /// combination of all state, event and returns current state
        reduce = { state, event -> State in
            switch event {
            case .start(_):
                return State(stage: .subscription, event: event)
            case .goToStatementDetail(let paymentRecord):
                return State(stage: .statementDetail(paymentRecord), event: event)
            case .goToManageSubscription(let accountInfo):
                return State(stage: .manageSubscription(accountInfo), event: event)
            case .goToCancelSubscription(let accountInfo):
                return State(stage: .cancelSubscription(accountInfo), event: event)
            case .goBack:
                return State(stage: .back, event: event)
            case .goBackToAccount:
                return State(stage: .backToAccount, event: event)
            case .errorSavingChangesAlert:
                return State(stage: .errorSavingChanges, event: event)
            case .dismissAlert:
                return State(stage: .errorSavingChanges, event: event)
            case .goToEditPayment:
                return State(stage: .editPayment, event: event)
            case .popEditPayment:
                return State(stage: .subscription, event: event)
            }
        }
        
        feedback = bind(self) { coordinator, state -> Bindings<Event> in
            let events: [Observable<Event>] = [state.flatMap { state -> Observable<Event> in
                switch state.stage {
                case .subscription:
                    switch state.event {
                    /// On start initially coordinator pushes SubscriptionViewController
                    case .start(let subscription):
                        var viewController = SubscriptionViewController.instantiate(
                            fromStoryboardNamed: Constants.Subscription.storyBoardIdentifier)
                        let viewModel = SubscriptionViewModel(with: subscription,
                                                              repository: subscriptionRepository)
                        viewController.setViewModel(to: viewModel)
                        coordinator.navigationController.pushViewController(viewController, animated: true)
                        coordinator.readyForPresentationSubject.onNext(())
                        coordinator.readyForPresentationSubject.onCompleted()
                        return viewModel.output.viewComplete
                    /// Pop from edit payment screen after updation
                    case .popEditPayment:
                        coordinator.navigationController.popViewController(animated: true)
                        if let subscriptionController = coordinator.navigationController.viewControllers.first as? SubscriptionViewController {
                            subscriptionController.viewModel.updatePaymentInfo()
                        }
                        return .empty()
                        
                    default:
                        return .empty()
                    }
                /// Navigating to StatementDetailViewController
                case .statementDetail(let paymentRecord):
                    var viewController = StatementDetailViewController.instantiate(
                        fromStoryboardNamed: Constants.Subscription.storyBoardIdentifier)
                    let viewModel = StatementDetailViewModel(withRepository: SubscriptionRepository(),
                                                             paymentRecord: paymentRecord)
                    viewController.setViewModel(to: viewModel)
                    coordinator.navigationController.pushViewController(viewController, animated: true)
                    return viewModel.output.viewComplete
                /// Navigating to ManageSubscriptionViewController
                case .manageSubscription(let accountInfo):
                    var viewController = ManageSubscriptionViewController.instantiate(
                        fromStoryboardNamed: Constants.Subscription.storyBoardIdentifier)
                    let viewModel = ManageSubscriptionViewModel(withAccount: accountInfo)
                    viewController.setViewModel(to: viewModel)
                    coordinator.navigationController.pushViewController(viewController, animated: true)
                    return viewModel.output.viewComplete
                /// Navigating to CancelSubscriptionViewController
                case .cancelSubscription(let accountInfo):
                    var viewController = CancelSubscriptionViewController.instantiate(
                        fromStoryboardNamed: Constants.Subscription.storyBoardIdentifier)
                    let viewModel = CancelSubscriptionViewModel(withAccount: accountInfo,
                                                                subscriptionRepository: SubscriptionRepository())
                    viewController.setViewModel(to: viewModel)
                    coordinator.navigationController.pushViewController(viewController, animated: true)
                    return viewModel.output.viewComplete
                /// Pop back to initial view
                case .back:
                    coordinator.navigationController.popViewController(animated: true)
                    return Observable.empty()
                /// Move back to Account
                case .backToAccount:
                    coordinator.navigationController.dismiss(animated: true)
                    coordinator.completeSubject.onNext(.subscriptionDismissed)
                    coordinator.completeSubject.onCompleted()
                    return Observable.empty()
                    
                case .errorSavingChanges:
                    
                    switch state.event {
                    /// Present CustomAlertViewController
                    case .errorSavingChangesAlert:
                        var viewController = CustomAlertViewController.instantiate(fromStoryboardNamed: String(describing: AccountViewController.self))
                        viewController.setViewModel(to: CustomAlertViewModel(withTitle: Constants.Common.anErrorOccurred,
                                                                             message:  Constants.Common.errorSavingChanges.attributedString(),
                                                                             buttonTitleText: Constants.Common.discardChangesAndClose,
                                                                             isPresentedFromWindow: false))
                        viewController.modalPresentationStyle = .overCurrentContext
                        coordinator.navigationController.present(viewController, animated: true)
                        return viewController.viewModel.output.complete
                    /// Dismiss presented Alert
                    case .dismissAlert:
                        coordinator.navigationController.dismiss(animated: false) {
                            coordinator.navigationController.popViewController(animated: true)
                        }
                    default:
                        break
                    }
                    return Observable.empty()
                /// Navigating to EditPaymentViewController
                case .editPayment:
                    var viewController = EditPaymentViewController.instantiate(fromStoryboardNamed: Constants.Subscription.storyBoardIdentifier)
                    let viewModel = EditPaymentViewModel()
                    viewController.setViewModel(to: viewModel)
                    coordinator.navigationController.pushViewController(viewController, animated: true)
                    return viewModel.output.viewComplete
                }
            }]
            return Bindings(subscriptions: [], events: events)
        }
    }
    
    /// The start method will actually display the main Subscription view/screen
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
