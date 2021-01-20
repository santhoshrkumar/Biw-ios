//
//  CancelSubscription.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 02/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

struct CancelSubscription: Codable {
    let contactID: String?
    let cancellationReason: String?
    let cancellationComment: String?
    let rating: String?
    var recordTypeID: String?
    let cancellationDate: String?
    //Response parameters
    let caseID: String?
    let status: Bool
    
    enum CodingKeys: String, CodingKey {
        case contactID = "contactID"
        case cancellationReason = "cancellationReason"
        case cancellationComment = "cancellationComment"
        case rating = "rating"
        case recordTypeID = "recordTypeID"
        case cancellationDate = "cancellationDate"
        case caseID = "id"
        case status = "success"
    }
}

