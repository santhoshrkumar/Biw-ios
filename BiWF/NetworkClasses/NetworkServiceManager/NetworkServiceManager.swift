//
//  AssiaServiceManager.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 6/17/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift

protocol NetworkServiceManager {

    func getNetworkStatus() -> Observable<Result<Data, Error>>
    func restartModem() -> Observable<Result<Data, Error>>
    func runSpeedTest() -> Observable<Result<Data, Error>>
    func checkSpeedTestStatus(requestId: String) -> Observable<Result<Data, Error>>

    //Enable disable network
    func enableNetwork(forInterface interface: String) -> Observable<Result<Data, Error>>
    func disableNetwork(forInterface interface: String) -> Observable<Result<Data, Error>>

    //Post network SSID
    func updateNetworkSSID(newSSID: String, forInterface interface: String) -> Observable<Result<Data, Error>>

    //Get/Post network password
    func getNetworkPassword(forInterface interface: String) -> Observable<Result<Data, Error>>
    func updateNetworkPassword(newPassword: String, forInterface interface: String) -> Observable<Result<Data, Error>>
}
