//
//  DashboardViewModel.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/2/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
/*
 DashboardViewModel to handle Dashboard
 */
class DashboardViewModel {
    
    /// Input structure
    struct Input {
        let connectedDevicesSelectedObserver: AnyObserver<Void>
        let networkSelectedObserver: AnyObserver<(WiFiNetwork, WiFiNetwork, [String: String])>
    }
    
    /// Output structure
    struct Output {
        let viewStatusObservable: Observable<ViewStatus>
        let viewComplete: Observable<DashboardCoordinator.Event>
        let indicatorViewObservable: Observable<Bool>
    }
    
    /// Input/Output structure variables
    let input: Input
    let output: Output
    
    var isEnableWifiNetwork = false
    let sections = BehaviorSubject(value: [TableDataSource]())
    
    /// Subject to view the status
    private let viewStatusSubject = PublishSubject<ViewStatus>()
    
    /// Subject to show hide indicator view
    let indicatorViewStatusSubject = PublishSubject<Bool>()
    
    /// Subject to to handle connected device
    private let connectedDevicesSelectedSubject = PublishSubject<Void>()
    
    /// Subject to handle network selection
    private let networkSelectedSubject = PublishSubject<(WiFiNetwork, WiFiNetwork, [String: String])>()
    
    /// Subject to open the notification
    private let openNotificationSubject = PublishSubject<String>()
    
    /// Subject to join the network
    private let openJoinNetworkSubject = PublishSubject<WiFiNetwork>()
    let showRetryAlertSubject = PublishSubject<Void>()

    private let disposeBag = DisposeBag()
    
    /// Holds notificationRepository with strong reference
    private let notificationRepository: NotificationRepository
    
    /// Holds networkRepository with strong reference
    private let networkRepository: NetworkRepository
    
    /// Holds deviceRepository with strong reference
    let deviceRepository: DeviceRepository
    private var hideNotifications = false

    /// Subject to show error alert
    let showErrorAlertSubject = PublishSubject<(isForEnable: Bool, interface: String)>()

    var myNetwork = WiFiNetwork(name: "", password: "", isGuestNetwork: false, isEnabled: false)
    var guestNetwork = WiFiNetwork(name: "", password: "", isGuestNetwork: true, isEnabled: false)
    var bssidInfo: [String: String] = [String: String]()
    private var deviceCount = 0
    var currentAppointment: ServiceAppointment? {
        didSet {
            setSections()
        }
    }
    let commonDashboardViewModel: CommonDashboardViewModel
    private var shouldShowSpeeedTest = false
    
    /// Initializes a new instance of NotificationRepository, NetworkRepository and DeviceRepository
    /// - Parameter notificationRepository : to get api values on notification
    /// networkRepository : to get api values on network
    /// deviceRepository : to get api values on device
    init(commonDashboardViewModel: CommonDashboardViewModel, notificationRepository: NotificationRepository, networkRepository: NetworkRepository, deviceRepository: DeviceRepository) {
        self.notificationRepository = notificationRepository
        self.networkRepository = networkRepository
        self.deviceRepository = deviceRepository
        self.commonDashboardViewModel = commonDashboardViewModel
        
        input = Input( connectedDevicesSelectedObserver: connectedDevicesSelectedSubject.asObserver(),
                       networkSelectedObserver: networkSelectedSubject.asObserver())
        
        let devicesEventObservable = connectedDevicesSelectedSubject.asObservable().map { _ -> DashboardCoordinator.Event in
            return DashboardCoordinator.Event.goToDevices
        }
        
        let networkEventObservable = networkSelectedSubject.asObservable().map { (myNetwork, guestNetwork, bssidInfo)  in
            return DashboardCoordinator.Event.goToNetwork(myNetwork, guestNetwork, bssidInfo)
        }
        
        let openNotificationEventObservable = openNotificationSubject.asObservable().map { url in
            return DashboardCoordinator.Event.openNotification(url)
        }
        
        let openJoinNetworkEventObservable = openJoinNetworkSubject.asObservable().map { wifiNetwork in
            return DashboardCoordinator.Event.goToJoinCode(wifiNetwork)
        }
        
        let errorSavingChangesObservable = showRetryAlertSubject.asObservable().map { _ in
            return DashboardCoordinator.Event.errorInViewingNetworkInfo
        }
        
        let viewCompleteObservable = Observable.merge(devicesEventObservable,
                                                      openNotificationEventObservable,
                                                      networkEventObservable,
                                                      openJoinNetworkEventObservable,
                                                      errorSavingChangesObservable,
                                                      commonDashboardViewModel.output.viewComplete)
        
        let viewStatusObservable = Observable.merge(viewStatusSubject.asObservable(),
                                                    commonDashboardViewModel.output.viewStatusObservable)
        output = Output(viewStatusObservable: viewStatusObservable,
                        viewComplete: viewCompleteObservable,
                        indicatorViewObservable: indicatorViewStatusSubject.asObservable())
        
        setSections()
        runSpeedTest()
        
        deviceRepository.deviceListCountSubject.subscribe(onNext: { (count) in
            self.deviceCount = count
            self.setSections()
        }).disposed(by: disposeBag)
        
        commonDashboardViewModel.serviceAppointmentCompleted.subscribe(onNext: { [weak self] (isCompleted) in
            if isCompleted {
                self?.currentAppointment = nil
            }
            self?.setSections()
            self?.runSpeedTest()
        }).disposed(by: disposeBag)
        
        commonDashboardViewModel.sections.subscribe(onNext: { (_) in
            self.setSections()
        }).disposed(by: disposeBag)
        
        self.networkRepository.isSpeedTestEnableSubject.subscribe(onNext: { (show) in
            //TODO: this can be updated when we get speed test enable value in API response currently we are hidding speedtest view
            self.shouldShowSpeeedTest = false //show
            self.setSections()
        }).disposed(by: disposeBag)
    }
    
