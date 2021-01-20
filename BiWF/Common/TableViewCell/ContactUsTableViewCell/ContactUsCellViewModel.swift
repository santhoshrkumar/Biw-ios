//
//  File.swift
//  BiWF
//
//  Created by pooja.q.gupta on 09/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
/*
 ContactUsCellViewModel to handle the contact us option
 */
class ContactUsCellViewModel {
    let title: Driver<String>
    let description: Driver<String>
    
    init(with title: String, description: String) {
        self.title = .just(title)
        self.description = .just(description)
    }
}
