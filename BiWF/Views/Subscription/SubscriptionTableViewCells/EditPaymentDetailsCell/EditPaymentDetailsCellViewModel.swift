//
//  EditPaymentDetailsCellViewModel.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 6/8/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
/*
 EditPaymentDetailsCellViewModel handles edited payment details
 */
struct EditPaymentDetailsCellViewModel {
    
    /// Input Structure
    struct Input {
        
    }

    /// Output Structure
    struct Output {
        let urlStringDriver: Driver<String>
    }

    /// Input & Output structure variable
    let input: Input
    let output: Output

    /// Initializes a new instance
    init() {
        input = Input()
        output = Output(urlStringDriver: .just(Constants.EditPayment.editPaymentURL+(ServiceManager.shared.userID ?? "")))
    }
}
