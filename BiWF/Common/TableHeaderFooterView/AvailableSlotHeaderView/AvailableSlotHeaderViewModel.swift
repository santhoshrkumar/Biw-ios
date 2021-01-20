//
//  AvailableSlotHeaderViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 06/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
/*
 AvailableSlotHeaderViewModel to handle available slot to book appointment
 */
class AvailableSlotHeaderViewModel {
    
    let title: Driver<String>
    let hideBottomSeperator: Driver<Bool>
    let showErrorMessage: Driver<Bool>

    init(title: String, hideBottomSeperator: Bool = false, showErrorMessage: Bool) {
        self.title = .just(title)
        self.hideBottomSeperator = .just(hideBottomSeperator)
        self.showErrorMessage = .just(!showErrorMessage)
    }
}


