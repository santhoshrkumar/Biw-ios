
//
//  SupportCoordinator.swift
//  BiWF
//
//  Created by pooja.q.gupta on 01/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxFeedback
import ServiceCore
import ServiceChat
/**
 Implemetation of the Support Coordinator, enabling simple navigation within and across Support related screens
 */
class SupportCoordinator: NSObject, Coordinator {
    
    /// Define different states stage/events within or across the coordinator
    struct State {
        let stage: Stage
        let event: Event
    }
    
    /// Define different stages of coordinator navigation within or across
    enum Stage {
        case support
        case chat
        case visitWebsite
        case scheduleCallback
        case additionalInfo(ScheduleCallback)
        case faq([FaqRecord])
        case backToTabView
        case backToSupport
        case contactInformation(ScheduleCallback)
        case selectTimeScheduleCallback(ScheduleCallback)
    }
    
    /// Define different event within Support coordinator
    enum Event {
        case start
        case goToChat
        case goToWebsite
        case goToScheduleCallback
        case goToAdditionalInfo(ScheduleCallback)
        case goToContactInformation(ScheduleCallback)
        case goToSelectTimeScheduleCallback(ScheduleCallback)
        case goToFaq([FaqRecord])
        case goBackToTabView
        case goBack
    }
    
    /// Defines coordinators initial state
    private let initialState: State = State(stage: .support, event: .start)
    /// Reduce holds state and event
    private let reduce: (State, Event) -> State
    /// Feedback sequence receives elements
    private var feedback: ((ObservableSchedulerContext<State>) -> Observable<Event>)!
    /// Contained disposables disposal
    private let disposeBag = DisposeBag()
    /// Complete subject and observable for view event complete
    private let completeSubject = PublishSubject<TabCoordinator.Event>()
    let complete: Observable<TabCoordinator.Event>
    /// Complete subject and observable for readyForPresentation
    private let readyForPresentationSubject = PublishSubject<Void>()
    let readyForPresentation: Observable<Void>
    /// Holds the childCoordinator with a strong reference
    var childCoordinator: Coordinator?
    /// Holds the navigationController with a strong reference
    var navigationController: UINavigationController
    /// Holds the authSettings with a strong reference
    private var authSettings: SCSAuthenticationSettings?
    /// Holds the NetworkRepository repository with a strong reference
    private var networkRepository: NetworkRepository

    /// Initialise the coordinator
    /// - Parameters:
    ///   - navigationController: navigation stack of UINavigationController
    ///   - networkRepository: networkRepository passed object from previous coordinator
    init(navigationController: UINavigationController, networkRepository: NetworkRepository) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = false
        
        complete = completeSubject.asObservable()
        readyForPresentation = readyForPresentationSubject.asObservable()
        self.networkRepository = networkRepository

        /// combination of all state, event and returns current state
        reduce = { state, event -> State in
            switch event {
            case .start:
                return State(stage: .support, event: event)
            case .goBackToTabView:
                return State(stage: .backToTabView, event: event)
            case .goToChat:
                return State(stage: .chat, event: event)
            case .goToWebsite:
                return State(stage: .visitWebsite, event: event)
            case .goToScheduleCallback:
                return State(stage: .scheduleCallback, event: event)
            case .goToAdditionalInfo(let scheduleCallbackDetails):
                return State(stage: .additionalInfo(scheduleCallbackDetails), event: event)
            case .goToFaq(let faqTopic):
                return State(stage: .faq(faqTopic), event: event)
            case .goBack:
                return State(stage: .backToSupport, event: event)
            case .goToContactInformation(let scheduleCallbackDetails):
                return State(stage: .contactInformation(scheduleCallbackDetails), event: event)
            case .goToSelectTimeScheduleCallback(let scheduleCallbackDetails):
                return State(stage: .selectTimeScheduleCallback(scheduleCallbackDetails), event: event)
            }
        }
        
        super.init()
        ///Set up the cloud shared delegates and chat core for live chat
        ServiceCloud.shared().delegate = self
        ServiceCloud.shared().chatCore.add(delegate: self)
        createAuthSettings()
        configChatAppearance()
        
