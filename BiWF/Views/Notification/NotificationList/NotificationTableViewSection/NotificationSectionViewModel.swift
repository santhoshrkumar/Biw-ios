//
//  NotificationSectionViewModel.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 29/03/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
/*
 ButtonType tells whether clear or mark all notification as read
 */
enum ButtonType: String {
    case clearAll = "Clear all"
    case markAllAsRead = "Mark all as read"
}
/// NotificationSectionViewModel handles the notification section
class NotificationSectionViewModel {

    /// Input Structure
    struct Input {
    }
    
    /// Output Structure
    struct Output {
        var headerTextDriver: Driver<String>
        var buttonTitleTextDriver: Driver<NSAttributedString>
    }
    
    /// Input & Output structure variable
    let input: Input
    let output: Output
    
    private let headerSubject = BehaviorSubject<String>(value: "")
    private let buttonTitleTextSubject = PublishSubject<String>()
    private let notificationsSubject = PublishSubject<[Notification]>()
    private let disposeBag = DisposeBag()
    
    /// Initializes a new instance of header,buttontype and notificationitem
    /// - Parameter header : notiification header
    /// buttonType : clear or mark all as read
    /// notificationItems : array of notification items
    init(withHeader header: String, buttonType: String, notificationItems: [Notification]) {
        input = Input()

        output = Output(
            headerTextDriver: Observable.just(header).asDriver(onErrorJustReturn: header
            ),
            buttonTitleTextDriver: Observable.just(buttonType.attribStringWithUnderline).asDriver(
                onErrorJustReturn: buttonType.attribStringWithUnderline))
    }
}