    ///Check depending on showing or hide test case will call runspeedtest function of network repository
    private func runSpeedTest() {
        if shouldShowSpeeedTest {
            networkRepository.runSpeedTest()
        }
    }
    
    ///Get password and SSID/Network name for network bands, calling API for both main and guest network in order to get both the passwords
    func getNetworkDetails() {
        setSSID(from: networkRepository)
        getPassword(forInterface: NetworkRepository.Bands.Band5G.rawValue,
                    networkRepository: networkRepository)
        getPassword(forInterface: NetworkRepository.Bands.Band5G_Guest.rawValue,
                    networkRepository: networkRepository)
    }
    
    /// Setting the SSID to user from networkRepository
    /// - Parameter networkRepository : to get api values on network
    private func setSSID(from networkRepository: NetworkRepository) {
        networkRepository.ssidInfoSubject.subscribe(onNext: {[weak self] (myNetworkName, guestNetworkName) in
            guard let self = self else { return }
            self.myNetwork.name = myNetworkName
            self.guestNetwork.name = guestNetworkName
            self.setSections()
        }).disposed(by: disposeBag)
        
        networkRepository.bssidMapSubject.subscribe(onNext: {[weak self] (bssidInfo) in
            guard let self = self else { return }
            self.bssidInfo = bssidInfo
            if bssidInfo.count == 0 {
                self.myNetwork.isEnabled = false
                self.guestNetwork.isEnabled = false
            } else {
                if ((bssidInfo.values.contains(NetworkRepository.Bands.Band2G.rawValue)) && (bssidInfo.values.contains(NetworkRepository.Bands.Band5G.rawValue))) {
                    self.myNetwork.isEnabled = true
                }
                if ((bssidInfo.values.contains(NetworkRepository.Bands.Band2G_Guest.rawValue)) && (bssidInfo.values.contains(NetworkRepository.Bands.Band5G_Guest.rawValue))) {
                    self.guestNetwork.isEnabled = true
                }
            }
            self.setSections()
        }).disposed(by: disposeBag)
    }
    
    ///Get password for network bands
    /// - Parameters:
    /// - interface: band value
    func getPassword(forInterface interface: String, networkRepository: NetworkRepository) {
        networkRepository.getNetworkPassword(forInterface: interface)
            .subscribe(onNext: {[weak self] (newPassword, error, responseInterface) in
                guard let self = self else { return }
                if let newPassword = newPassword {
                    if interface == NetworkRepository.Bands.Band5G.rawValue || interface == NetworkRepository.Bands.Band2G.rawValue {
                        self.myNetwork.password = newPassword
                    }
                    else if interface == NetworkRepository.Bands.Band5G_Guest.rawValue || interface == NetworkRepository.Bands.Band2G_Guest.rawValue {
                        self.guestNetwork.password = newPassword
                    }                }
                if let error = error {
                    //Display error
                    print(error)
                }
                self.setSections()
            }).disposed(by: self.disposeBag)
    }
    
    func getServiceAppoinment() {
        commonDashboardViewModel.getServiceAppointment()
    }
    
