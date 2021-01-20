
//
//  SupportViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 08/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import DPProtocols
import UIKit
/*
 SupportViewModel handles the Support events
 */
class SupportViewModel {
    
    /// Section to select a perticular section
    enum Section: Int {
        case faq = 0
        case troubleShooting
        case contactUs
    }
    
    /// Input structure
    struct Input {
        let runSpeedTestObserver: AnyObserver<Void>
        var restartModem: AnyObserver<Void>
        let callUsObserver: AnyObserver<Void>
        let visitWebsiteObserver: AnyObserver<Void>
        let scheduleCallbackObserver: AnyObserver<Void>
        let liveChatObserver: AnyObserver<Void>
        let closeObserver: AnyObserver<Void>
        let cellSelectionObserver: AnyObserver<IndexPath>
        let goToFaqObserver: AnyObserver<[FaqRecord]>
    }
    
    /// Output structure
    struct Output {
        let callUsAtTextDriver: Driver<NSAttributedString>
        let viewComplete: Observable<SupportCoordinator.Event>
        let viewStatusObservable: Observable<ViewStatus>
    }
    
    /// Input & Output structure variable
    let input: Input
    let output: Output
    
    /// Subject to handle run speed test
    private let runSpeedTestSubject = PublishSubject<Void>()
    
    /// Subject to handle  restart modem
    private let restartModemSubject = PublishSubject<Void>()
    
    /// Subject to handle callus button tap
    private let callUsSubject = PublishSubject<Void>()
    
    /// Subject to handle visit website tap
    private let visitWebsiteSubject = PublishSubject<Void>()
    
    /// Subject to handle schedule callback cell tap
    private let scheduleCallbackSubject = PublishSubject<Void>()
    
    /// Subject to handle livechat cell tap
    private let liveChatSubject = PublishSubject<Void>()
    
    /// Subject to handle close button tap
    private let closeSubject = PublishSubject<Void>()
    
    /// Subject to handle with each cell selection
    private let cellSelectionSubject = PublishSubject<IndexPath>()
    
    /// Subject to handle Faq cell
    private let goToFaqSubject = PublishSubject<[FaqRecord]>()
    
    /// Subject to handle viewstatus
    private let viewStatusSubject = PublishSubject<ViewStatus>()
    
    ///Variables/Constants
    private let disposeBag = DisposeBag()
    var sections = BehaviorSubject(value: [TableDataSource]())
    
    /// Holds SupportRepository with strong reference
    let repository: SupportRepository
    
    /// Holds NetworkRepository with strong reference
    let networkRepository: NetworkRepository
    var faqRecords: [FaqRecord]?
    
    /// Holds ContactUs with strong reference
    let contactUsData: ContactUs
    
    let title = Constants.Support.titleText
    private var subHeader = Constants.SpeedTest.lastTestText.attributedString(with: .bold(ofSize: UIFont.font12), textColor: .gray)
    var shouldShowSpeeedTest = false
    
