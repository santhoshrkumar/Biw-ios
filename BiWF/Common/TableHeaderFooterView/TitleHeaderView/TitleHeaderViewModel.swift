
//
//  TitleHeaderViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 10/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxCocoa
import RxSwift
/*
 TitleHeaderViewModel to handle title header to the tableview
 */
class TitleHeaderViewModel {
    
    let title: Driver<String>
    let subtitle: Driver<NSAttributedString>
    let hideSubtitle: Driver<Bool>
    let hideTopSeperator: Driver<Bool>
    let hideBottomSeperator: Driver<Bool>
    
    /// Initializes a new instance
    /// - Parameter title : title of the table
    /// subtitle : subtitle
    /// hideTopSeperator : Bool
    /// hideBottomSeperator : Bool
    init(title: String, subtitle: NSAttributedString = NSAttributedString(), hideTopSeperator: Bool, hideBottomSeperator: Bool) {
        self.title = .just(title)
        self.subtitle = .just(subtitle)
        self.hideSubtitle = .just(subtitle.length < 0)
        self.hideTopSeperator = .just(hideTopSeperator)
        self.hideBottomSeperator = .just(hideBottomSeperator)
    }
}