        feedback = bind(self) { coordinator, state -> Bindings<Event> in
            let events: [Observable<Event>] = [state.flatMap { state -> Observable<Event> in
                
                switch state.stage {
                /// On start push to SupportViewController initially
                case .support:
                    ///Setting navigation bar visibility as per new design
                    navigationController.navigationBar.defaultSetup()
                    
                    var viewController = SupportViewController.instantiate(fromStoryboardNamed: "Support", in: nil)
                    let viewModel = SupportViewModel.init(with: SupportRepository(), and: coordinator.networkRepository)
                    viewController.setViewModel(to: viewModel)
                    navigationController.pushViewController(viewController, animated: true)
                    coordinator.readyForPresentationSubject.onNext(())
                    coordinator.readyForPresentationSubject.onCompleted()
                    return viewModel.output.viewComplete
                /// Dismiss presented viewController
                case .backToTabView:
                    coordinator.navigationController.dismiss(animated: true)
                    return Observable.empty()
                /// Configure and open configureChatSession
                case .chat:
                    coordinator.configureChatSession()
                    return Observable.empty()
                case .visitWebsite:
                    print("Navigate to website")
                    return Observable.empty()
                /// Push to ScheduleCallbackViewController screen
                case .scheduleCallback:
                    var viewController = ScheduleCallbackViewController.instantiate(fromStoryboardNamed: "Support".self)
                    let viewModel = ScheduleCallbackViewModel.init(with: SupportRepository())
                    viewController.setViewModel(to: viewModel)
                    coordinator.navigationController.pushViewController(viewController,
                                                                        animated: true)
                    return viewModel.output.viewComplete
                 /// Push to AdditionalInfoViewController screen
                case .additionalInfo(let scheduleCallbackDetails):
                    var viewController = AdditionalInfoViewController.instantiate(fromStoryboardNamed: "Support".self)
                    let viewModel = AdditionalInfoViewModel.init(scheduleCallBack: scheduleCallbackDetails)
                    viewController.setViewModel(to: viewModel)
                    coordinator.navigationController.pushViewController(viewController,
                                                                        animated: true)
                    return viewModel.output.viewComplete
                /// Push to faq screen
                case .faq(let faqRecords):
                    ///Setting navigation bar visibility as per new design
                    navigationController.navigationBar.isHidden = false
                    navigationController.navigationBar.defaultSetup()
                    
                    var viewController = FAQTopicsViewController.instantiate(fromStoryboardNamed: "Support".self)
                    let viewModel = FAQTopicsViewModel.init(withRepository: SupportRepository(),
                                                            faqTopics: faqRecords)
                    viewController.setViewModel(to: viewModel)
                    coordinator.navigationController.pushViewController(viewController,
                                                                        animated: true)
                    return viewModel.output.viewComplete
                /// Pop back to parent controller
                case .backToSupport:
                    coordinator.navigationController.popViewController(animated: true)
                    return Observable.empty()
                /// Navigate to scheduleCallbackDetails
                case .selectTimeScheduleCallback(let scheduleCallbackDetails):
                    var viewController = SelectTimeViewController.instantiate(fromStoryboardNamed: "Support".self)
                    
                    let viewModel = SelectTimeViewModel(with: SupportRepository(), scheduleCallbackInfo: scheduleCallbackDetails)
                    viewController.setViewModel(to: viewModel)
                    coordinator.navigationController.pushViewController(viewController,
                                                                        animated: true)
                    return viewModel.output.viewComplete
                /// Navigate to contactInformation
                case .contactInformation(let scheduleCallback):
                    var viewController = ContactInfoViewController.instantiate(fromStoryboardNamed: "Support".self)
                    let viewModel = ContactInfoViewModel.init(scheduleCallBack: scheduleCallback)
                    viewController.setViewModel(to: viewModel)
                    coordinator.navigationController.pushViewController(viewController,
                                                                        animated: true)
                    return viewModel.output.viewComplete
                }
                }]
            return Bindings(subscriptions: [], events: events)
        }
    }
    
    /// The start method will actually display the main Support view/screen
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

