//
//  NotificationTableCellViewModel.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 29/03/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit
/*
 NotificationTableCellViewModel holds what should be there in notification
 */
class NotificationTableCellViewModel {

    /// Variables/Constans
    let name: Driver<String>
    let description: Driver<String>
    let imageUrl: Driver<String>
    let detailUrl: Driver<String>
    let isUnread: Driver<Bool>

    /// Initializes a new instance of detailUrl
    /// - Parameter notification : which holds every values of notification
    init(withNotification notification: Notification) {
        name = .just(notification.name)
        description = .just(notification.description)
        imageUrl = .just(notification.imageUrl)
        detailUrl = .just(notification.detailUrl)
        isUnread = .just(notification.isUnRead)
    }
}