    func addCheckForArrivalTimeAndAddTime() {
        commonDashboardViewModel.checkForArrivalTimeAndAddTimer()
    }
}

/// DashboardViewModel extension with table view sections
extension DashboardViewModel {
    
    /// Sets the section at table
    private func setSections() {
        sections.onNext(getSections())
    }
    
    /// Gets all created section on table
    private func getSections() -> [TableDataSource] {
        var sectionArray = [TableDataSource]()
        if let appointment = self.currentAppointment, appointment.getState() != .cancelled, !appointment.isCloseServiceCompleteCard {
            sectionArray.append(contentsOf: self.commonDashboardViewModel.getSections())
        } else if self.shouldShowSpeeedTest {
            sectionArray.append(createSpeedTestSection())
        }
        
        sectionArray = sectionArray + [
            //TODO: For now hidding notification functionality as will be implementated in future.
            //createNotificationsSection(),
            createConnectedDevicesSection()
        ]
        
        ///Here depending onn shouldShowSpeeedTest value we are adding different cells
        sectionArray = self.shouldShowSpeeedTest ?  sectionArray + [createNetworkSection(), createWifiNetworkSection()] :  sectionArray + [createNetworkCardInfoSection()]
        sectionArray.append(createFeedbackSection())
        return sectionArray
    }
    
    /// Creates a section for speed test
    private func createSpeedTestSection() -> TableDataSource {
        return TableDataSource(
            header: DashboardSpeedTestCell.identifier,
            items: [Item(identifier: DashboardSpeedTestCell.identifier, viewModel: DashboardSpeedTestCellViewModel(networkRepository: networkRepository))]
        )
    }
    
    /// Creates a section for notifications
    private func createNotificationsSection() -> TableDataSource {
        let notifications = notificationRepository.getNotifications()
        let unreadNotifications = notifications.filter { $0.isUnRead }
        let items: [Item]
        if unreadNotifications.isEmpty || hideNotifications {
            items = []
        } else {
            let viewModel = DashboardNotificationsCellViewModel(notifications: unreadNotifications)
            items = [Item(identifier: DashboardNotificationsCell.identifier, viewModel: viewModel)]
            
            viewModel.output.hideViewObservable
                .subscribe(onNext: { [weak self] shouldHide in
                    guard let self = self  else { return }
                    guard shouldHide else { return }
                    self.hideNotifications = true
                    self.setSections()
                }).disposed(by: disposeBag)
            
            viewModel.output.openNotificationDetailObservable
                .bind(to: openNotificationSubject)
                .disposed(by: disposeBag)
        }
        
        return TableDataSource(
            header: DashboardNotificationsCell.identifier,
            items: items
        )
    }
    
    /// Creates a section for connected devices
    private func createConnectedDevicesSection() -> TableDataSource {
        let connectedDevicesViewModel = ConnectedDevicesViewModel(withConnectedDeviceCount: deviceCount)
        return TableDataSource(
            header: ConnectedDevicesCell.identifier,
            items: [Item(identifier: ConnectedDevicesCell.identifier, viewModel: connectedDevicesViewModel)]
        )
    }
    
    /// Creates a section for network
    private func createNetworkSection() -> TableDataSource {
        return TableDataSource(
            header: DashboardNetworkCell.identifier,
            items: [Item(identifier: DashboardNetworkCell.identifier, viewModel: DashboardNetworkCellViewModel())]
        )
    }
    
    private func createFeedbackSection() -> TableDataSource {
        return TableDataSource(
            header: FeedbackCell.identifier,
            items: [Item(identifier: FeedbackCell.identifier, viewModel: FeedBackCellViewModel())]
        )
    }
    
    /// Creates a section for wifi network
    private func createWifiNetworkSection() -> TableDataSource {
        let viewModel = WiFiNetworkCellViewModel(with: myNetwork, and: guestNetwork)
        
        viewModel.output.expandQRCodeObservable.subscribe(onNext: {[weak self] networkInfo in
            guard let self = self else {return}
            self.networkInformationCardtapped(networkInfo)
        }).disposed(by: disposeBag)
        
        viewModel.output.neworkButtonTapObservable.subscribe(onNext: {[weak self] networkInfo in
            guard let self = self else {return}
            var interface = NetworkRepository.Bands.Band2G.rawValue
            if networkInfo.isGuestNetwork {
                interface = NetworkRepository.Bands.Band2G_Guest.rawValue
            }
            if networkInfo.isEnabled {
                self.isEnableWifiNetwork = false
                self.disableNetwork(forInterface: interface)
            } else {
                self.isEnableWifiNetwork = true
                self.enableNetwork(forInterface: interface)
            }
        }).disposed(by: disposeBag)
        
        return TableDataSource(
            header: WiFiNetworkCell.identifier,
            items: [Item(identifier: WiFiNetworkCell.identifier, viewModel: viewModel)]
        )
    }
    
