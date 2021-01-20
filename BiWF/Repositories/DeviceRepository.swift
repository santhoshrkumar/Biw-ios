//
//  DeviceRepository.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 19/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import DPProtocols
/**
 Assists in the implemetation of the DeviceRepository, enabling an abstraction of data
 */
class DeviceRepository: Repository {

    /// PublishSubject notification is broadcasted to all subscribed observers when responses come as Bool/Objects/ error
    let deviceListSubject = PublishSubject<DeviceList>()
    let deviceListWithMacDeviceIdSubject = PublishSubject<DeviceList>()
    let networkInfoSubject = PublishSubject<DeviceInfo>()
    let macDeviceInfoListSubject = PublishSubject<DeviceList>()
    let usageDetailsSubject = PublishSubject<UsageDetailsList>()
    let errorMessageSubject = PublishSubject<String>()
    let errorDeviceListWithMacDeviceIdSubject = PublishSubject<String>()
    let errorMacDeviceInfoListSubject = PublishSubject<String>()
    let errorNetworkInfoSubject = PublishSubject<(DeviceInfo, String)>()
    let deviceListCountSubject = PublishSubject<Int>()
    /// Contained disposables disposal
    private let disposeBag = DisposeBag()
    /// Holds the deviceServiceManager with a strong reference
    private let deviceServiceManager: DeviceServiceManager

    /// Initialise the deviceServiceManager
    /// - Parameters:
    ///   - deviceServiceManager: shared object of deviceServiceManager
    init(deviceServiceManager: DeviceServiceManager = NetworkDeviceServiceManager.shared) {
        self.deviceServiceManager = deviceServiceManager
    }

