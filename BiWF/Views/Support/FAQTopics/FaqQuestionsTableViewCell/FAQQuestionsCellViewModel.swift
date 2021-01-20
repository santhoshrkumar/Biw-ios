//
//  FAQQuestionsCellViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 16/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
/*
FAQQuestionsCellViewModel handles Faq's cells
*/
class FAQQuestionsCellViewModel {
    
    /// Variables/Constants
    let question: Driver<String>
    let cellShouldExpandObserver: Observable<Bool>
    let answer: Driver<NSAttributedString>
    var loadingInitially: Bool = true
    let expandButtonObserver = PublishSubject<Void>()
    
    var isExpanded: Bool
    
    /// Initialize a new instance of FaqRecord
    /// - Parameter content : FaqRecords
    init(withContent content: FaqRecord) {
        question = .just(content.title)
        let data = Data(content.articleContent.utf8)

        if let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil) {
            answer = .just(content.isAnswerExpanded ?? false ? attributedString : NSAttributedString())
        } else { answer = .just(NSAttributedString()) }

        cellShouldExpandObserver = Observable.just(content.isAnswerExpanded ?? false)
        isExpanded = content.isAnswerExpanded ?? false
    }
}
