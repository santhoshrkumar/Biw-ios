//
//  UserDetails.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 07/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

struct UserDetails: Codable {
    let lastName: String?
    let firstName: String?
    let userName: String?
    let email: String?
    let accountID: String?
    let contactID: String?
    let name: String?
    let userID: String?
    
    enum CodingKeys: String, CodingKey {
        case lastName = "LastName"
        case firstName = "FirstName"
        case userName = "Username"
        case name = "Name"
        case email = "Email"
        case accountID = "AccountId"
        case contactID = "ContactId"
        case userID = "Id"
    }
}
