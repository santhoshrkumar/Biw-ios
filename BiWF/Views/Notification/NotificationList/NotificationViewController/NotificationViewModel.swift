//
//  NotificationViewModel.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 26/03/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
/*
 NotificationViewModel to handle notificaation section
 */
class NotificationViewModel {
    
    /// Constants
    private enum Constants {
        static let titleText = "Notifications".localized
        static let notificationHistoryHeaderText = "Notification history".localized
        static let unreadNotificationHeaderText = "Unread notifications".localized
    }
    
    /// Input structure
    struct Input {
        let dataSourceObserver: AnyObserver<[Notification]>
        let openDetailsObserver: AnyObserver<String>?
        let closeObserver: AnyObserver<Void>
    }
    
    ///Output structure
    struct Output {
        let titleTextDriver: Driver<String>
        let dataSourceDriver: Driver<[Notification]>
        let viewComplete: Observable<NotificationCoordinator.Event>
    }
    
    /// Input & Output structure variable
    let input: Input
    let output: Output
    
    /// Subject to handle data source button tap
    private let dataSourceSubject =  PublishSubject<[Notification]>()
    
    /// Subject to handle close button tap
    private let closeSubject = PublishSubject<Void>()
    
    /// Subject to handle open details button tap
    private let openDetailsSubject = PublishSubject<String>()
    var sections = BehaviorSubject(value: [NotificationTableDataSource]())
    var sectionHeader = BehaviorSubject(value: String())
    private let disposeBag = DisposeBag()
    
    /// Initializes a new instance of detailUrl
    /// - Parameter repository : NotificationRepository to et notification via API call
    init(withRepository repository: NotificationRepository) {
        input = Input(
            dataSourceObserver: dataSourceSubject.asObserver(),
            openDetailsObserver: openDetailsSubject.asObserver(),
            closeObserver: closeSubject.asObserver()
        )
        let closeEventObservable = closeSubject.asObservable().map { _ in
            return NotificationCoordinator.Event.goBackToTabView
        }
        let openDetailsEventObservable = openDetailsSubject.asObservable().map { (detailUrl) -> NotificationCoordinator.Event in
            return NotificationCoordinator.Event.goToDetails(detailUrl)
        }
        
        let dataSourceObservable = dataSourceSubject.asObservable().map { _ in
            return NotificationCoordinator.Event.goBackToTabView
        }
        
        let viewCompleteObservable = Observable.merge(closeEventObservable,
                                                      openDetailsEventObservable,
                                                      dataSourceObservable)
        
        let notificationsList = NotificationViewModel.getNotifications(repository: repository)
        
        output = Output(
            titleTextDriver: Observable.just(Constants.titleText).asDriver(onErrorJustReturn: Constants.titleText),
            dataSourceDriver: Observable.just(notificationsList).asDriver(onErrorJustReturn: notificationsList),
            viewComplete: viewCompleteObservable)
        sections.onNext(self.getSections())
    }
    
    ///TODO: To be updated as per response after API integration
    static func getNotifications(repository: NotificationRepository) -> [Notification] {
        return repository.getNotifications()
    }
    
    /// Get initial section structure
    func getSections() -> [NotificationTableDataSource] {
        
        let notificationList = NotificationViewModel.getNotifications(repository: NotificationRepository())
        
        let unreadNotifications = notificationList.filter { $0.isUnRead == true }
        let readNotifications = notificationList.filter { $0.isUnRead == false }
        
        let headerText = String(format:Constants.unreadNotificationHeaderText, unreadNotifications.count)
        sectionHeader.onNext(headerText)
        
        let sections = [NotificationTableDataSource(header: headerText,
                                                    items: unreadNotifications,
                                                    notificationSectionViewModel: NotificationSectionViewModel(
                                                        withHeader: headerText,
                                                        buttonType: ButtonType.markAllAsRead.rawValue,
                                                        notificationItems: unreadNotifications)),
                        NotificationTableDataSource(header: Constants.notificationHistoryHeaderText,
                                                    items: readNotifications,
                                                    notificationSectionViewModel: NotificationSectionViewModel(
                                                        withHeader: Constants.notificationHistoryHeaderText,
                                                        buttonType: ButtonType.clearAll.rawValue,
                                                        notificationItems: readNotifications))]
        return sections
    }
    
    /// Gives unread notifications count
    func getUnreadNotificationsCount(allSections: [NotificationTableDataSource]) {
        let filteredSections =  allSections.compactMap{$0.items.filter { $0.isUnRead == true }}
        if allSections.count > 0 {
            if filteredSections[0].count > 0 {
                let updatedUnreadHeader = String(format:Constants.unreadNotificationHeaderText, filteredSections[0].count)
                sectionHeader.onNext(updatedUnreadHeader)
            }
        }
    }
    
    /// Delete item
    func removeItem(at indexPath: IndexPath) {
        
        guard var allSections = try? sections.value() else { return }
        var items = allSections[indexPath.section].items
        items.remove(at: indexPath.row)
        if items.count <= 0 {
            allSections.remove(at: indexPath.section)
        } else {
            allSections[indexPath.section] = NotificationTableDataSource(original: allSections[indexPath.section],
                                                                         items: items)
        }

        getUnreadNotificationsCount(allSections: allSections)
        // Inform your subject with the new changes
        sections.onNext(allSections)
    }
    
    /// Mark all as read and clear all functionality
    func editAction(section: Int, buttonType: ButtonType) {
        
        guard var allSections = try? sections.value() else { return }
        let updatedSection = (allSections.count == 1 ? 0 : section)
        
        switch buttonType {
        /// Clear all
        case .clearAll:
            allSections.remove(at: updatedSection)
            
        /// Mark all as read
        case .markAllAsRead:
            var items = allSections[updatedSection].items
            items = items.map { var unreadNotifications = $0
                if $0.isUnRead == true { unreadNotifications.isUnRead = false }
                return unreadNotifications
            }
            allSections.remove(at: updatedSection)
            if allSections.count == 0 {
                allSections = [getClearAllSection()]
                allSections[updatedSection].items = items
            } else {
                let allReadItems = allSections[updatedSection].items + items
                allSections[updatedSection] = NotificationTableDataSource(original: allSections[updatedSection],
                                                                          items: allReadItems)
            }
        }
        getUnreadNotificationsCount(allSections: allSections)
        // Inform your subject with the new changes
        sections.onNext(allSections)
    }
    
    /// Update notification to unread true once it get open
    func updateNotification(indexPath: IndexPath) -> String? {
        var updateSections = try? self.sections.value()
        guard var notification = updateSections?[indexPath.section].items[indexPath.row] else {
            return nil
        }
        if notification.isUnRead == true  {
            notification.isUnRead = false
            updateSections?[indexPath.section].items.remove(at: indexPath.row)
            if updateSections?.count ?? 0 == 1 {
                updateSections?.append(getClearAllSection())
            }
            updateSections?[indexPath.section+1].items.append(notification)
            let items = updateSections?[indexPath.section].items
            if items?.count ?? 0 == 0 {
                updateSections?.remove(at: indexPath.section)
            }
            getUnreadNotificationsCount(allSections: updateSections ?? [NotificationTableDataSource]())
            sections.onNext(updateSections ?? [NotificationTableDataSource]())
            return notification.detailUrl
        }
        return nil
    }
    
    func getClearAllSection() -> NotificationTableDataSource {
        var allSections = getSections()
        allSections.remove(at: 0)
        allSections[0].items.removeAll()
        return allSections[0]
    }
}
