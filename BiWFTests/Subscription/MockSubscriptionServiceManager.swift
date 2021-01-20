//
//  MockSubscriptionServiceManager.swift
//  BiWF
//
//  Created by pooja.q.gupta on 19/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
@testable import BiWF

class MockSubscriptionServiceManager: SubscriptionServiceManager {
    func getFiberInternetInfo(forAccountId accountID: String) -> Observable<Result<Data, Error>> {
        return .just(getDataFromJSON(resource: "FiberPlanInfo"))
    }
    
    func getPaymentInfo(forAccountId accountID: String) -> Observable<Result<Data, Error>> {
        return .just(getDataFromJSON(resource: "paymentInfo"))
    }
    
    func getStatementsList(forAccountID accountID: String) -> Observable<Result<Data, Error>> {
        let recordTypeIDResult = PublishSubject<Result<Data, Error>>()
        recordTypeIDResult.onNext(getDataFromJSON(resource: "statementList"))
        return recordTypeIDResult
    }
    
    func getInvoice(forPaymentID paymentID: String) -> Observable<Result<Data, Error>> {
        let statementsListResult = PublishSubject<Result<Data, Error>>()
        statementsListResult.onNext(getDataFromJSON(resource: "statementList"))
        return statementsListResult
    }
    
    func getRecordTypeID() -> Observable<Result<Data, Error>> {
        let invoiceResult = PublishSubject<Result<Data, Error>>()
        invoiceResult.onNext(getDataFromJSON(resource: "invoice"))
        return invoiceResult
    }
    
    func cancelMySubscription(forSubscriptionDetails details: CancelSubscription) -> Observable<Result<Data, Error>> {
        let cancelSubscriptionResult = PublishSubject<Result<Data, Error>>()
        cancelSubscriptionResult.onNext(getDataFromJSON(resource: "invoice"))
        return cancelSubscriptionResult
    }

    func mockStatementList() -> [PaymentRecord] {
        let record = PaymentRecord(attributes: RecordAttributes(type: "Zuora__Payment__c",
                                                                url: "/services/data/v46.0/sobjects/Zuora__Payment__c/a7Nq0000000BYvlEAG"),
                                   id: "a7Nq0000000BYvlEAG",
                                   zuoraInvoice: "",
                                   createdDate: "2020-04-24T13:37:55.000+0000",
                                   email: "",
                                   billingAddress: "",
                                   contactID: "")
        return [record]
    }

    func mockPaymentInfo() -> PaymentInfo {
        return PaymentInfo(card: "Visa ************8291",
                           billCycleDay: "29th of the month",
                           nextRenewalDate: "2020-07-29",
                           id: "a1Ff0000001hp33EAA")
    }
    
    func mockFiberPlanInfo() -> FiberPlanInfo {
        return FiberPlanInfo(internetSpeed: "Speed upto 940Mbps", productName : "Fiber Internet", id: "a1Ff0000001hp33EAA",
        zuoraPrice : 65.0, extendedAmount: 65.0)
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
