//
//  SubscriptionViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 06/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import DPProtocols
import UIKit
/*
 SubscriptionViewModel to handle the details about subscription
 */
class SubscriptionViewModel {
    
    /// SectionType to select perticular section
    enum SectionType: Int {
        case planDetail = 0
        case editPaymentDetails
        case previousStatements
        case mySubscription
    }
    
    /// Input Structure
    struct Input {
        let doneTapObserver: AnyObserver<Void>
        let moveToManageMySubscription: AnyObserver<Account>
        let cellSelectionObserver: AnyObserver<IndexPath>
    }
    
    /// Output Structure
    struct Output {
        let viewStatusObservable: Observable<ViewStatus>
        let viewComplete: Observable<SubscriptionCoordinator.Event>
    }
    
    /// Subject to handle view status
    private let viewStatusSubject = PublishSubject<ViewStatus>()
    
    /// Subject to handle done button tap
    private let doneTapSubject = PublishSubject<Void>()
    
    /// Subject to handle editpayment
    private let moveToEditPaymentSubject = PublishSubject<Void>()
    
    /// Subject to handle manage user subscription
    private let moveToManageMySubscriptionSubject = PublishSubject<Account>()
    
    /// Subject to handle statement details
    private let moveToStatementDetailSubject = PublishSubject<PaymentRecord>()
    
    /// Subject to handle cell selection on table
    private let cellSelectionSubject = PublishSubject<IndexPath>()
    
    /// Input & Output Structure variable
    let input: Input
    let output: Output
    
    let sections = BehaviorSubject(value: [TableDataSource]())
    
    /// Holds subscriptionRepository with strong reference
    var subscriptionRepository: SubscriptionRepository
    
    private let disposeBag = DisposeBag()
    
    var statements: [PaymentRecord]?
    
    /// Holds Account with strong reference
    private var accountInfo: Account
    
    /// Holds paymentInfo with strong reference
    private var paymentInfo: PaymentInfo
    
    /// Holds paymentInfo with strong reference
    private var fiberPlanInfo: FiberPlanInfo
    
    /// Initializes a new instance of Subscription and SubscriptionRepository
    /// - Parameter Account : Contains all account values
    init(with subscription: Subscription, repository: SubscriptionRepository) {
        self.accountInfo = subscription.account
        self.paymentInfo = subscription.paymentInfo
        self.fiberPlanInfo = subscription.fiberPlanInfo
        self.subscriptionRepository = repository
        input = Input(
            doneTapObserver: doneTapSubject.asObserver(),
            moveToManageMySubscription: moveToManageMySubscriptionSubject.asObserver(),
            cellSelectionObserver: cellSelectionSubject.asObserver()
        )
        
        let doneTapObservable = doneTapSubject.asObservable().map { _ in
            return SubscriptionCoordinator.Event.goBackToAccount
        }
        
        let moveToEditPaymentObserverable = moveToEditPaymentSubject.asObservable().map { _ in
            return SubscriptionCoordinator.Event.goToEditPayment
        }
        
        let moveToManageMySubscriptionObservable = moveToManageMySubscriptionSubject.asObservable().map { account in
            return SubscriptionCoordinator.Event.goToManageSubscription(account)
        }
        
        let moveToStatementDetailObservable = moveToStatementDetailSubject.asObservable().map { paymentRecord in
            return SubscriptionCoordinator.Event.goToStatementDetail(paymentRecord)
        }
        
        let viewCompleteObservable = Observable.merge(doneTapObservable,
                                                      moveToEditPaymentObserverable,
                                                      moveToManageMySubscriptionObservable,
                                                      moveToStatementDetailObservable)
        
        output = Output(
            viewStatusObservable: viewStatusSubject.asObservable(),
            viewComplete: viewCompleteObservable
        )
        cellSelectionSubject.subscribe(onNext: {[weak self] indexPath in
            self?.handleCellSelection(for: indexPath)
        }).disposed(by: disposeBag)
        
        createSubscriptions()
        getPreviousStatementsList()
    }
}

/// Table view sections
extension SubscriptionViewModel {
    
    /// Creating Subscription goes here
    private func createSubscriptions() {
        subscriptionRepository.statementsList
            .subscribe(onNext: { [weak self] statementsList in
                guard let self = self else { return }
                self.viewStatusSubject.onNext(ViewStatus.loaded)
                
                guard let recordList = statementsList.records else { return }
                self.statements = recordList
                self.setSections()
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.invoicesListSuccess)
            }).disposed(by: self.disposeBag)
        
