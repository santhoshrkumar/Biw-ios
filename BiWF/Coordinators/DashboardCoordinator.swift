//
//  DashboardCoordinator.swift
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
class DashboardCoordinator: Coordinator {
    
    /// Define different states stage/events within or across the coordinator
    struct State {
        let stage: Stage
        let event: Event
    }
    
    /// Define different stages of coordinator navigation within or across
    enum Stage {
        case dashboardContainer
        case changeAppointment(ServiceAppointment)
        case devices
        case dashboard
        case newUserDashboard(Bool)
        case notification(String)
        case network(WiFiNetwork, WiFiNetwork, [String: String])
        case back
        case appointmentBooked(ArrivalTime, AppointmentType)
        case joinCode(WiFiNetwork)
        case errorSavingChanges
    }
    
    /// Define different event within Dashboard coordinator
    enum Event {
        case start
        case goToChangeAppointment(ServiceAppointment)
        case goToDevices
        case goToStandardDashboard
        case goToNewUserDashboard(Bool)
        case openNotification(String)
        case goToNetwork(WiFiNetwork, WiFiNetwork, [String: String])
        case dismissNetwork
        case goBackToDashboard
        case goBack
        case goToAppointmentBookingConfirmation(ArrivalTime, AppointmentType)
        case goToJoinCode(WiFiNetwork)
        case errorSavingChangesAlert
        case errorInViewingNetworkInfo
        case dismissAlert
    }
    
    /// Defines coordinators initial state
    private let initialState: State = State(stage: .dashboardContainer, event: .start)
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
    /// Show device tab subject and observable
    private let showDevicesTabSubject = PublishSubject<Bool>()
    let showDevicesTabObservable: Observable<Bool>
    /// Holds the repositories with a strong reference
    let appointmentRepository: AppointmentRepository
    let networkRepository: NetworkRepository
    let deviceRepository: DeviceRepository
    
    /// Initialise the coordinator
    /// - Parameters:
    ///   - navigationController: navigation stack of UINavigationController
    ///   - appointmentRepository: appointmentRepository initialised object
    ///   - networkRepository: networkRepository passed object from previous coordinator
    ///   - deviceRepository: deviceRepository passed object from previous coordinator
    init(
        navigationController: UINavigationController,
        appointmentRepository: AppointmentRepository = AppointmentRepository(),
        networkRepository: NetworkRepository,
        deviceRepository: DeviceRepository
    ) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
        self.appointmentRepository = appointmentRepository
        self.networkRepository = networkRepository
        self.deviceRepository = deviceRepository
        
        var dashboardContainerViewController = DashboardContainerViewController()
        let dashboardContainerViewModel = DashboardContainerViewModel(
            accountRepository: AccountRepository(),
            appointmentRepository: appointmentRepository,
            notificationRepository: NotificationRepository(),
            networkRepository: networkRepository,
            deviceRepository: deviceRepository
        )
        dashboardContainerViewController.setViewModel(to: dashboardContainerViewModel)
        
        complete = completeSubject.asObservable()
        showDevicesTabObservable = showDevicesTabSubject.asObservable()
        
        /// combination of all state, event and returns current state
        reduce = { state, event -> State in
            switch event {
            case .start:
                return State(stage: .dashboardContainer, event: event)
            case .goToChangeAppointment(let appointment):
                return State(stage: .changeAppointment(appointment), event: event)
            case .goToDevices:
                return State(stage: .devices, event: event)
            case .goToStandardDashboard:
                return State(stage: .dashboard, event: event)
            case .goToNewUserDashboard(let didShowDevicesTab):
                return State(stage: .newUserDashboard(didShowDevicesTab), event: event)
            case .openNotification(let url):
                return State(stage: .notification(url), event: event)
            case .goToNetwork(let myNetwork, let guestNetwork, let bssidInfo):
                return State(stage: .network(myNetwork, guestNetwork, bssidInfo), event: event)
            case .dismissNetwork:
                return State(stage: .dashboard, event: event)
            case .goBackToDashboard:
                return State(stage: .dashboardContainer, event: event)
            case .goBack:
                return State(stage: .back, event: event)
            case .goToAppointmentBookingConfirmation(let arrivalTime, let appointmentType):
                return State(stage: .appointmentBooked(arrivalTime, appointmentType), event: event)
            case .goToJoinCode(let wifiNetwork):
                return State(stage: .joinCode(wifiNetwork), event: event)
            case .errorSavingChangesAlert:
                return State(stage: .errorSavingChanges, event: event)
            case .errorInViewingNetworkInfo:
                return State(stage: .errorSavingChanges, event: event)
            case .dismissAlert:
                return State(stage: .errorSavingChanges, event: event)
            }
        }
        
