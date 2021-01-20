//
//  FeedBackCellViewModel.swift
//  BiWF
//
//  Created by varun.b.r on 19/11/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
/*
FeedBackCellViewModel handles the customer feedback on dashboard
*/
class FeedBackCellViewModel {
    
    /// Output structure
    struct Output {
        let feedbackTitleDriver : Driver<String>
    }
    
    ///Output structure variable
    let output : Output
    
    /// Initializer
    init() {
        output = Output(feedbackTitleDriver: .just(Constants.DashboardContainer.customerFeedBack))

    }
}