    /// Call method of device service manager which gives device list connect with the modem
    func getDeviceList() {
        deviceServiceManager.getDeviceList().subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let deviceList = try JSONDecoder().decode(DeviceList.self, from: data)
                    self.deviceListSubject.onNext(deviceList)

                    let connectedDevices = deviceList.deviceList?.filter { $0.blocked == false }
                    self.deviceListCountSubject.onNext(connectedDevices?.count ?? 0)

                } catch {
                    self.errorMessageSubject.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            case .failure(let error):
                self.errorMessageSubject.onNext(ServiceManager.getErrorMessage(forError: error))
            }
        }).disposed(by: disposeBag)
    }

    /// Call method of device service manager to get usage detail of the selected device
    /// - Parameters:
    ///   - station: station ID for selected device
    ///   - startDate: started data usage date
    ///   - endDate: end data usage date
    func getUsageDetails(for station: String, from startDate: String, to endDate: String) {
        deviceServiceManager.getUsageDetails(for: station, from: startDate, to: endDate).subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let usageDetailsResponse = try JSONDecoder().decode(UsageDetailsResponse.self, from: data)

                    self.usageDetailsSubject.onNext(usageDetailsResponse.data)
                } catch {
                    self.errorMessageSubject.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            case .failure(let error):
                self.errorMessageSubject.onNext(ServiceManager.getErrorMessage(forError: error))
            }
        }).disposed(by: disposeBag)
    }

    /// Call method of device service manager to block specific device
    /// - Parameters:
    ///   - stationMac: station mac ID of the device to be blocked
    /// - returns:
    ///   - status: status update success API response
    ///   - error: if any error come in API response
    func blockDevice(_ stationMac: String) -> Observable<(status: Bool?, error: String?)> {
        let blockDeviceResult = PublishSubject<(status: Bool?, error: String?)>()

        deviceServiceManager.blockDevice(stationMac).subscribe(onNext: { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(BlockUnblockDeviceResponse.self, from: data)
                    blockDeviceResult.onNext(((response.code == HTTPStatusCode.Assia.success.rawValue), nil))
                    blockDeviceResult.onCompleted()
                } catch {
                    blockDeviceResult.onNext((nil, ServiceManager.getErrorMessage(forError: error)))
                    blockDeviceResult.onCompleted()
                }
            case .failure(let error):
                blockDeviceResult.onNext((nil, ServiceManager.getErrorMessage(forError: error)))
                blockDeviceResult.onCompleted()
            }
        }).disposed(by: disposeBag)

        return blockDeviceResult.asObservable()
    }

    /// Call method of device service manager to unblock specific device
    /// - Parameters:
    ///   - stationMac: station mac ID of the device to be blocked
    /// - returns:
    ///   - status: status update success API response
    ///   - error: if any error come in API response
    func unblockDevice(_ stationMac: String) -> Observable<(status: Bool?, error: String?)> {
        let unblockDeviceResult = PublishSubject<(status: Bool?, error: String?)>()

        deviceServiceManager.unblockDevice(stationMac).subscribe(onNext: { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(BlockUnblockDeviceResponse.self, from: data)
                    unblockDeviceResult.onNext(((response.code == HTTPStatusCode.Assia.success.rawValue), nil))
                    unblockDeviceResult.onCompleted()
                } catch {
                    unblockDeviceResult.onNext((nil, ServiceManager.getErrorMessage(forError: error)))
                    unblockDeviceResult.onCompleted()
                }
            case .failure(let error):
                unblockDeviceResult.onNext((nil, ServiceManager.getErrorMessage(forError: error)))
                unblockDeviceResult.onCompleted()
            }
        }).disposed(by: disposeBag)

        return unblockDeviceResult.asObservable()
    }

    /// Call method of device service manager to get mac device list
    /// - Parameters:
    ///   - deviceList: deviceList of connected device come from device list API
    func getDeviceListWithMacDevicesId(_ deviceList: DeviceList) {
        let serialNumber = ServiceManager.shared.assiaID
        let macAddressList = deviceList.getMacAddressList()
        //Calling mac address mapping API to get device id
        deviceServiceManager.getMacDeviceIdList(serialNumber , macAddressList ?? [String]()).subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(PauseResumeResponse.self, from: data)
                    if response.code == "\(McAfeeStatusCode.ok.rawValue)" {
                        let deviceListWithMacDeviceId = deviceList.getDeviceListWithMacDeviceId(response.macDeviceList ?? [MacDeviceList]())
                        self.deviceListWithMacDeviceIdSubject.onNext(deviceListWithMacDeviceId)
                    } else {
                        self.errorMessageSubject.onNext(ServiceManager.getMcAfeeError(forStatusCode: Int(response.code) ?? McAfeeStatusCode.unhandled.rawValue))
                    }

                } catch {
                    self.errorMessageSubject.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            case .failure(let error):
                self.errorMessageSubject.onNext(ServiceManager.getErrorMessage(forError: error))
            }
        }).disposed(by: self.disposeBag)
    }

    /// Call method of device service manager to get network information
    /// - Parameters:
    ///   - deviceInfo: deviceInfo of selected device
    func getNetworkInfo(_ deviceInfo: DeviceInfo)  {
        deviceServiceManager.getNetworkInfo(ServiceManager.shared.assiaID, deviceInfo.macDeviceId ?? "")
            .subscribe(onNext: { (result) in
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(PauseResumeResponse.self, from: data)
                        if response.code == "\(McAfeeStatusCode.ok.rawValue)" {
                            var device = deviceInfo
                            device.networStatus = (response.isPaused ?? false) ? .paused : .connected
                            self.networkInfoSubject.onNext(device)
                        } else {
                            self.errorNetworkInfoSubject.onNext((deviceInfo, ServiceManager.getMcAfeeError(forStatusCode: Int(response.code) ?? McAfeeStatusCode.unhandled.rawValue)))
                        }
                    } catch {
                        self.errorNetworkInfoSubject.onNext((deviceInfo, ServiceManager.getErrorMessage(forError: error)))
                    }
                case .failure(let error):
                    self.errorNetworkInfoSubject.onNext((deviceInfo, ServiceManager.getErrorMessage(forError: error)))
                }
            }).disposed(by: disposeBag)
    }

    /// Call method of device service manager to pause device
    /// - Parameters:
    ///   - serialNumber: serial number of device to be pasued
    ///   - deviceId: deviceId of device to be pasued
    ///   - shouldPause: flag bool value define to pause/resume
    /// - returns:
    ///   - status: PauseResumeResponse API response
    ///   - error: if any error come in API response
    func pauseResumeDevice(_ serialNumber: String, _ deviceId: String, _ shouldPause: Bool) -> Observable<(status: PauseResumeResponse?, error: String?)> {
        let pauseResumeResult = PublishSubject<(status: PauseResumeResponse?, error: String?)>()
        deviceServiceManager.pauseResumeDevice(serialNumber, deviceId, shouldPause).subscribe(onNext: { (result) in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(PauseResumeResponse.self, from: data)
                    if response.code == "\(McAfeeStatusCode.ok.rawValue)" {
                        pauseResumeResult.onNext((response, nil))
                    } else {
                        pauseResumeResult.onNext((nil, ServiceManager.getMcAfeeError(forStatusCode: Int(response.code) ?? McAfeeStatusCode.unhandled.rawValue)))
                    }
                    pauseResumeResult.onCompleted()
                } catch {
                    pauseResumeResult.onNext((nil, ServiceManager.getErrorMessage(forError: error)))
                    pauseResumeResult.onCompleted()
                }
            case .failure(let error):
                pauseResumeResult.onNext((nil, ServiceManager.getErrorMessage(forError: error)))
                pauseResumeResult.onCompleted()
            }
        }).disposed(by: disposeBag)
        return pauseResumeResult.asObservable()
    }

    /// Call method of device service manager to pause device
    /// - Parameters:
    ///   - serialNumber: serial number of device to be pasued
    ///   - deviceId: deviceId of device to be pasued
    ///   - shouldPause: flag bool value define to pause/resume
    /// - returns:
    ///   - status: PauseResumeResponse API response
    ///   - error: if any error come in API response
    func updateDeviceName(_ updatedName: String, _ deviceInfo: DeviceInfo) -> Observable<(status: Bool?, error: String?)> {
            let updateDeviceNameResult = PublishSubject<(status: Bool?, error: String?)>()
            deviceServiceManager.updateDeviceName(updatedName: updatedName, deviceInfo: deviceInfo).subscribe(onNext: { (result) in
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(PauseResumeResponse.self, from: data)
                        if response.code == "\(McAfeeStatusCode.ok.rawValue)" {
                            updateDeviceNameResult.onNext((true, nil))
                        } else {
                            updateDeviceNameResult.onNext((false, ServiceManager.getMcAfeeError(forStatusCode: Int(response.code) ?? McAfeeStatusCode.unhandled.rawValue)))
                        }
                        updateDeviceNameResult.onCompleted()
                    } catch {
                        updateDeviceNameResult.onNext((false, ServiceManager.getErrorMessage(forError: error)))
                        updateDeviceNameResult.onCompleted()
                    }
                case .failure(let error):
                    updateDeviceNameResult.onNext((nil, ServiceManager.getErrorMessage(forError: error)))
                    updateDeviceNameResult.onCompleted()
                }
            }).disposed(by: disposeBag)
            return updateDeviceNameResult.asObservable()
        }

    /// Call method of device service manager to get mac device info
    /// - Parameters:
    ///   - deviceList: deviceList of connected device come from device list API
    func getMacDeviceInfoList(_ deviceList: DeviceList) {
        let serialNumber = ServiceManager.shared.assiaID
        deviceServiceManager.getMacDeviceInfoList(serialNumber).subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(PauseResumeResponse.self, from: data)
                    if response.code == "\(McAfeeStatusCode.ok.rawValue)" {
                        let deviceListWithName = deviceList.getMacDeviceWithNameInfoList(response.deviceInfoList ?? [MacDeviceInfo]())
                        self.macDeviceInfoListSubject.onNext(deviceListWithName)
                    } else {
                        self.errorMacDeviceInfoListSubject.onNext(ServiceManager.getMcAfeeError(forStatusCode: Int(response.code) ?? McAfeeStatusCode.unhandled.rawValue))
                    }
                } catch {
                    self.errorMacDeviceInfoListSubject.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            case .failure(let error):
                self.errorMacDeviceInfoListSubject.onNext(ServiceManager.getErrorMessage(forError: error))
            }
        }).disposed(by: self.disposeBag)
    }

}