    private func createNetworkCardInfoSection() -> TableDataSource {
        let viewModel = NetworkInfoCardCellViewModel(with: myNetwork, and: guestNetwork)
        
        viewModel.output.expandQRCodeObservable.subscribe(onNext: {[weak self] networkInfo in
            guard let self = self else {return}
            self.networkInformationCardtapped(networkInfo)
        }).disposed(by: disposeBag)
        
        viewModel.output.neworkButtonTapObservable.subscribe(onNext: {[weak self] networkInfo in
            guard let self = self else {return}
            var interface = NetworkRepository.Bands.Band2G.rawValue
            if networkInfo.isGuestNetwork {
                interface = NetworkRepository.Bands.Band2G_Guest.rawValue
            }
            if networkInfo.isEnabled {
                self.isEnableWifiNetwork = false
                self.disableNetwork(forInterface: interface)
            } else {
                self.isEnableWifiNetwork = true
                self.enableNetwork(forInterface: interface)
            }
        }).disposed(by: disposeBag)
        
        return TableDataSource(
            header: NetworkInfoCardCell.identifier,
            items: [Item(identifier: NetworkInfoCardCell.identifier, viewModel: viewModel)]
        )
    }
    
    func networkInformationCardtapped(_ networkInfo: WiFiNetwork) {
        if !myNetwork.name.isEmpty && !myNetwork.password.isEmpty {
            self.openJoinNetworkSubject.onNext(networkInfo)
        } else {
            self.showRetryAlertSubject.onNext(())
        }
    }
    
    func shouldAddAppointmentCard() -> Bool {
        guard let appointment = self.currentAppointment else { return self.shouldShowSpeeedTest }
        return (appointment.getState() != .cancelled && !appointment.isCloseServiceCompleteCard)
    }
    
    func isSpeedTestAvailable() -> Bool {
        return self.shouldShowSpeeedTest
    }
}

extension DashboardViewModel {
    ///Enable network for different network bands
    /// - Parameters:
    /// - interface: band value
    func enableNetwork(forInterface interface: String) {
        
        //Assign band as per main/guest network
        let bands = getBandValues(forInterface: interface)
        var bandValue = bands.firstBand
        var anotherBandValue = bands.secondBand
        
        //Check if the band is already in enabled(bssid) list
        if self.bssidInfo.values.contains(bandValue) {
            bandValue = anotherBandValue
            anotherBandValue = ""
        } else if self.bssidInfo.values.contains(anotherBandValue) {
            anotherBandValue = ""
        }
        
        indicatorViewStatusSubject.onNext(true)
        //Api call for first band
        networkRepository.enableNetwork(forInterface: bandValue)
            .subscribe(onNext: {[weak self] (status, error, responseInterface) in
                guard let self = self else { return }
                if let status = status, status == true {
                    //Check for the response interface network and if next band value is not empty
                    if (responseInterface == bandValue && anotherBandValue != "") {
                        //Call the second API after 1 minutes
                        DispatchQueue.main.asyncAfter(deadline: .now() + (Constants.Common.networkApiDelay)) {
                            self.networkRepository.enableNetwork(forInterface: anotherBandValue)
                                .subscribe(onNext: {[weak self] (status, error, nextInterface) in
                                    guard let self = self else { return }
                                    if let status = status, status == true {
                                        self.checkBandValue(interface: anotherBandValue, status: status, errorMessage: error, isEnabled: true)
                                    } else {
                                        self.indicatorViewStatusSubject.onNext(false)
                                        self.showErrorAlertSubject.onNext((true, bandValue))
                                    }
                                }).disposed(by: self.disposeBag)
                        }
                    }  else {
                        self.checkBandValue(interface: anotherBandValue, status: status, errorMessage: error, isEnabled: true)
                    }
                }
                if error != nil {
                    self.indicatorViewStatusSubject.onNext(false)
                    self.showErrorAlertSubject.onNext((true, bandValue))
                }
            }).disposed(by: self.disposeBag)
    }
    
