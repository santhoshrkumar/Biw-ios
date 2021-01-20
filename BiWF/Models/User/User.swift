//
//  User.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 14/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

struct User: Codable {
    let recentItems: [recentItem]?
    
    enum CodingKeys: String, CodingKey {
        case recentItems = "recentItems"
    }
}

struct recentItem: Codable {
    let id: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
}
