//
//  NetworkViewModel.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 6/25/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class NetworkViewModel {
    struct Input {
        let doneObserver: AnyObserver<Void>
    }
    
    struct Output {
        let viewComplete: Observable<DashboardCoordinator.Event>
    }
    
    let input: Input
    let output: Output
    let sections = BehaviorSubject(value: [TableDataSource]())
    let networkRepository: NetworkRepository
    let disposeBag = DisposeBag()
    
    private let doneSubject = PublishSubject<Void>()
    private let dismissSubject = PublishSubject<Void>()

    let enabledSubject = BehaviorSubject<(String, Bool)>(value: ("", false))//Pass interface string(band2g/band5g) is changed to enable true/false
    let disabledSubject = BehaviorSubject<(String, Bool)>(value: ("", false))//Pass interface string(band2g/band5g) is changed to disable true/false
    let passwordUpdatedSubject = BehaviorSubject<(String, Bool)>(value: ("", false))//Pass interface string(band2g/band5g) is password value changed
    let ssidUpdatedSubject = BehaviorSubject<(String, Bool)>(value: ("", false))//Pass interface string(band2g/band5g) is ssid value changed
    
    let enabledGuestSubject = BehaviorSubject<(String, Bool)>(value: ("", false))//Pass interface string(band2g/band5g/guest) is changed to enable true/false
    let disabledGuestSubject = BehaviorSubject<(String, Bool)>(value: ("", false))//Pass interface string(band2g/band5g/guest) is changed to disable true/false
    let passwordUpdatedGuestSubject = BehaviorSubject<(String, Bool)>(value: ("", false))//Pass interface string(band2g/band5g/guest) is password value changed
    let ssidUpdatedGuestSubject = BehaviorSubject<(String, Bool)>(value: ("", false))//Pass interface string(band2g/band5g/guest) is ssid value changed
    
    init(networkRepository: NetworkRepository) {
        self.networkRepository = networkRepository
        input = Input(doneObserver: doneSubject.asObserver())
        
        let dismissEventObservable = dismissSubject.asObservable().map { _ -> DashboardCoordinator.Event in
            return DashboardCoordinator.Event.dismissNetwork
        }
        
        output = Output(viewComplete: dismissEventObservable)
        setSections()
        
        doneSubject.subscribe(onNext: { [weak self] _ in
            do {
                guard let self = self else { return }
                //Main
                let passwordValueUpdated = try self.passwordUpdatedSubject.value()
                let ssidValueUpdated = try self.ssidUpdatedSubject.value()
                let networkEnableValue = try self.enabledSubject.value()
                let networkDisableValue = try self.disabledSubject.value()
                
                //Guest
                let passwordValueGuestUpdated = try self.passwordUpdatedGuestSubject.value()
                let ssidValueGuestUpdated = try self.ssidUpdatedGuestSubject.value()
                let networkEnableGuestValue = try self.enabledGuestSubject.value()
                let networkDisableGuestValue = try self.disabledGuestSubject.value()
                
                //TODO: to be updated once UI is integrated
                if passwordValueUpdated.1 {
                    self.updatePassword(forInterface: passwordValueUpdated.0, newPassword: "send new password value")
                }
                if ssidValueUpdated.1 {
                    self.updateSSID(forInterface: ssidValueUpdated.0, newSSID: "send new ssid value")
                }
                if networkEnableValue.1 {
                    self.enableNetwork(forInterface: networkEnableValue.0)
                }
                if networkDisableValue.1 {
                    self.disableNetwork(forInterface: networkDisableValue.0)
                }
                //TODO: to be updated once UI is integrated
                if passwordValueGuestUpdated.1 {
                    self.updatePassword(forInterface: passwordValueGuestUpdated.0, newPassword: "send new password value")
                }
                if ssidValueGuestUpdated.1 {
                    self.updateSSID(forInterface: ssidValueGuestUpdated.0, newSSID: "send new ssid value")
                }
                if networkEnableGuestValue.1 {
                    self.enableNetwork(forInterface: networkEnableGuestValue.0)
                }
                if networkDisableGuestValue.1 {
                    self.disableNetwork(forInterface: networkDisableGuestValue.0)
                }
            } catch {}
        }).disposed(by: disposeBag)
    }
}

/// Table view sections
extension NetworkViewModel {
    
    private func setSections() {
        sections.onNext(getSections())
    }
    
    private func getSections() -> [TableDataSource] {
        return [
            createOnlineStatusSection()
        ]
    }
    
    private func createOnlineStatusSection() -> TableDataSource {
        return TableDataSource(
            header: OnlineStatusCell.identifier,
            items: [
                Item(identifier: OnlineStatusCell.identifier, viewModel: OnlineStatusCellViewModel(networkRepository: networkRepository, type: .internet)),
                Item(identifier: OnlineStatusCell.identifier, viewModel: OnlineStatusCellViewModel(networkRepository: networkRepository, type: .modem))
            ]
        )
    }
}