        feedback = bind(self) { me, state -> Bindings<Event> in
            let events: [Observable<Event>] = [state.flatMap { state -> Observable<Event> in
                
                switch state.stage {
                case .dashboardContainer:
                    switch state.event {
                    /// On start push to dashboardContainerViewController
                    case .start:
                        me.navigationController.pushViewController(dashboardContainerViewController, animated: true)
                        return dashboardContainerViewModel.output.viewComplete.asObservable()
                    /// Go back to dashboard after dismissing current presented controller
                    case .goBackToDashboard:
                        me.navigationController.dismiss(animated: true,completion: nil)
                        
                    default: break
                    }
                /// Navigation to ModifyAppointmentViewController
                case .changeAppointment(let appointmentInfo):
                    var viewController = ModifyAppointmentViewController.instantiate(fromStoryboardNamed: "NewUserDashboard")
                    viewController.setViewModel(to: ModifyAppointmentViewModel(with: appointmentInfo, and: AppointmentRepository()))
                    
                    let navController = UINavigationController(rootViewController: viewController)
                    navController.navigationBar.defaultSetup()
                    navController.modalPresentationStyle = .fullScreen
                    
                    me.navigationController.present(navController, animated: true)
                    return viewController.viewModel.output.viewComplete
                /// Navigate to Devices view controller using Device coordinators event
                case .devices:
                    me.completeSubject.onNext(.goToDevices)
                    return Observable.empty()
                    
                case .dashboard:
                    switch state.event {
                    /// Show dismissNetwork
                    case .dismissNetwork:
                        me.navigationController.presentedViewController?.dismiss(animated: true)
                        return Observable.empty()
                    /// Show device tab
                    default:
                        me.showDevicesTabSubject.onNext(true)
                        dashboardContainerViewController.displayDashboard()
                        return dashboardContainerViewModel.dashboardViewModel.output.viewComplete
                    }
                /// Show NewUserDashboard
                case .newUserDashboard(let didShowDevicesTab):
                    me.showDevicesTabSubject.onNext(didShowDevicesTab)
                    dashboardContainerViewController.displayNewUserDashboard()
                    return dashboardContainerViewModel.commonDashboardViewModel .output.viewComplete
                /// Navigate to Notification view controller using Notification coordinators event
                case .notification(let url):
                    me.completeSubject.onNext(.goToNotification(url))
                    return Observable.empty()
                /// Pop back to parent controller
                case .back:
                    me.navigationController.popViewController(animated: true)
                    return Observable.empty()
                /// Navigation to AppointmentConfirmationViewControllers
                case .appointmentBooked(let arrivalTime, let appointmentType):
                    var viewController = AppointmentConfirmationViewController.instantiate(fromStoryboardNamed: "NewUserDashboard")
                    viewController.setViewModel(to: AppointmentConfirmationViewModel(with: arrivalTime, appointmentType: appointmentType))
                    if let navController = me.navigationController.presentedViewController as? UINavigationController {
                        navController.pushViewController(viewController, animated: true)
                    }
                    return viewController.viewModel.output.viewComplete
                /// Navigation to NetworkInfoViewController
                case .network(let myNetwork, let guestNetwork, let bssidInfo):
                    var viewController = NetworkInfoViewController.instantiate(fromStoryboardNamed: String(describing: NetworkInfoViewController.self))
                    viewController.setViewModel(to: NetworkInfoViewModel(with: myNetwork, guestNetwork: guestNetwork, networkRepository: me.networkRepository, and: bssidInfo))
                    
                    let navController = UINavigationController(rootViewController: viewController)
                    navController.navigationBar.defaultSetup()
                    navController.modalPresentationStyle = .fullScreen
                    
                    me.navigationController.present(navController, animated: true)
                    return viewController.viewModel.output.viewComplete
                /// Navigation to QRCodeViewController
                case .joinCode(let network):
                    var viewController = QRCodeViewController.instantiate(fromStoryboardNamed: String(describing: DashboardViewController.self))
                    viewController.setViewModel(to: QRCodeViewModel(wifiNetwork: network))
                    
                    let navController = UINavigationController(rootViewController: viewController)
                    navController.navigationBar.defaultSetup()
                    navController.modalPresentationStyle = .fullScreen
                    
                    me.navigationController.present(navController, animated: true)
                    return viewController.viewModel.output.viewComplete
                    
                case .errorSavingChanges:
                    
                    switch state.event {
                    /// Navigation to CustomAlertViewController
                    case .errorSavingChangesAlert:
                        var viewController = CustomAlertViewController.instantiate(fromStoryboardNamed: String(describing: AccountViewController.self))
                        viewController.setViewModel(to: CustomAlertViewModel(withTitle: Constants.Common.anErrorOccurred,
                                                                             message:  Constants.Common.errorSavingChanges.attributedString(),
                                                                             buttonTitleText: Constants.Common.discardChangesAndClose,
                                                                             isPresentedFromWindow: false))
                        viewController.modalPresentationStyle = .overCurrentContext
                        me.navigationController.presentedViewController?.present(viewController, animated: true)
                        return viewController.viewModel.output.viewCompleteForDashboardCoordinator
                        
                    case .errorInViewingNetworkInfo:
                        var viewController = CustomAlertViewController.instantiate(fromStoryboardNamed: String(describing: AccountViewController.self))
                        viewController.setViewModel(to: CustomAlertViewModel(withTitle: "",
                                                                             message:  Constants.DashboardContainer.networkInformationRetryMessage.attributedString(with: UIFont.regular(ofSize: UIFont.font16), textColor: UIColor.BiWFColors.dark_grey),
                                                                             buttonTitleText: Constants.Common.ok,
                                                                             isPresentedFromWindow: false))
                        viewController.modalPresentationStyle = .overCurrentContext
                        AlertPresenter.topViewController?.present(viewController, animated: true)
                        return viewController.viewModel.output.viewCompleteForDashboardCoordinator
                    /// Dismiss presented viewController
                    case .dismissAlert:
                        me.navigationController.dismiss(animated: false) {
                            me.navigationController.popViewController(animated: true)
                        }
                        
                    default:
                        break
                    }
                    return Observable.empty()
                }
                
                return Observable.empty()
                }]
            return Bindings(subscriptions: [], events: events)
        }
    }
    
    /// The start method will actually display the main Dashboard view/screen
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