    /// Initialize a new instance of SupportRepository and NetworkRepository
    /// - Parameter SupportRepository : gives the api values with respect to support
    /// networkRepository : gives the network api values about the modem
    init(with repository: SupportRepository, and networkRepository: NetworkRepository) {
        self.repository = repository
        self.networkRepository = networkRepository
        contactUsData = repository.getContactUsOptions()
        
        input = Input(
            runSpeedTestObserver: runSpeedTestSubject.asObserver(),
            restartModem: restartModemSubject.asObserver(),
            callUsObserver: callUsSubject.asObserver(),
            visitWebsiteObserver: visitWebsiteSubject.asObserver(),
            scheduleCallbackObserver: scheduleCallbackSubject.asObserver(),
            liveChatObserver: liveChatSubject.asObserver(),
            closeObserver: closeSubject.asObserver(),
            cellSelectionObserver: cellSelectionSubject.asObserver(),
            goToFaqObserver: goToFaqSubject.asObserver()
        )
        
        let visitWebsiteObservable = visitWebsiteSubject.asObservable().map { _ in
            return SupportCoordinator.Event.goToWebsite
        }
        
        let liveChatObservable = liveChatSubject.asObservable().map { _ in
            return SupportCoordinator.Event.goToChat
        }
        
        let closeEventObservable = closeSubject.asObservable().map { _ in
            return SupportCoordinator.Event.goBackToTabView
        }
        
        let scheduleCallbackObservable = scheduleCallbackSubject.asObservable().map { _ in
            return SupportCoordinator.Event.goToScheduleCallback
        }
        
        let goToFaqObservable = goToFaqSubject.asObservable().map { faqTopic in
            return SupportCoordinator.Event.goToFaq(faqTopic)
        }
        
        let viewCompleteObservable = Observable.merge(visitWebsiteObservable,
                                                      liveChatObservable,
                                                      scheduleCallbackObservable,
                                                      closeEventObservable,
                                                      goToFaqObservable)
        
        output = Output(callUsAtTextDriver: .just(Constants.Support.callUsText.attribStringWithUnderline),
                        viewComplete: viewCompleteObservable,
                        viewStatusObservable: viewStatusSubject.asObservable()
        )
        self.getFaqList()
        
        runSpeedTestSubject.subscribe(onNext: { _ in
            networkRepository.runSpeedTest()
        }).disposed(by: disposeBag)
        
        restartModemSubject.subscribe(onNext: { _ in
            networkRepository.restartModem()
        }).disposed(by: disposeBag)
        
        callUsSubject.subscribe(onNext: { _ in
            print("Call us at event")
        }).disposed(by: disposeBag)
        
        cellSelectionSubject.subscribe(onNext: {[weak self] indexPath in
            self?.handleCellSelection(for: indexPath)
        }).disposed(by: disposeBag)
                
        self.networkRepository.speedTestSubject.subscribe(onNext: { (speedTest) in
            let lastSpeedTest = Constants.SpeedTest.lastTestText.attributedString(with: .bold(ofSize: UIFont.font12), textColor: .gray)
            let lastSpeedTestTDateTime = (speedTest?.formattedTime ?? "- -").attributedString(with: .regular(ofSize: UIFont.font12), textColor: .gray)
            lastSpeedTest.append(lastSpeedTestTDateTime)
            self.subHeader = lastSpeedTest
            self.setSections()
        }).disposed(by: disposeBag)
        
        self.networkRepository.isSpeedTestEnableSubject.subscribe(onNext: { (show) in
            self.shouldShowSpeeedTest = show
            self.setSections()
        }).disposed(by: disposeBag)
    }
}

/// SupportViewModel extension which holds tableView events
extension SupportViewModel {
    
    /// Set the table view sections
    func setSections() {
        sections.onNext(getSections())
    }
    
    /// Get the tableview sections and returns array of tableDataSource
    func getSections() -> [TableDataSource] {
        
        if let appointment = AppointmentRepository.isInsatllationAppointment, appointment {
            return [faqSectionData(), contactusSectionData()]
        }
        
        return [faqSectionData(),
                self.shouldShowSpeeedTest ? troubleshootingSectionData() : restartModemWithoutSpeedTestSectionData(),
                contactusSectionData()]
    }
    
    /// appends the newly created faq topic with existing faq's
    private func faqSectionData() -> TableDataSource {
        var items = [Item]()
        let topics = uniqueTopicsInFAQList()
        items = topics.compactMap { [weak self] topic -> Item? in
            guard let self = self else { return nil }
            return self.createTopicItem(withKey: topic)
        }
        return TableDataSource(header: Constants.Support.faqTopics,
                               items: items)
    }

    private func uniqueTopicsInFAQList() -> [String] {
        var topics = [String]()
        guard let records = faqRecords else { return topics }

        records.forEach {
            guard let topic = $0.sectionC else { return }
            if !topics.contains(topic) {
                topics.append(topic)
            }
        }

        return topics
    }
    
    /// Used to create a new FAQ topic
    /// - Parameter Key: String
    func createTopicItem(withKey key: String) -> Item {
        return Item.init(identifier: TitleTableViewCell.identifier,
                         viewModel: TitleTableViewCellViewModel(with: key,
                                                                hideNextImage: false,
                                                                hideSeperator: false))
    }
    
    /// Handles if any problem occures during speed test
    private func troubleshootingSectionData() -> TableDataSource {
        let speedTestViewModel = SpeedTestCellViewModel(with: networkRepository)
        
        speedTestViewModel.restartModemSubject.subscribe(onNext: {[weak self] _ in
            self?.restartModemSubject.onNext(())
        }).disposed(by: disposeBag)
        
        speedTestViewModel.visitWebsiteSubject.subscribe(onNext: {[weak self] _ in
            self?.visitWebsiteSubject.onNext(())
        }).disposed(by: disposeBag)
        
        speedTestViewModel.runSpeedTestSubject.subscribe(onNext: {[weak self] _ in
            self?.runSpeedTestSubject.onNext(())
        }).disposed(by: disposeBag)
        
        let troubleShootingRowData = [Item(identifier: SpeedTestTableViewCell.identifier,
                                           viewModel: speedTestViewModel)]
         return TableDataSource(header: Constants.Support.troubleshooting, subHeader: subHeader, items: troubleShootingRowData)
    }
    
