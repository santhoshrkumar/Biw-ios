//
//  Notification.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 26/03/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxDataSources

struct NotificationsList: Codable {
    let notifications: [Notification]
    
    enum CodingKeys: String, CodingKey {
        case notifications
    }
}

struct Notification: Codable, Equatable {
    let id: Int
    let name: String
    let description: String
    let imageUrl: String
    var isUnRead: Bool
    let detailUrl: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case imageUrl = "imageUrl"
        case isUnRead = "isUnRead"
        case detailUrl = "detailUrl"
    }
}

extension Notification: IdentifiableType {
    var identity: String {
        return self.name
    }
    typealias Identity = String
}

/// TODO: to be removed once data get load from API
extension Notification {
    static func loadFromJson() -> [Notification]? {
        guard let path = Bundle.main.path(forResource: "notifications",
                                          ofType: "json") else { return nil }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path),
                                options: .mappedIfSafe)
            let notification = try JSONDecoder().decode(NotificationsList.self, from: data)
            return notification.notifications
        } catch {
            print(error)
            return nil
        }
    }
}
