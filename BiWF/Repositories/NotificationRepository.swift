//
//  NotificationRepository.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 26/03/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import DPProtocols

struct NotificationRepository: Repository {

    /// TODO: To add notification logic with API integration
    func getNotifications() -> [Notification] {
        return Notification.loadFromJson() ?? [Notification(id: 1,
                                                            name: "CenturyLink Extends Employee Benefits",
                                                            description: "As the COVID-19 outbreak continues to spread across the United States — affecting the livelihoods of millions of workers — CenturyLink is taking an immediate, aggressive, and industry-leading",
                                                            imageUrl: "https://news.centurylink.com/images/ctl-logo-black.svg",
                                                            isUnRead: true,
                                                            detailUrl: "https://news.centurylink.com/news?category=801&l=10")]
    }
}
