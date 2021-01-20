//
//  SubscriptionRepository.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 12/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import DPProtocols
import RxSwift
import Foundation
/**
 Assists in the implemetation of the SubscriptionRepository, enabling an abstraction of data
 */
struct SubscriptionRepository: Repository {
    
    /// PublishSubject notification is broadcasted to all subscribed observers when responses come as Bool/Objects/ error
    let statementsList = PublishSubject<StatementList>()
    let invoice = PublishSubject<Invoice>()
    let errorMessage = PublishSubject<String>()
    let cancellationStatusResult = PublishSubject<CancelSubscription>()
    let recordIDResult = PublishSubject<String>()
    let paymentInfo = PublishSubject<PaymentInfo>()
    let errorMessagePaymentInfo = PublishSubject<String>()
    let fiberPlanInfo = PublishSubject<FiberPlanInfo>()
    let errorMessageFiberPlanInfo = PublishSubject<String>()
    
    /// Contained disposables disposal
    let disposeBag = DisposeBag()
    /// Holds the subscriptionServiceManager with a strong reference
    let subscriptionServiceManager: SubscriptionServiceManager
    
    /// Initialise the subscriptionServiceManager
    /// - Parameters:
    ///   - subscriptionServiceManager: shared object of subscriptionServiceManager
    init(subscriptionServiceManager: SubscriptionServiceManager = NetworkSubscriptionServiceManager.shared) {
        self.subscriptionServiceManager = subscriptionServiceManager
    }
    
    /// Call method of subscription network manager which gives statement list
    /// - Parameters:
    ///   - forAccountID: account ID of the user, come from Account API
    func getStatementsList(forAccountID accountID: String) {
        self.subscriptionServiceManager.getStatementsList(forAccountID: accountID)
            .subscribe(onNext: { [unowned statementsList, unowned errorMessage] result in
                switch result {
                case .success(let response):
                    do {
                        let recordsList = try JSONDecoder().decode(StatementList.self, from: response)
                        statementsList.onNext(recordsList)
                    }
                    catch {
                        errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
                    }
                case .failure(let error):
                    errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Call method of subscription network manager which gives invoice details
    /// - Parameters:
    ///   - forPaymentID: payment ID of the user, come from Account API
    func getInvoice(forPaymentID paymentID: String) {
        self.subscriptionServiceManager.getInvoice(forPaymentID: paymentID)
            .subscribe(onNext: { [unowned invoice, unowned errorMessage] result in
                switch result {
                case .success(let response):
                    do {
                        let invoiceDetails = try JSONDecoder().decode(Invoice.self, from: response)
                        invoice.onNext(invoiceDetails)
                    } catch {
                        errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
                    }
                case .failure(let error):
                    errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Call method of subscription network manager which fetch user "RecordID"
    func getRecordID() {
        self.subscriptionServiceManager.getRecordTypeID()
            .subscribe(onNext: { [unowned recordIDResult, unowned errorMessage] result in
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
            })
            .disposed(by: disposeBag)
    }
    
    /// Call method of subscription network manager which cancelMySubscription
    /// - Parameters:
    ///   - subscription: Subscription object
    func cancelMySubscription(forCancelSubscription subscription: CancelSubscription) {
        self.subscriptionServiceManager.cancelMySubscription(forSubscriptionDetails: subscription)
            .subscribe(onNext: { [unowned cancellationStatusResult, unowned errorMessage] result in
                switch result {
                case .success(let response):
                    do {
                        let cancellationStatus = try JSONDecoder().decode(CancelSubscription.self, from: response)
                        cancellationStatusResult.onNext(cancellationStatus)
                    } catch {
                        errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
                    }
                case .failure(let error):
                    errorMessage.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            })
            .disposed(by: disposeBag)
    }

    /// Call method of subscription network manager which gives payment info
    /// - Parameters:
    ///   - forAccountId: account ID of the user, come from Account API
    func getPaymentInfo(forAccountId accountId: String) {
        subscriptionServiceManager.getPaymentInfo(forAccountId: accountId)
            .subscribe(onNext: { [unowned paymentInfo, unowned errorMessagePaymentInfo] result in
                switch result {
                case .success(let response):
                    do {
                        let response = try JSONDecoder().decode(PaymentInfoResponse.self, from: response)
                        if let paymentInformation = response.records.first {
                            paymentInfo.onNext(paymentInformation)
                        }
                    } catch {
                        errorMessagePaymentInfo.onNext(ServiceManager.getErrorMessage(forError: error))
                    }
                case .failure(let error):
                    errorMessagePaymentInfo.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// Call method of subscription network manager which gives Fiber internet info
    func getFiberPlanInfo(forAccountId accountId: String) {
        subscriptionServiceManager.getFiberInternetInfo(forAccountId: accountId)
            .subscribe(onNext: { [unowned fiberPlanInfo, unowned errorMessageFiberPlanInfo] result in
                switch result {
                case .success(let response):
                    do {
                        let response = try JSONDecoder().decode(FiberPlanInfoResponse.self, from: response)
                        if let fiberPlanInformation = response.records.first {
                            fiberPlanInfo.onNext(fiberPlanInformation)
                        }
                    } catch {
                        errorMessageFiberPlanInfo.onNext(ServiceManager.getErrorMessage(forError: error))
                    }
                case .failure(let error):
                    errorMessageFiberPlanInfo.onNext(ServiceManager.getErrorMessage(forError: error))
                }
            }).disposed(by: disposeBag)
    }
}
