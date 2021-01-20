//
//  SubscriptionServiceManager.swift
//  BiWF
//
//  Created by pooja.q.gupta on 19/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift

protocol SubscriptionServiceManager {
    
    func getStatementsList(forAccountID accountID: String) -> Observable<Result<Data, Error>>
    func getInvoice(forPaymentID paymentID: String) -> Observable<Result<Data, Error>>
    func getRecordTypeID() -> Observable<Result<Data, Error>>
    func cancelMySubscription(forSubscriptionDetails details: CancelSubscription) -> Observable<Result<Data, Error>>
    func getPaymentInfo(forAccountId accountID: String) -> Observable<Result<Data, Error>>
    func getFiberInternetInfo(forAccountId accountID: String) -> Observable<Result<Data, Error>>
}
