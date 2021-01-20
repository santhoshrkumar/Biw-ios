//
//  NotificationTableDataSource.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 01/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxDataSources
import UIKit
import RxSwift
import DPProtocols
/*
 NotificationTableDataSource holds header and items of notificationtype
 */
struct NotificationTableDataSource {
    var header: String
    var items: [Item]
    var notificationSectionViewModel: NotificationSectionViewModel
}
 
/// NotificationTableDataSource confirming to AnimatableSectionModelType protocol
extension NotificationTableDataSource: AnimatableSectionModelType {
    var identity: String {
        return header
    }
    typealias Item = Notification

    init(original: NotificationTableDataSource, items: [Item]) {
        self = original
        self.items = items
        self.notificationSectionViewModel = original.notificationSectionViewModel
    }
}
