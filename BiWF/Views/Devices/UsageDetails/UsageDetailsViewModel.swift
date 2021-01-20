//
//  UsageDetailsViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 17/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
/*
  UsageDetailsViewModel handles device details events
**/
class UsageDetailsViewModel {
    
    /// Input Structure
    struct Input {
        let doneTapObserver: AnyObserver<Void>
        let pauseResumeObserver: AnyObserver<Void>
        let removeDeviceObserver: AnyObserver<Void>
        let deviceNameFieldObserver: AnyObserver<String>
    }
    
    /// Output Structure
    struct Output {
        let usageTodayDriver: Driver<String>
        let removeDeviceDriver: Driver<String>
        let todayUsageDetailsObservable: Observable<UsageDetailViewModel>
        let lastTwoWeeksUsageDriver: Driver<String>
        let lastTwoWeeksUsageDetailsObservable: Observable<UsageDetailViewModel>
        let pauseResumeTitleObservable: Observable<String>
        let pauseResumeImageObservable: Observable<UIImage>
        let pauseResumeBackgroundStyleObservable: Observable<ButtonStyle>
        let tapToPauseObservable: Observable<String>
        let enablePauseResumeDriver: Driver<Bool>
        let nameFieldTextDriver: Driver<String>
        let countLimitDriver: Driver<String>
        let viewComplete: Observable<DeviceCoordinator.Event>
        let viewStatusObservable: Observable<ViewStatus>
        let viewValidationPopupObservable: Observable<Void>
    }
    
    // MARK: - Subject
    private let removeDeviceSubject = PublishSubject<Void>()
    private let doneTapSubject = PublishSubject<Void>()
    private let pauseResumeSubject = PublishSubject<Void>()
    private let showValidationPopupSubject = PublishSubject<Void>()
    let doneSuccessTapSubject = PublishSubject<Void>()
    let viewStatusSubject = PublishSubject<ViewStatus>()
    let deviceNameSubject = BehaviorSubject<String>(value: "")
    let todayUsageDetailViewModelSubject = PublishSubject<UsageDetailViewModel>()
    let lastTwoWeeksUsageDetailViewModel =  PublishSubject<UsageDetailViewModel>()
    let enablePauseResumeSubject = BehaviorSubject<Bool>(value: false)
    let showLoading = BehaviorRelay<Bool>(value: false)
    let disposeBag = DisposeBag()

    /// Input & Output Structure variable
    let input: Input
    let output: Output
    private var signalStrengthImageSubject = PublishSubject<UIImage>()
    private var titleSubject = PublishSubject<String>()
    private var subTitleSubject = PublishSubject<String>()
    private var buttonBackgroundStyleSubject = PublishSubject<ButtonStyle>()
    
    // MARK: - Variables
    var deviceInfo: DeviceInfo
    let repository: DeviceRepository
    var networkRepository: NetworkRepository
    var todayUsage: UsageDetailsList? = nil
    var lastTwoWeeksUsage: UsageDetailsList? = nil
    var isModemOnline: Bool = false
    var devicesNameArray = [String]()
    
