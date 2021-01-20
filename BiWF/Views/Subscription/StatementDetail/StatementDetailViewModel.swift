
//
//  StatementDetailViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 11/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import DPProtocols
/*
 StatementDetailViewModel gives the payment statement
 */
class StatementDetailViewModel {
    
    /// Input Structure
    struct Input {
        let doneTapObserver: AnyObserver<Void>
        let backTapObserver: AnyObserver<Void>
    }
    
    /// Output Structure
    struct Output {
        let viewStatusObservable: Observable<ViewStatus>
        let viewComplete: Observable<SubscriptionCoordinator.Event>
    }
    
    /// Subject to handle done button tap
    private let doneTapSubject = PublishSubject<Void>()
    
    /// Subject to handle back button tap
    private let backTapSubject = PublishSubject<Void>()
    
    /// Subject to view the status
    private let viewStatusSubject = PublishSubject<ViewStatus>()
    
    let input: Input
    let output: Output
    
    private let disposeBag = DisposeBag()
    let sections = BehaviorSubject(value: [TableDataSource]())
    
    /// Holds the PaymentRecord with strong reference
    let paymentRecord: PaymentRecord
    
    /// Holds the Invoice with strong reference
    var invoiceDetails: Invoice?
    
    /// Holds the SubscriptionRepository with strong reference
    let repository: SubscriptionRepository
    
    /// Initializes a new instance of SubscriptionRepository and PaymentRecord
    /// - Parameter repository : SubscriptionRepository gives the api value for user's statement
    /// paymentRecord - contains all the values for Payment Record
    init(withRepository repository: SubscriptionRepository, paymentRecord: PaymentRecord) {
        self.repository = repository
        self.paymentRecord = paymentRecord
        
        input = Input(
            doneTapObserver: doneTapSubject.asObserver(),
            backTapObserver: backTapSubject.asObserver()
        )
        
        let doneEventObservable = doneTapSubject.asObservable().map { _ in
            return SubscriptionCoordinator.Event.goBackToAccount
        }
        
        let backEventObservable = backTapSubject.asObservable().map { _ in
            return SubscriptionCoordinator.Event.goBack
        }
        
        let viewCompleteObservable = Observable.merge(doneEventObservable,
                                                      backEventObservable)
        
        output = Output(viewStatusObservable: viewStatusSubject.asObservable(),
                        viewComplete: viewCompleteObservable)
        
        getInvoice()
    }
}

/// StatementDetailViewModel extension contain the Table view sections
extension StatementDetailViewModel {
    
    /// Sets all the sections to the table
    private func setSections() {
        sections.onNext(getSections())
    }
    
    /// Get the sections for the respective table
    private func getSections() -> [TableDataSource] {
        return [
            createSection()
        ]
    }
    
    /// Get the invoice for payment
    func getInvoice() {
        let loading = ViewStatus.loading(loadingText: Constants.Common.loading)
        viewStatusSubject.onNext(loading)
        repository.invoice
            .subscribe(onNext: { invoice in
                self.viewStatusSubject.onNext(ViewStatus.loaded)
                
                self.invoiceDetails = invoice
                self.invoiceDetails?.email = self.paymentRecord.email
                self.invoiceDetails?.billingAddress = self.paymentRecord.billingAddress
                self.setSections()
            }).disposed(by: self.disposeBag)
        
        repository.errorMessage
            .subscribe(onNext: {[weak self] error in
                let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                    self?.getInvoice()
                }
                self?.viewStatusSubject.onNext(error)
            }).disposed(by: self.disposeBag)
        
        repository.getInvoice(forPaymentID: paymentRecord.id ?? "")
    }
    
    /// Create Table sections and returns tabledatasource
    private func createSection() -> TableDataSource {
        var items = [Item]()
        if let invoiceDetail = self.invoiceDetails {
            items = [createPaymentDetailsItem(withInvoiceDetails: invoiceDetail),
                     createPaymentBreakdownItem(withInvoiceDetails: invoiceDetail)]
        }
        return TableDataSource(header:nil,
                               items: items)
    }
    
    /// Create Payment details
    /// - Parameter invoice : Paymetn invoice
    func createPaymentDetailsItem(withInvoiceDetails invoice: Invoice) -> Item {
        return Item.init(identifier: PaymentDetailTableViewCell.identifier,
                         viewModel: PaymentDetailCellViewModel.init(with: invoice))
    }
    
    /// Create BreakdownPayment details
    /// - Parameter invoice : Paymetn invoice
    func createPaymentBreakdownItem(withInvoiceDetails invoice: Invoice) -> Item {
        return Item.init(identifier: PaymentBreakdownTableViewCell.identifier,
                         viewModel: PaymentBreakdownCellViewModel.init(with: invoice))
    }
}
