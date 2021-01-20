//
//  IndicatorViewModel.swift
//  BiWF
//
//  Created by varun.b.r on 11/11/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
/*
 IndicatorViewModel to handle status loader view
 */
class IndicatorViewModel {
    
    /// Output structure
    struct Output {
        let titleTextDriver: Driver<String?>
        let messageTextDriver: Driver<String?>
    }
    
    /// Output structure variable
    let output: Output
    
    /// init method
    /// - Parameters:
    ///   - title: The title of the view
    ///   - message: The message on the view
    init(withMessage messageText: String?, titleText: String?) {
        output = Output(titleTextDriver: .just(titleText),
                        messageTextDriver: .just(messageText))
    }
}
