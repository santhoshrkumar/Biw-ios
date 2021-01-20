
//
//  TitleTableViewCellViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 30/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
/*
 TitleTableViewCellViewModel to handle title for tableview cell
 */

class TitleTableViewCellViewModel {
    let title: Driver<String>
    let hideNextImage: Driver<Bool>
    let hideSeperator: Driver<Bool>
    
    init(with title: String, hideNextImage: Bool = false, hideSeperator: Bool = true) {
        self.title = .just(title)
        self.hideNextImage = .just(hideNextImage)
        self.hideSeperator = .just(hideSeperator)
    }
}
