//
//  SupportRepository.swift
//  BiWF
//
//  Created by pooja.q.gupta on 09/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import DPProtocols
/**
 Assists in the implemetation of the SupportRepository, enabling an abstraction of data
 */
class SupportRepository: Repository {
    
    /// PublishSubject notification is broadcasted to all subscribed observers when responses come as Bool/Objects/ error
    let faqListResult = PublishSubject<FaqList>()
    let errorMessage = PublishSubject<String>()
    let recordIDResult = PublishSubject<String>()
    let customerCareRecordIDResult = PublishSubject<String>()
    /// Contained disposables disposal
    let scheduleCallbackResult = PublishSubject<ScheduleCallbackResponse>()
    let customerCareOptionListResult = PublishSubject<CustomerCareListResponse>()
    let disposeBag = DisposeBag()
    /// Holds the supportServiceManager with a strong reference
    let supportServiceManager: SupportServiceManager
    
    /// Initialise the SupportServiceManager
    /// - Parameters:
    ///   - supportServiceManager: shared object of SupportServiceManager
    init(supportServiceManager: SupportServiceManager = NetworkSupportServiceManager.shared) {
        self.supportServiceManager = supportServiceManager
    }
    
    /// Call method of support network manager which fetch user "RecordID"
    func getRecordID() {
        let recordTypeIDResult = self.supportServiceManager.getRecordTypeID()
        recordTypeIDResult.subscribe(onNext: { [unowned recordIDResult, unowned errorMessage] result in
            switch result {
            case .success(let response):
                do {
                    let recordsList = try JSONDecoder().decode(StatementList.self, from: response)
                    
                    //Get the case record ID which will common for all users, through the calling query always get a single record at index [0]
                    let caseRecordID = String(recordsList.records?[0].id ?? "")
                    recordIDResult.onNext(caseRecordID)
                } catch {
                    errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            case .failure(let error):
                errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
            }
        }).disposed(by: disposeBag)
    }
    
    /// Call method of support network manager which fetch user "RecordID" doe customer option list
    func getCustomerCareRecordID() {
        let recordTypeIDResult = self.supportServiceManager.getCustomerCareRecordTypeID()
        recordTypeIDResult.subscribe(onNext: { [unowned customerCareRecordIDResult, unowned errorMessage] result in
            switch result {
            case .success(let response):
                do {
                    let recordsList = try JSONDecoder().decode(StatementList.self, from: response)
                    
                    //Get the case record ID which will common for all users, through the calling query always get a single record at index [0]
                    let caseRecordID = String(recordsList.records?[0].id ?? "")
                    customerCareRecordIDResult.onNext(caseRecordID)
                } catch {
                    errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            case .failure(let error):
                errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
            }
        }).disposed(by: disposeBag)
    }
    
    /// Call method of support network manager to fetch FAQ topics list using record ID fetched from above API
    /// - Parameters:
    ///   - forRecordID: record ID fetched from above API
    func getFaqTopics(forRecordID id: String) {
        let serviceFaqListResult = supportServiceManager.getFaqList(for: id)
        serviceFaqListResult.subscribe(onNext: { [unowned faqListResult, unowned errorMessage] result in
            switch result {
            case .success(let response):
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.FAQQuestionSuccess)
                do {
                    let faqList = try JSONDecoder().decode(FaqList.self, from: response)
                    faqListResult.onNext(faqList)
                } catch {
                    errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            case .failure(let error):
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.FAQQuestionFailure)
                errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
            }
        }).disposed(by: disposeBag)
    }
    
    /// Contact information hardcoded currently as not coming from API
    func getContactUsOptions() -> ContactUs {
        return ContactUsResponse.loadFromJson() ??
            ContactUs(
                liveChatTimings: "8:00am - 5:00pm MST",
                liveChatWebUrl: "",
                scheduleCallbackTimings: "8:00am - 5:00pm MST",
                contactDetails: "(123) 456-7890"
        )
    }
    
    /// Call method of support network manager to setup scheduleCallback
    /// - Parameters:
    ///   - scheduleCallbackInfo: scheduleCallbackInfo information added by the user
    func scheduleSupportCallBack(scheduleCallbackInfo: ScheduleCallback) {
        let serviceScheduleCallbackResult = self.supportServiceManager.scheduleSupportGuestCallback(scheduleCallbackInfo: scheduleCallbackInfo)
        serviceScheduleCallbackResult.subscribe(onNext: { result in
            switch result {
            case .success(let response):
                do {
                    let callbackResponse = try JSONDecoder().decode(ScheduleCallbackResponse.self , from: response)
                    self.scheduleCallbackResult.onNext(callbackResponse)
                } catch {
                    self.errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            case .failure(let error):
                self.errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
            }
        }).disposed(by: disposeBag)
    }
    
    /// Call method of support network manager to fetch customer care option list
    /// - Parameters:
    ///   - forRecordID: record ID fetched from above API
    func getCustomerCareOptionList(forRecordID id: String) {
        let customerCareOptionListResult = self.supportServiceManager.getCustomerCareOptionList(for: id)
        customerCareOptionListResult.subscribe(onNext: { result in
            switch result {
            case .success(let response):
                do {
                    let callbackResponse = try JSONDecoder().decode(CustomerCareListResponse.self , from: response)
                    self.customerCareOptionListResult.onNext(callbackResponse)
                } catch {
                    self.errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            case .failure(let error):
                self.errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
            }
        }).disposed(by: disposeBag)
    }
    
}
