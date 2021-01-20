
//
//  Faq.swift
//  BiWF
//
//  Created by pooja.q.gupta on 09/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxDataSources

struct FaqList: Codable  {
    
    let records: [FaqRecord]
    let done: Bool
    let totalSize: Int
    
    enum CodingKeys: String, CodingKey {
        case records = "records"
        case done = "done"
        case totalSize = "totalSize"
    }
    
    func getFaqSectionList() -> [FaqRecord] {
        let filteredArray = self.records.filter({ $0.sectionC != nil })
        return filteredArray
    }
}

struct FaqRecord: Codable {
    let attributes: FaqRecordAttributes
    let articleNumber: String
    let articleTotalViewCount: Int
    let articleContent: String
    let articleUrl: String
    let Id: String
    let language: String
    let sectionC: String?
    let title: String
    var isAnswerExpanded: Bool?
    
    enum CodingKeys: String, CodingKey {
        case attributes = "attributes"
        case articleNumber = "ArticleNumber"
        case articleTotalViewCount = "ArticleTotalViewCount"
        case articleContent = "Article_Content__c"
        case articleUrl = "Article_Url__c"
        case Id = "Id"
        case language = "Language"
        case sectionC = "Section__c"
        case title = "Title"
        case isAnswerExpanded = "isAnswerExpanded"
    }
}

struct FaqRecordAttributes: Codable, Equatable {
    let type: String
    let url: String
}
