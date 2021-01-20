//
//  DevicesViewModel.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/2/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import DPProtocols
/*
  DevicesViewModel handles device list and its details
**/
class DevicesViewModel {
    
    /// SectionType for perticular section here two sections are created
    enum SectionType: Int {
        case connectedDevices = 0
        case removedDevices
    }
    
    /// Input Structure
    struct Input {
        let cellSelectionObserver: AnyObserver<IndexPath>
        let restoreDeviceObserver: AnyObserver<DeviceInfo>
    }
    
    /// Output Structure
    struct Output {
        let viewComplete: Observable<DeviceCoordinator.Event>
        let viewStatusObservable: Observable<ViewStatus>
        let restoreDeviceAlertObservable: Observable<DeviceInfo>
    }
    
    /// Input & Output Structure variable
    let input: Input
    let output: Output
    
    // MARK: - Subject
    /// Subject to handle view status
    let viewStatusSubject = PublishSubject<ViewStatus>()

    /// Subject to handle cell selection on table
    private let cellSelectionSubject = PublishSubject<IndexPath>()
    
    /// Subject to move to  Device Management screen
    private let goToDeviceManagementSubject = PublishSubject<(DeviceInfo, [String], Bool)>()
    
    /// Subject to show confirmation alert for restore removeed device
    private let restoreDeviceAlertSubject = PublishSubject<DeviceInfo>()
    
    /// Subject to handle restore removed device
    private let restoreDeviceSubject = PublishSubject<DeviceInfo>()
    
    /// Subject to handle network information
    let networkInfoSubject = PublishSubject<DeviceInfo>()
    
    /// Subject to handle pull to refresh functionality
    let endRefreshing = PublishSubject<Bool>()

    // MARK: - Variables
    var sections = BehaviorSubject(value: [TableDataSource]())
    var repository: DeviceRepository
    var networkRepository: NetworkRepository
    var deviceList: DeviceList?
    var connectedDevices: [DeviceInfo]?
    var removedDevices: [DeviceInfo]?
    var showConnectedDevices: Bool = true
    var timer: Timer?
    var isModemOnline: Bool = false
    let disposeBag = DisposeBag()

    /// Initializes a new instance of Devices ViewModel
    /// - Parameter
    ///     - repository : Device repository for calling device API
    ///     - networkRepository : Network repository for calling modem status is online or not
    init(withRepository repository: DeviceRepository, networkRepository: NetworkRepository) {
        self.repository = repository
        self.networkRepository = networkRepository
        
        input = Input(cellSelectionObserver: cellSelectionSubject.asObserver(),
                      restoreDeviceObserver: restoreDeviceSubject.asObserver()
        )
        
        /// Handled navigatin from device to Device Management screen
        let goToDeviceManagementObservable = goToDeviceManagementSubject.asObservable().map { (deviceInfo, deviceNameArray, isModemOnline) in
            return DeviceCoordinator.Event.openDeviceManagement(deviceInfo, deviceNameArray, isModemOnline)
        }
        
        let viewCompleteObservable = Observable.merge(goToDeviceManagementObservable)
        
        output = Output(viewComplete: viewCompleteObservable,
                        viewStatusObservable: viewStatusSubject.asObservable(),
                        restoreDeviceAlertObservable: restoreDeviceAlertSubject.asObservable()
        )
        subscribeObservers()
        
        ///Called get device list API
        self.getConnectedDevices()
        
        ///Subscribe cellSelectionSubject to handle cell selection
        cellSelectionSubject.subscribe(onNext: {[weak self] indexPath in
            self?.handleCellSelection(for: indexPath)
        }).disposed(by: disposeBag)
        
        ///Subscribe restoreDeviceSubject  to handle restore device
        restoreDeviceSubject.subscribe(onNext: {[weak self] deviceInfo in
            self?.restoreDevice(deviceInfo)
        }).disposed(by: disposeBag)
        
        ///Subscribe networkInfoSubject  to get network information
        networkInfoSubject.subscribe(onNext: { (device) in
            self.getDeviceNetworkInfo(device)
        }).disposed(by: disposeBag)
    }
}

/// DevicesViewModel extension 
extension DevicesViewModel {
    
