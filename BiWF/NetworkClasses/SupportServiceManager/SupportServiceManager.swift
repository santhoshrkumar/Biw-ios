//
//  SupportServiceManager.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 05/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift

protocol SupportServiceManager {
    func getFaqList(for recordTypeID: String) -> Observable<Result<Data, Error>>
    func getRecordTypeID() -> Observable<Result<Data, Error>>
    func scheduleSupportGuestCallback(scheduleCallbackInfo: ScheduleCallback) -> Observable<Result<Data, Error>>
    func getCustomerCareOptionList(for recordTypeID: String) -> Observable<Result<Data, Error>>
    func getCustomerCareRecordTypeID() -> Observable<Result<Data, Error>>
}
