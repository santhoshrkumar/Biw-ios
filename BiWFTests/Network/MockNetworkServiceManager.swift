//
//  MockNetworkServiceManager.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 16/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
@testable import BiWF

class MockNetworkServiceManager: NetworkServiceManager {
    
    func getNetworkStatus() -> Observable<Result<Data, Error>> {
        let networkStatusResult = PublishSubject<Result<Data, Error>>()
        networkStatusResult.onNext(getDataFromJSON(resource: "Network"))
        return networkStatusResult
    }
    
    func restartModem() -> Observable<Result<Data, Error>> {
        let restartModemStatusResult = PublishSubject<Result<Data, Error>>()
        restartModemStatusResult.onNext(getDataFromJSON(resource: "Network"))
        return restartModemStatusResult
    }
    
    func runSpeedTest() -> Observable<Result<Data, Error>> {
        let runSpeedTestStatusResult = PublishSubject<Result<Data, Error>>()
        runSpeedTestStatusResult.onNext(getDataFromJSON(resource: "Network"))
        return runSpeedTestStatusResult
    }
    
    func checkSpeedTestStatus(requestId: String) -> Observable<Result<Data, Error>> {
        let checkSpeedTestStatusResult = PublishSubject<Result<Data, Error>>()
        checkSpeedTestStatusResult.onNext(getDataFromJSON(resource: "Network"))
        return checkSpeedTestStatusResult
    }
    
    func getSpeedTestUpstreamResults() -> Observable<Result<Data, Error>> {
        let getSpeedTestUpstreamResult = PublishSubject<Result<Data, Error>>()
        getSpeedTestUpstreamResult.onNext(getDataFromJSON(resource: "Network"))
        return getSpeedTestUpstreamResult
    }
    
    func getSpeedTestDownstreamResults() -> Observable<Result<Data, Error>> {
        let getSpeedTestDownstreamResult = PublishSubject<Result<Data, Error>>()
        getSpeedTestDownstreamResult.onNext(getDataFromJSON(resource: "Network"))
        return getSpeedTestDownstreamResult
    }
    
    func enableNetwork(forInterface interface: String) -> Observable<Result<Data, Error>> {
        let enableNetworkResult = PublishSubject<Result<Data, Error>>()
        enableNetworkResult.onNext(getDataFromJSON(resource: "Network"))
        return enableNetworkResult
    }
    
    func disableNetwork(forInterface interface: String) -> Observable<Result<Data, Error>> {
        let disableNetworkResult = PublishSubject<Result<Data, Error>>()
        disableNetworkResult.onNext(getDataFromJSON(resource: "Network"))
        return disableNetworkResult
    }
    
    func updateNetworkSSID(newSSID: String, forInterface interface: String) -> Observable<Result<Data, Error>> {
        let updateNetworkSSIDResult = PublishSubject<Result<Data, Error>>()
        updateNetworkSSIDResult.onNext(getDataFromJSON(resource: "Network"))
        return updateNetworkSSIDResult
    }
    
    func getNetworkPassword(forInterface interface: String) -> Observable<Result<Data, Error>> {
        let getNetworkPasswordResult = PublishSubject<Result<Data, Error>>()
        getNetworkPasswordResult.onNext(getDataFromJSON(resource: "Network"))
        return getNetworkPasswordResult
    }
    
    func updateNetworkPassword(newPassword: String, forInterface interface: String) -> Observable<Result<Data, Error>> {
        let updateNetworkPasswordResult = PublishSubject<Result<Data, Error>>()
        updateNetworkPasswordResult.onNext(getDataFromJSON(resource: "Network"))
        return updateNetworkPasswordResult
    }
    
    func mockAccountObject() -> Account {
        return Account(accountId: "001q000001HdaIEAAZ",
        name: "Client",
        firstName: "Client",
        billingAddress: BillingAddress.init(street: "1234 Main St",
                                            city: "Denver",
                                            state: "CO",
                                            postalCode: "77731"), marketingEmailOptIn: true,
                                                                  marketingCallOptIn: true,
                                                                  cellPhoneOptIn: true,
                                                                  productName: "Fiber Gigabit",
                                                                  productPlanName: "Best in world fiber",
                                                                  email: "nick@centurylink.com",
                                                                  lineId: "0101100408",
                                                                  serviceCity: "Denver",
                                                                  servicrCountry: "CO",
                                                                  serviceState: "CO",
                                                                  serviceStreet: "1234 Main St",
                                                                  serviceZipCode: "77731",
                                                                  serviceUnit: "CO",
                                                                  nextPaymentDate: "2020-07-29")
    }
    
    private func getDataFromJSON(resource: String) -> Result<Data, Error> {
        guard let path = Bundle.main.path(forResource: resource, ofType: "json") else {
            return .failure(HTTPError.noResponse)
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}
