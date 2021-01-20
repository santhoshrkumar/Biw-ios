//
//  FaqCellViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 09/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
/*
 FAQTableViewCell to handle FAQ option
*/
class FaqCellViewModel {
    let title: Driver<String>
    
    init(with faqTopic: FaqRecord) {
        title = .just(faqTopic.attributes.url)
    }
}