    /// Initializes a new instance of UsageDetails ViewModel
    /// - Parameter
    ///     - deviceInfo : deviceInfo of selected device
    ///     - deviceRepository : Device repository for calling device API
    ///     - networkRepository : Network repository for calling modem status is online or not
    init(with deviceInfo: DeviceInfo, deviceRepository: DeviceRepository, networkRepository: NetworkRepository, isModemOnline: Bool) {
        self.deviceInfo = deviceInfo
        self.repository = deviceRepository
        self.networkRepository = networkRepository
        self.isModemOnline = isModemOnline
        input = Input(doneTapObserver: doneTapSubject.asObserver(),
                      pauseResumeObserver: pauseResumeSubject.asObserver(),
                      removeDeviceObserver: removeDeviceSubject.asObserver(),
                      deviceNameFieldObserver: deviceNameSubject.asObserver())
        
        ///Dismiss when click on Done
        let doneTapObservable = doneSuccessTapSubject.asObservable().map { _ in
            return DeviceCoordinator.Event.dismiss
        }
        
        output = Output(usageTodayDriver: .just(Constants.UsageDetails.usageToday),
                        removeDeviceDriver: .just(Constants.UsageDetails.removeDevice),
                        todayUsageDetailsObservable: todayUsageDetailViewModelSubject.asObservable(),
                        lastTwoWeeksUsageDriver: .just("\(Constants.UsageDetails.usageLastTwoWeeks)"),
                        lastTwoWeeksUsageDetailsObservable: lastTwoWeeksUsageDetailViewModel.asObservable(),
                        pauseResumeTitleObservable: titleSubject.asObservable(),
                        pauseResumeImageObservable: signalStrengthImageSubject.asObservable(),
                        pauseResumeBackgroundStyleObservable: buttonBackgroundStyleSubject.asObservable(),
                        tapToPauseObservable: subTitleSubject.asObservable(),
                        enablePauseResumeDriver: enablePauseResumeSubject.asDriver(onErrorJustReturn: true),
                        nameFieldTextDriver: .just((deviceInfo.nickName ?? deviceInfo.hostname) ?? ""),
                        countLimitDriver: .just(Constants.UsageDetails.max15CharacterLimit),
                        viewComplete: doneTapObservable,
                        viewStatusObservable: viewStatusSubject.asObservable(),
                        viewValidationPopupObservable: showValidationPopupSubject.asObservable())
        ///Handle pause resume tap
        pauseResumeSubject.subscribe(onNext: {[weak self]  _ in
            guard let self = self, self.isModemOnline else { return }
            if deviceInfo.networStatus == .error {
                self.getNetworkInfo()
            } else {
                let isEnabled = self.deviceInfo.networStatus == .connected
                let eventName = isEnabled ? AnalyticsConstants.EventButtonTitle.pauseConnectionDeviceDetailScreen : AnalyticsConstants.EventButtonTitle.unpauseConnectionDeviceDetailScreen
                AnalyticsEvents.trackButtonTapEvent(with: eventName)
                self.pauseResumeDevice(deviceInfo, !isEnabled)
            }
        }).disposed(by: disposeBag)
        
        removeDeviceSubject.subscribe(onNext: {[weak self]  _ in
            guard let self = self else { return }
            self.blockDevice(self.deviceInfo)
        }).disposed(by: disposeBag)
        
        ///Suscribe doneTapSubject update nick name
        doneTapSubject.subscribe(onNext: {[weak self]  _ in
            guard let self = self else { return }
            let loading = ViewStatus.loading(loadingText: Constants.Common.loading)
            do {
                let updatedDeviceName = try self.deviceNameSubject.value()
                var deviceName = (updatedDeviceName == "" || updatedDeviceName == self.deviceInfo.nickName
                    ? deviceInfo.nickName
                    : deviceInfo.getUniqueNameFrom(name: updatedDeviceName, devicesNameArray: self.devicesNameArray)) ?? ""
                deviceName = deviceName.trimmingCharacters(in: .whitespacesAndNewlines)
                if updatedDeviceName.count == 0 {
                    self.doneSuccessTapSubject.onNext(())
                } else if deviceName.containsSpecialCharacter {
                    self.showValidationPopupSubject.onNext(())
                } else {
                    self.viewStatusSubject.onNext(loading)
                    self.repository.updateDeviceName(deviceName, deviceInfo).subscribe(onNext: {[weak self] (response, error) in
                        guard let self = self else {return}
                        self.viewStatusSubject.onNext(ViewStatus.loaded)
                        if response ?? false {
                            self.doneSuccessTapSubject.onNext(())
                        } else {
                            DispatchQueue.main.async {
                                self.showAlert(withMessage: error ?? "", deviceInfo: deviceInfo)
                            }
                        }
                    }).disposed(by: self.disposeBag)
                }
            } catch{}
        }).disposed(by: disposeBag)
        
        // Check if modem is online
        networkRepository.getNetworkStatus()
        networkRepository.isModemOnlineSubject.asObservable().subscribe(onNext: {[weak self] isOnline in
            guard let self = self else { return }
            self.isModemOnline = isOnline
            self.deviceInfo.networStatus = isOnline ? self.deviceInfo.networStatus : .offline
            DispatchQueue.main.async {
                self.setUpPauseResumeButton()
            }
        }).disposed(by: disposeBag)
        
        getUsageDetails()
    }
    
    func setUpPauseResumeButton() {
        var signalStrengthImage = deviceInfo.strengthStatusImage(isOnline: isModemOnline,  withClearBackground: true)
        var buttonBackgroundStyle = ButtonStyle.enabledWithLightPurpleBackground
        var title = ""
        var subTitle = ""
        
        switch deviceInfo.networStatus {
        case .error:
            signalStrengthImage = UIImage(named: Constants.LoaderErrorView.reloadImageName) ?? UIImage()
            buttonBackgroundStyle = .enabledWithLightPurpleBackground
            subTitle = Constants.UsageDetails.tapToReload
            
        case .offline:
            title = Constants.UsageDetails.notConnected
            subTitle = Constants.UsageDetails.tapToConnectDeviceToNetwork
            buttonBackgroundStyle = .offline

        case .connected:
            title = Constants.UsageDetails.deviceConnected
            subTitle = Constants.UsageDetails.tapToPause
            buttonBackgroundStyle = .enabledWithLightPurpleBackground
            
        case .paused:
            title = Constants.UsageDetails.connectionPaused
            subTitle = Constants.UsageDetails.tapToResume
            buttonBackgroundStyle = .enabledWithGrayBackground
            
        default:
            break
        }
        
        signalStrengthImageSubject.onNext(signalStrengthImage)
        titleSubject.onNext(title)
        subTitleSubject.onNext(subTitle)
        buttonBackgroundStyleSubject.onNext(buttonBackgroundStyle)
        
    }
}

/// UsageDetailsViewModel extension
extension UsageDetailsViewModel {
    func updateUsageDetails() {
        if let todayUsage = self.todayUsage, let thisMonthUsage = self.lastTwoWeeksUsage {
            todayUsageDetailViewModelSubject.onNext(UsageDetailViewModel.init(with: todayUsage, isPaused: deviceInfo.networStatus == .paused))
            lastTwoWeeksUsageDetailViewModel.onNext(UsageDetailViewModel.init(with: thisMonthUsage, isPaused: deviceInfo.networStatus == .paused))
        }
    }
}