        subscriptionRepository.paymentInfo
            .subscribe(onNext: { [weak self] paymentInfo in
                guard let self = self else { return }
                self.viewStatusSubject.onNext(ViewStatus.loaded)
                
                self.paymentInfo = paymentInfo
                self.setSections()
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.paymentInfoSuccess)
            }).disposed(by: self.disposeBag)
        
        subscriptionRepository.errorMessagePaymentInfo
            .subscribe(onNext: {[weak self] error in
                let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                    self?.updatePaymentInfo()
                }
                self?.viewStatusSubject.onNext(error)
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.paymentInfoFailure)
            }).disposed(by: self.disposeBag)
        
        subscriptionRepository.errorMessage
            .subscribe(onNext: {[weak self] error in
                let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                    self?.getPreviousStatementsList()
                }
                self?.viewStatusSubject.onNext(error)
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.invoicesListFailure)
            }).disposed(by: self.disposeBag)
    }
    
    /// Sets every section on table
    private func setSections() {
        sections.onNext(getSections())
    }
    
    /// Get every sections created on table
    private func getSections() -> [TableDataSource] {
        var tabelDataSource = [
            createPlanDetailSection(),
            createEditPaymentDetailsSection(),
            createMySubscriptionSection()
        ]
        if let previousStatements = statements, !previousStatements.isEmpty {
            tabelDataSource.insert(createPreviousStatementsSection(forStatements: previousStatements),
                                   at: SectionType.previousStatements.rawValue)
        }
        return tabelDataSource
    }
    
     /// Create a table section for plan and return a table datasource
    private func createPlanDetailSection() -> TableDataSource {
        return TableDataSource(
            header: nil,
            items: [Item(identifier: FiberPlanDetailTableViewCell.identifier,
                         viewModel: FiberPlanDetailCellViewModel.init(fiberPlanInfo: fiberPlanInfo))]
        )
    }
    
     /// Create a table section for  edit payment and return a table datasource
    private func createEditPaymentDetailsSection() -> TableDataSource {
        return TableDataSource(
            header: Constants.Subscription.editBillingInfo,
            items: [Item(identifier: TitleTableViewCell.identifier,
                         viewModel: TitleTableViewCellViewModel.init(with: paymentInfo.card,
                                                                     hideNextImage: false,
                                                                     hideSeperator: false))]
        )
    }
    
    /// Create a table section for  previous statements and return a table datasource
     /// - Parameter paymentRecords : Array of payment records
    private func createPreviousStatementsSection(forStatements paymentRecords: [PaymentRecord]) -> TableDataSource {
        let recordDates = paymentRecords.compactMap{ $0.getCreatedDate() }
        let items = recordDates.compactMap { date -> Item in
            return Item.init(identifier: TitleTableViewCell.identifier,
                             viewModel: TitleTableViewCellViewModel(with: date,
                                                                    hideNextImage: false,
                                                                    hideSeperator: false),
                             object: recordDates)
        }
        return TableDataSource(header: Constants.Subscription.previousStatements,
                               items: items)
    }
    
    /// Create a table section for my subscription and returm a table datasource
    private func createMySubscriptionSection() -> TableDataSource {
        return TableDataSource(
            header: Constants.Subscription.mySubscription,
            items: [Item(identifier: TitleTableViewCell.identifier,
                         viewModel: TitleTableViewCellViewModel.init(with:
                            Constants.Subscription.manageMySubscription,
                                                                     hideNextImage: false,
                                                                     hideSeperator: false))]
        )
    }
    
    /// Handles the cell selection in table for evry index path
    private func handleCellSelection(for indexpath: IndexPath) {
        var section = SectionType.init(rawValue: indexpath.section)
        guard let statementsList = self.statements else { return }
        section = (section == SectionType.previousStatements && statementsList.count == 0) ? SectionType.mySubscription : section
        switch section {
        case .editPaymentDetails:
            moveToEditPaymentSubject.onNext(())
        case .mySubscription:
            moveToManageMySubscriptionSubject.onNext(self.accountInfo)
        case .previousStatements:
            var selectedStatement = statementsList[indexpath.row]
            selectedStatement.email = accountInfo.email
            selectedStatement.billingAddress = Account.getFullAddress(billingAddress: accountInfo.billingAddress)
            moveToStatementDetailSubject.onNext(selectedStatement)
        default:
            break
        }
    }
    
    /// Getting the privious statement List
    private func getPreviousStatementsList() {
        let loading = ViewStatus.loading(loadingText: Constants.Common.loading)
        viewStatusSubject.onNext(loading)
        subscriptionRepository.getStatementsList(forAccountID: accountInfo.accountId ?? "")
    }
    
    /// Update the payment info for perticular Account ID
    func updatePaymentInfo() {
        subscriptionRepository.getPaymentInfo(forAccountId: accountInfo.accountId ?? "")
    }
}
