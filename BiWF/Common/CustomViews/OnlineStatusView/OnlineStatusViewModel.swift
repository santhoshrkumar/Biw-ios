//
//  OnlineStatusViewModel.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 6/24/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
/*
OnlineStatusViewModel to handle online status information
*/
struct OnlineStatusViewModel {

    /// To select perticular StatusType
    enum StatusType {
        case internet
        case modem
    }

    /// Input structure
    struct Input {
        
    }

    /// Output structure
    struct Output {
        let isOnlineObservable: Observable<Bool>
        let titleTextDriver: Driver<String>
        let statusTextDriver: Driver<String>
        let descriptionTextDriver: Driver<String>
    }

    /// Input/Output structure variable
    let input: Input
    let output: Output

    /// Initializes a new instance of networkRepository and statusType
    /// - Parameter networkRepository : gives all api values of network
    /// type : status type
    init(networkRepository: NetworkRepository, type: StatusType) {
        input = Input()

        let isOnlineObservable = OnlineStatusViewModel.createIsOnlineObservable(networkRepository: networkRepository, type: type)
        let titleTextDriver = OnlineStatusViewModel.createTitleTextDriver(type: type)
        let statusTextDriver = isOnlineObservable.map { isOnline -> String in
            return isOnline ? Constants.NetworkInfo.online : Constants.NetworkInfo.offline
        }.asDriver(onErrorJustReturn: Constants.NetworkInfo.offline)
        let descriptionTextDriver = OnlineStatusViewModel.createDescriptionTextDriver(networkRepository: networkRepository, type: type)

        output = Output(
            isOnlineObservable: isOnlineObservable,
            titleTextDriver: titleTextDriver,
            statusTextDriver: statusTextDriver,
            descriptionTextDriver: descriptionTextDriver
        )
    }

    /// Checks network is online/Not
    /// Initializes a new instance of networkRepository and statusType
    /// - Parameter networkRepository : gives all api values of network
    /// type : status type
    fileprivate static func createIsOnlineObservable(networkRepository: NetworkRepository, type: StatusType) -> Observable<Bool> {
        switch type {
        case .internet:
            return networkRepository.isOnlineSubject.asObservable()
        case .modem:
            return networkRepository.isModemOnlineSubject.asObservable()
        }
    }

    /// Creates the title
    /// - Parameter type : status type
    fileprivate static func createTitleTextDriver(type: StatusType) -> Driver<String> {
        switch type {
        case .internet:
            return .just(Constants.NetworkInfo.internet)
        case .modem:
            return .just(Constants.NetworkInfo.modem)
        }
    }

    /// Creates description for the title
    /// Initializes a new instance of networkRepository and statusType
    /// - Parameter networkRepository : gives all api values of network
    /// type : status type
    fileprivate static func createDescriptionTextDriver(networkRepository: NetworkRepository, type: StatusType) -> Driver<String> {
        switch type {
        case .internet:
            return networkRepository.isOnlineSubject.map { isOnline -> String in
                    return isOnline ? Constants.NetworkInfo.connectedToInternet : Constants.NetworkInfo.canNotConnectToInternet
                }.asDriver(onErrorJustReturn: Constants.NetworkInfo.canNotConnectToInternet)
        case .modem:
            return networkRepository.serialNumberSubject.map { serialNumber -> String in
                return Constants.NetworkInfo.serialNumber + " " + serialNumber
            }.asDriver(onErrorJustReturn: Constants.NetworkInfo.serialNumber)
        }
    }
}
