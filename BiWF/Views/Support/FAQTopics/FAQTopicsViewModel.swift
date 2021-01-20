//
//  FAQTopicsViewModel.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 16/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import DPProtocols
import UIKit
/*
  FAQTopicsViewModel handles FAQTopics events
 */
class FAQTopicsViewModel {
    
    /// Section to select a perticular section
    enum Section: Int {
        case frequentlyAskedQuestions = 0
        case contactUs
    }
    
    /// Input structure
    struct Input {
        let scheduleCallbackObserver: AnyObserver<Void>
        let liveChatObserver: AnyObserver<Void>
        let backObserver: AnyObserver<Void>
        let doneObserver: AnyObserver<Void>
        let cellSelectionObserver: AnyObserver<IndexPath>
    }
    
    /// Output structure
    struct Output {
        let viewComplete: Observable<SupportCoordinator.Event>
    }
    
    /// Input & Output structure variable
    let input: Input
    let output: Output
    
    /// Subject to handle scheduleCallback cell tap
    private let scheduleCallbackSubject = PublishSubject<Void>()
    
    /// Subject to handle livechat cell tap
    private let liveChatSubject = PublishSubject<Void>()
    
    /// Subject to handle back button tap
    private let backSubject = PublishSubject<Void>()
    
    /// Subject to handle done button tap
    private let doneSubject = PublishSubject<Void>()
    
    /// Subject to handle with each cell selection
    private let cellSelectionSubject = PublishSubject<IndexPath>()
    let reloadDataSubject = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    
    /// Holds SupportRepository with strong reference
    let repository: SupportRepository
    
    /// Holds array of faqrecords
    var faqTopicData: [FaqRecord]
    let contactUsData: ContactUs
    var titleText = ""
    
    /// Initialize a new instance of SupportRepository and array of faqrecords
    /// - Parameter SupportRepository : gives the api values for faq's
    /// faqTopics : array of faqrecords
    init(withRepository repository: SupportRepository, faqTopics: [FaqRecord]) {
        self.repository = repository
        faqTopicData = faqTopics
        contactUsData = repository.getContactUsOptions()
        if faqTopicData.count > 0 { titleText = faqTopics[0].sectionC ?? "" }
        
        input = Input(
            scheduleCallbackObserver: scheduleCallbackSubject.asObserver(),
            liveChatObserver: liveChatSubject.asObserver(),
            backObserver: backSubject.asObserver(),
            doneObserver: doneSubject.asObserver(),
            cellSelectionObserver: cellSelectionSubject.asObserver()
        )
        
        let liveChatObservable = liveChatSubject.asObservable().map { _ in
            return SupportCoordinator.Event.goToChat
        }
        
        let backEventObservable = backSubject.asObservable().map { _ in
            return SupportCoordinator.Event.goBack
        }
        
        let doneEventObservable = doneSubject.asObservable().map { _ in
            return SupportCoordinator.Event.goBackToTabView
        }
        
        let scheduleCallbackObservable = scheduleCallbackSubject.asObservable().map { _ in
            return SupportCoordinator.Event.goToScheduleCallback
        }
        
        let viewCompleteObservable = Observable.merge(liveChatObservable,
                                                      scheduleCallbackObservable,
                                                      backEventObservable,
                                                      doneEventObservable)
        output = Output(
            viewComplete: viewCompleteObservable
        )
        
        cellSelectionSubject.subscribe(onNext: {[weak self] indexPath in
            self?.handleCellSelection(for: indexPath)
        }).disposed(by: disposeBag)
    }
}

/// ModifyAppointmentViewModel extension which contains the table datasource functions
extension FAQTopicsViewModel {
    
    /// Handles the cell selection at every perticular tap
    private func handleCellSelection(for indexpath: IndexPath) {
        let section = Section.init(rawValue: indexpath.section)
        
        switch section {
        case .frequentlyAskedQuestions: break
        case .contactUs:
            if indexpath.row == 0 {
                AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.liveChatFAQDetails)
                liveChatSubject.onNext(())
            } else {
                AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.scheduleCallbackFAQDetails)
                scheduleCallbackSubject.onNext(())
            }
        default: break
        }
    }
    
    /// Updates the FAQ sections if it is not expanded
    func updateFAQSection(forIndexpath: IndexPath, isExpanded: Bool) {
        faqTopicData[forIndexpath.row].isAnswerExpanded = !isExpanded
        reloadDataSubject.onNext(())
    }
}