    /// Handles if any problem occures during speed test
    private func restartModemWithoutSpeedTestSectionData() -> TableDataSource {
        let troubleShootingRowData = [Item(identifier: RestartModemTableViewCell.identifier,
                                           viewModel: RestartModemViewModel(networkRepository: networkRepository))]
        return TableDataSource(header: Constants.Support.troubleshooting, subHeader: Constants.Support.restartModemTroubleshooting.attributedString(with: .regular(ofSize: UIFont.font12), textColor: UIColor.BiWFColors.med_grey), items: troubleShootingRowData)
    }
    
    /// get all the FAQ api values from the repository
    private func getFaqList() {
        let loading = ViewStatus.loading(loadingText: Constants.Common.loading)
        viewStatusSubject.onNext(loading)
        repository.recordIDResult
            .subscribe({ id in
                do {
                    self.repository.faqListResult
                        .subscribe(onNext: { details in
                            self.viewStatusSubject.onNext(ViewStatus.loaded)
                            self.faqRecords = details.getFaqSectionList()
                            self.setSections()
                        }).disposed(by: self.disposeBag)
                    self.repository.getFaqTopics(forRecordID: id.element ?? "")
                    AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.recordTypeIDSuccess)
                }
            }).disposed(by: self.disposeBag)
        repository.errorMessage
            .subscribe(onNext: {[weak self] error in
                let error = ViewStatus.error(errorMsg: "\(error.count == 0 ? Constants.Common.errorLoadingInformation : error)\n \(Constants.Common.tapToRetry)") {
                    self?.getFaqList()
                }
                self?.viewStatusSubject.onNext(error)
                AnalyticsEvents.trackAPICallEvent(with: AnalyticsConstants.EventAPICall.recordTypeIDFailure)
        }).disposed(by: self.disposeBag)
        repository.getRecordID()
    }
    
    /// Get all the contactus sections and appends with scheduleCallbackTimings
    private func contactusSectionData() -> TableDataSource {
        var contactUsRowData = [Item(identifier: ContactUsTableViewCell.identifier,
                                     viewModel: ContactUsCellViewModel(with: Constants.Support.liveChat,
                                                                       description: contactUsData.liveChatTimings))]
        contactUsRowData.append(Item(identifier: ContactUsTableViewCell.identifier,
                                     viewModel: ContactUsCellViewModel(with: Constants.Support.scheduleCallback,
                                                                       description: contactUsData.scheduleCallbackTimings)))
        return TableDataSource(header: Constants.Support.contactUs,
                               items: contactUsRowData)
    }
    
    /// Handles the cell selection at every perticular tap
    func handleCellSelection(for indexpath: IndexPath) {
        let section = Section.init(rawValue: indexpath.section)
        
        switch section {
            /// executes when user selects faq section
        case .faq:
            guard let faqList = faqRecords else { return }
            AnalyticsEvents.trackListItemTappedEvent(with: AnalyticsConstants.EventListItemName.FAQListItem)

            let topics = uniqueTopicsInFAQList()

            if topics.count > indexpath.row {
                let topic = topics[indexpath.row]

                let records = faqList.filter { $0.sectionC == topic }
                if records.count > 0 {
                    goToFaqSubject.onNext(records)
                }
            }
            
            /// executes when user selects contactus section
        case .contactUs:
            if indexpath.row == 0 {
                AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.liveChatSupport)
                liveChatSubject.onNext(())
            } else {
                AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.scheduleCallbackSupport)
                scheduleCallbackSubject.onNext(())
            }
        default:
            break
        }
    }
    
    /// This method will handle if top and bottom sperator will hidden or shown
    /// - Parameter section: section
    func handleSeperator(for section: Int) -> (Bool, Bool) {
        var supportSection = Section(rawValue: section)
        var hideTopBottomSeperator: (Bool, Bool)  = (false, false)
        
        supportSection = (supportSection == .troubleShooting && (AppointmentRepository.isInsatllationAppointment ?? false)) ? .contactUs : supportSection
        
        switch supportSection {
        case .faq:
            hideTopBottomSeperator = (true, false)
            
        case .troubleShooting:
            hideTopBottomSeperator = (false, true)
            
        case .contactUs:
            hideTopBottomSeperator = (true, false)
            
        case .none:
            hideTopBottomSeperator = (false, false)
        }
        return hideTopBottomSeperator
    }
}