// MARK: SCServiceCloudDelegate
extension SupportCoordinator: SCServiceCloudDelegate {
    private func createAuthSettings() {
        // Create auth settings object from AccessToken, refresh token, client ID and org url
        // Specify auth info
        let myClientId: String = EnvironmentPath.Login.clientId
        let authDictionary: [SCSOAuth2JSONKey: String] = [.instanceUrl: EnvironmentPath.Login.issuerUrl,
                                                           .accessToken: ServiceManager.shared.accessToken,
                                                           .refreshToken: TokenManager.shared.getRefreshToken()]
         
        // Create auth settings object
        authSettings = SCSAuthenticationSettings(oauth2: authDictionary, clientId: myClientId)
    }
    
    private func configChatAppearance() {
        // Create appearance configuration instance
        let appearance = SCAppearanceConfiguration()

        // Customize color tokens
        appearance.setColor(UIColor.BiWFColors.purple, forName: .brandPrimary)
        appearance.setColor(UIColor.BiWFColors.purple, forName: .brandSecondary)
        appearance.setColor(UIColor.BiWFColors.purple, forName: .contrastPrimary)
        appearance.setColor(UIColor.BiWFColors.purple, forName: .navbarInverted)
        appearance.setColor(UIColor.BiWFColors.purple, forName: .brandSecondaryInverted)
        
        // Save configuration instance
        ServiceCloud.shared().appearanceConfiguration = appearance
    }

    func serviceCloud(_ serviceCloud: ServiceCloud, shouldAuthenticateServiceType service: SCServiceType, completion: @escaping (SCSAuthenticationSettings?) -> Void) -> Bool {
        completion(authSettings)
        return true
    }
}

// MARK: SCSChatSessionDelegate
extension SupportCoordinator: SCSChatSessionDelegate{
    
    private func configureChatSession() {
        
        let buttonID = ServiceManager.shared.billingState?.lowercased() == Constants.Chat.chatAmbassadorState ? EnvironmentPath.ambassadorButtonID : EnvironmentPath.buttonID
        
        guard let config = SCSChatConfiguration(
            liveAgentPod: EnvironmentPath.liveAgentPod,
            orgId: EnvironmentPath.orgID,
            deploymentId: EnvironmentPath.deploymentID,
            buttonId: buttonID
            )
            else { return }
        
        config.defaultToMinimized = false
        ServiceCloud.shared().chatUI.showChat(with: config)
    }
    
    func session(_ session: SCSChatSession!, didEnd endEvent: SCSChatSessionEndEvent!) {
        var description = ""
        switch endEvent.reason {
        case .agent:
            description = Constants.Chat.agentEndedSession
        case .noAgentsAvailable:
            description = Constants.Chat.noAgentsAvailable
        case .user:
            description = Constants.Chat.userEndedSession
        default:
            description = Constants.Chat.sessionEndReasonUnknown
        }
        presentChatAlert(title: Constants.Chat.sessionEnded, description: description)
    }
    
    func session(_ session: SCSChatSession!, didError error: Error!, fatal: Bool) {
        print("Chat error: \(error.localizedDescription)")
        let error  = error as NSError
        var description = ""
        var shouldAlertUser = true
        switch  error.code {
        case SCSChatErrorCode.existingSessionError.rawValue:
            description = Constants.Chat.existingSessionErrorDescription
        case SCSChatErrorCode.sessionCreationError.rawValue:
            description = Constants.Chat.sessionCreationErrorDescription
        default:
            description = Constants.Chat.unexpectedError
            shouldAlertUser = fatal
        }
        if shouldAlertUser {
            presentChatAlert(title: Constants.Chat.error, description: description)
        }
    }
    
    private func presentChatAlert(title: String, description: String) {
        let alert = UIAlertController(title: title,
                                      message: description,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.Common.ok,
                                     style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        navigationController.present(alert, animated: true, completion: nil)
    }
}

