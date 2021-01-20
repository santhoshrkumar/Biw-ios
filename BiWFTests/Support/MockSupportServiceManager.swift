//
//  MockSupportServiceManager.swift
//  BiWFTests
//
//  Created by Aditi.A.Gandhi on 09/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
@testable import BiWF

class MockSupportServiceManager: SupportServiceManager {
    func scheduleSupportGuestCallback(scheduleCallbackInfo: ScheduleCallback) -> Observable<Result<Data, Error>> {
        let scheduleSupportGuestCallbackResult = PublishSubject<Result<Data, Error>>()
        scheduleSupportGuestCallbackResult.onNext(getDataFromJSON(resource: "scheduleCallBack.json"))
        return scheduleSupportGuestCallbackResult
    }


    func getRecordTypeID() -> Observable<Result<Data, Error>> {
        let recordTypeIDResult = PublishSubject<Result<Data, Error>>()
        recordTypeIDResult.onNext(getDataFromJSON(resource: "recordTypeID"))
        return recordTypeIDResult
    }

    func getFaqList(for recordTypeID: String) -> Observable<Result<Data, Error>> {
        let serviceFaqListResult = PublishSubject<Result<Data, Error>>()
        serviceFaqListResult.onNext(getDataFromJSON(resource: "faqList"))
        return serviceFaqListResult
    }

    func getCustomerCareOptionList(for recordTypeID: String) -> Observable<Result<Data, Error>> {
        let customerCareOptionResult = PublishSubject<Result<Data, Error>>()
        customerCareOptionResult.onNext(getDataFromJSON(resource: "optionList"))
        return customerCareOptionResult
    }

    func getCustomerCareRecordTypeID() -> Observable<Result<Data, Error>> {
        let customerCareRecordTypeID = PublishSubject<Result<Data, Error>>()
        customerCareRecordTypeID.onNext(getDataFromJSON(resource: "recordTypeID"))
        return customerCareRecordTypeID
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

    func getFAQList() -> FaqList {
        let mockEmptyFAQList = FaqList(records: [FaqRecord(attributes: FaqRecordAttributes(type: "", url: ""), articleNumber: "", articleTotalViewCount: 0, articleContent: "", articleUrl: "", Id: "", language: "", sectionC: "", title: "", isAnswerExpanded: false)], done: true, totalSize: 1)

        guard let path = Bundle.main.path(forResource: "FaqList",
                                          ofType: "json") else {
                                            return mockEmptyFAQList
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path),
                                options: .mappedIfSafe)
            let faqList = try JSONDecoder().decode(FaqList.self, from: data)
            return faqList
        } catch {
            print(error)
            return mockEmptyFAQList
        }
    }

}