    func setSections() {
        sections.onNext(getSections())
    }
    
    func getSections() -> [TableDataSource] {
        //TODO: Currently we are hidding this functionality will remove comment in future
//        guard let deviceList = deviceList?.deviceList else { return [TableDataSource(items: [Item]())] }
//        let removedDevices = deviceList.filter { $0.blocked == true }
//        if removedDevices.count > 0 {
//            return [connectedDeviceSectionData(),
//                    removeDeviceSectionData()]
//        } else {
//            return [connectedDeviceSectionData()]
//        }
        return [connectedDeviceSectionData()]

    }
    
    ///Creating DataSource for connected device section
    /// - returns:
    ///   - TableDataSource : DataSource which contain data for section
    private func connectedDeviceSectionData() -> TableDataSource {
        var items = [Item]()
        guard let deviceList = deviceList?.deviceList else { return TableDataSource(items: [Item]()) }
        let connectedDevices = deviceList.filter { $0.blocked == false }
        self.connectedDevices = connectedDevices
        if showConnectedDevices {
            items = connectedDevices.compactMap { deviceInfo -> Item in
                
                let viewModel = DeviceDetailTableCellViewModel(withDevice: deviceInfo,
                                                               isOnline: self.isModemOnline,
                                                               repository: self.repository)                
                /// Suscribe retryNetworkInfoObservable to showing reload icon on error
                viewModel.output.retryNetworkInfoObservable.subscribe(onNext: { (deviceInfo) in
                    viewModel.showLoading.accept(true)
                    self.getDeviceNetworkInfo(deviceInfo)
                }).disposed(by: disposeBag)
                
                /// Suscribe pauseResumeObservable to handle pause and resume tap
                viewModel.output.pauseResumeObservable.subscribe(onNext: { (deviceInfo) in
                    if viewModel.isOnline {
                        if !(deviceInfo.networStatus == .paused) {
                            AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.pauseConnectionDeviceScreen)
                        } else {
                            AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.unpauseConnectionDeviceScreen)
                        }
                        viewModel.showLoading.accept(true)
                        self.pauseResumeDevice(deviceInfo, !(deviceInfo.networStatus == .paused))
                    }
                }).disposed(by: disposeBag)
                
                return Item.init(identifier: DeviceDetailTableViewCell.identifier,
                                 viewModel: viewModel,
                                 object: deviceInfo)
            }
        }
        return TableDataSource(header: "",
                               items: items)
    }
    
    ///Creating DataSource for remove device section
    /// - returns:
    ///   - TableDataSource : DataSource which contain data for section
    private func removeDeviceSectionData() -> TableDataSource {
        guard let deviceList = deviceList?.deviceList else { return TableDataSource(items: [Item]()) }
        let removedDevices = deviceList.filter { $0.blocked == true }
        self.removedDevices = removedDevices
        let items = removedDevices.compactMap { deviceInfo -> Item in
            return Item.init(identifier: DeviceDetailTableViewCell.identifier,
                             viewModel: DeviceDetailTableCellViewModel(withDevice: deviceInfo,
                                                                       isOnline: self.isModemOnline,
                                                                       repository: self.repository),
                             object: deviceInfo)
        }
        return TableDataSource(header: "",
                               items: items)
    }
    
    func handleCellSelection(for indexpath: IndexPath) {
        let section = SectionType.init(rawValue: indexpath.section)
        switch section {
        case .connectedDevices:
            guard let selectedDevice = connectedDevices?[indexpath.row] else { return }
            AnalyticsEvents.trackListItemTappedEvent(with: AnalyticsConstants.EventListItemName.connectedDevices)
            ///Navigating to device management screen with device info and devices nickname list
            goToDeviceManagementSubject.onNext((selectedDevice, deviceList?.deviceList?.map{ ($0.nickName ?? "") } ?? [String](), isModemOnline))
        case .removedDevices:
            guard let selectedDevice = removedDevices?[indexpath.row] else { return }
            AnalyticsEvents.trackListItemTappedEvent(with: AnalyticsConstants.EventListItemName.removedDevices)
            restoreDeviceAlertSubject.onNext(selectedDevice)
        default:
            break
        }
    }
}