    ///Disable network for different network bands
    /// - Parameters:
    /// - interface: band value
    func disableNetwork(forInterface interface: String) {
        
        //Assign band as per main/guest network
        let bands = getBandValues(forInterface: interface)
        var bandValue = bands.firstBand
        var anotherBandValue = bands.secondBand
        
        //Check if the band is in enabled(bssid) list
        if !self.bssidInfo.values.contains(bandValue) {
            bandValue = anotherBandValue
            anotherBandValue = ""
        } else if !self.bssidInfo.values.contains(anotherBandValue) {
            anotherBandValue = ""
        }
        
        indicatorViewStatusSubject.onNext(true)

        //show indicator popup
        networkRepository.disableNetwork(forInterface: bandValue)
            .subscribe(onNext: {[weak self] (status, error, responseInterface) in
                guard let self = self else { return }
                
                if let status = status, status == true {
                    //Check for the response interface network and if next band value is not empty
                    if (responseInterface == bandValue && anotherBandValue != "") {
                        //Call the second API after 1 minutes
                        DispatchQueue.main.asyncAfter(deadline: .now() + (Constants.Common.networkApiDelay)) {
                            self.networkRepository.disableNetwork(forInterface: anotherBandValue)
                                .subscribe(onNext: {[weak self] (status, error, nextInterface) in
                                    guard let self = self else { return }
                                    if let status = status, status == true {
                                        self.checkBandValue(interface: anotherBandValue, status: status, errorMessage: error, isEnabled: false)
                                    } else {
                                        self.indicatorViewStatusSubject.onNext(false)
                                        self.showErrorAlertSubject.onNext((false, bandValue))
                                    }
                                }).disposed(by: self.disposeBag)
                        }
                    } else {
                        self.checkBandValue(interface: anotherBandValue, status: status, errorMessage: error, isEnabled: false)
                    }
                }
                if error != nil {
                    self.indicatorViewStatusSubject.onNext(false)
                    self.showErrorAlertSubject.onNext((false, bandValue))
                }
            }).disposed(by: self.disposeBag)
    }
    
    /// Check band value in bssid list
    /// - Parameters:
    /// - interface: band value
    /// - status: status response
    /// - errorMessage: check for error message
    func checkBandValue(interface: String?, status: Bool?, errorMessage: String?, isEnabled: Bool) {
        //Check for the wifi line info API response after 1 minutes, to check band value in bssid list
        DispatchQueue.main.asyncAfter(deadline: .now() + (Constants.Common.networkApiDelay)) {
            self.checkBssidValues(forInterface: interface ?? "").subscribe(onNext: {[weak self] (isBandPresent) in
                guard let self = self else { return }
                if isBandPresent {
                    self.indicatorViewStatusSubject.onNext(false)
                } else {
                    self.showErrorAlertSubject.onNext((isForEnable: isEnabled, interface: interface ?? ""))
                }
            }).disposed(by: self.disposeBag)
        }
    }
    
    /// checkBssidValues from wifi-line info API response
    /// - Parameters:
    /// - interface: band value
    ///- returns: A Boolean value indicating whether the band is added/removed from bssid list or not
    func checkBssidValues(forInterface interface: String) -> Observable<Bool> {
        let isBandPresent = PublishSubject<Bool>()
        networkRepository.bssidMapSubject.subscribe(onNext: {[weak self] (bssidInfo) in
            guard let self = self else { return }
            self.bssidInfo = bssidInfo
            if bssidInfo.count == 0 {
                isBandPresent.onNext(false)
            } else if (bssidInfo.values.contains(NetworkRepository.Bands.Band2G.rawValue)) {
                isBandPresent.onNext(true)
            }
            isBandPresent.onCompleted()
        }).disposed(by: disposeBag)
        return isBandPresent.asObservable()
    }

    /// getBandValues
    /// - Parameters:
    /// - forInterface: band value
    ///- returns: both the Bands main/guest
    func getBandValues(forInterface interface: String) -> (firstBand: String, secondBand: String){
        var bandValue = NetworkRepository.Bands.Band2G.rawValue
        var anotherBandValue = NetworkRepository.Bands.Band5G.rawValue
        if (interface == NetworkRepository.Bands.Band2G_Guest.rawValue || interface == NetworkRepository.Bands.Band5G_Guest.rawValue) {
            bandValue = NetworkRepository.Bands.Band2G_Guest.rawValue
            anotherBandValue = NetworkRepository.Bands.Band5G_Guest.rawValue
        }
        return (bandValue, anotherBandValue)
    }
}
