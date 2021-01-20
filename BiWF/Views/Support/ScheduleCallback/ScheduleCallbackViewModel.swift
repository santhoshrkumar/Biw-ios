//
//  ScheduleCallbackViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 30/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import DPProtocols
/*
 ScheduleCallbackViewModel handles schedule call back events
 */
class ScheduleCallbackViewModel {
    
    /// Sectiontype to select a perticular section
    enum SectionType: Int {
        case selectReason = 0
        case callUsNow
    }
    
    /// Input structure
    struct Input {
        let cancelTapObserver: AnyObserver<Void>
        let backTapObserver: AnyObserver<Void>
        let moveToAdditionalInfoObserver: AnyObserver<ScheduleCallback>
        let cellSelectionObserver: AnyObserver<IndexPath>
    }
    
    /// Output structure
    struct Output {
        let viewStatusObservable: Observable<ViewStatus>
        let callUsNowObservable: Observable<Void>
        let viewComplete: Observable<SupportCoordinator.Event>
    }
    
    /// Subject to handle cancel button tap
    private let cancelTapSubject = PublishSubject<Void>()
    
    /// Subject to view the status of the Appointment
    let viewStatusSubject = PublishSubject<ViewStatus>()
    
    /// Subject to handle back button tap
    private let backTapSubject = PublishSubject<Void>()
    private let moveToAdditionalInfoSubject = PublishSubject<ScheduleCallback>()
    private let cellSelectionSubject = PublishSubject<IndexPath>()
    
    /// Subject to handle call us button tap
    private let callUsNowSubject = PublishSubject<Void>()
    private var repository: SupportRepository?
    var customerCareOptionList: CustomerCareListResponse?
    
    /// Input & Output structure variable
    let input: Input
    let output: Output
    
    let sections = BehaviorSubject(value: [TableDataSource]())
    private let disposeBag = DisposeBag()
    
    init(with repository: SupportRepository) {
        self.repository = repository
        input = Input(
            cancelTapObserver: cancelTapSubject.asObserver(),
            backTapObserver: backTapSubject.asObserver(),
            moveToAdditionalInfoObserver: moveToAdditionalInfoSubject.asObserver(),
            cellSelectionObserver: cellSelectionSubject.asObserver()
        )
        
        let cancelEventObservable = cancelTapSubject.asObservable().map { _ in
            return SupportCoordinator.Event.goBackToTabView
        }
        
        let backEventObservable = backTapSubject.asObservable().map { _ in
            return SupportCoordinator.Event.goBack
        }
        
        let moveToAdditonalInfoObservable = moveToAdditionalInfoSubject.asObservable().map { scheduleCallbackDetails in
            return SupportCoordinator.Event.goToAdditionalInfo(scheduleCallbackDetails)
        }
        
        let viewCompleteObservable = Observable.merge(cancelEventObservable,
                                                      backEventObservable,
                                                      moveToAdditonalInfoObservable)
        
        output = Output(viewStatusObservable: viewStatusSubject.asObservable(),
                        callUsNowObservable: callUsNowSubject.asObservable(),
                        viewComplete: viewCompleteObservable)
        
        getCustomerCareOptionsList()
        
        cellSelectionSubject.subscribe(onNext: {[weak self] indexPath in
            self?.handleCellSelection(for: indexPath)
        }).disposed(by: disposeBag)
    }
}

/// ScheduleCallbackViewModel extension contains Table view sections
extension ScheduleCallbackViewModel {
    
    /// Set the table view sections
    private func setSections() {
        sections.onNext(getSections())
    }
    
    /// Get the tableview sections and returns array of tableDataSource
    private func getSections() -> [TableDataSource] {
        return [
            createCallbackReasonsSection(),
            createCallUsNowSection()
        ]
    }
    
    /// create createCallbackReasons section with tableview cell and returns a tabledatasource with header and items inside
    private func createCallbackReasonsSection() -> TableDataSource {
        var items = [Item]()
        guard let values = customerCareOptionList?.values else {
            return TableDataSource(header:nil,
                                   items: items)
        }
        items = values.compactMap { values in
            return Item(identifier: TitleTableViewCell.identifier,
                        viewModel: TitleTableViewCellViewModel(with:
                                                                values.value?.attributedStringFromHtmlString?.string ?? ""))
        }
        return TableDataSource(header: Constants.ScheduleCallback.justLetUsKnow,
                               items: items)
    }
    
    /// create createCallUsNow section with tableview cell and returns a tabledatasource with header and items inside
    private func createCallUsNowSection() -> TableDataSource {
        let item = Item.init(identifier: TitleTableViewCell.identifier,
                             viewModel: TitleTableViewCellViewModel(with:
                                                                        "\(Constants.ScheduleCallback.callUsNow) \(Constants.Common.biwfServiceNumber)"))
        
        return TableDataSource(header:nil,
                               items: [item])
    }
    
    /// Handles the cell selection at every perticular tap
    private func handleCellSelection(for indexpath: IndexPath) {
        let section = SectionType.init(rawValue: indexpath.section)
        
        switch section {
        case .selectReason:
            AnalyticsEvents.trackListItemTappedEvent(with: AnalyticsConstants.EventListItemName.scheduleCallbackItem)
            var scheduleCallbackDetails = ScheduleCallback(phone: ServiceManager.shared.phone ?? "", asap: true, customerCareOption: "", handleOption: true, callbackTime: "", callbackReason: "")
            scheduleCallbackDetails.customerCareOption = customerCareOptionList?.values?[indexpath.row].value ?? ""
            moveToAdditionalInfoSubject.onNext(scheduleCallbackDetails)
            
        case .callUsNow:
            callUsNowSubject.onNext(())
        case .none:
            break
        }
    }
    
    ///Fetch cutomer care option list from server
    private func getCustomerCareOptionsList() {
        let loading = ViewStatus.loading(loadingText: Constants.Common.loading)
        viewStatusSubject.onNext(loading)
        repository?.customerCareRecordIDResult
            .subscribe({ id in
                do {
                    self.repository?.customerCareOptionListResult
                        .subscribe(onNext: { optionList in
                            self.viewStatusSubject.onNext(ViewStatus.loaded)
                            self.customerCareOptionList = optionList
                            self.setSections()
                        }).disposed(by: self.disposeBag)
                    self.repository?.getCustomerCareOptionList(forRecordID: id.element ?? "")
                    AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.recordTypeIDSuccess)
                }
            }).disposed(by: self.disposeBag)
        repository?.errorMessage
            .subscribe(onNext: {[weak self] error in
                let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                    self?.getCustomerCareOptionsList()
                }
                self?.viewStatusSubject.onNext(error)
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.recordTypeIDFailure)
            }).disposed(by: self.disposeBag)
        repository?.getCustomerCareRecordID()
    }
}
