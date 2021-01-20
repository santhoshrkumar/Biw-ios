//
//  DashboardNetworkCellViewModel.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 6/25/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa

/*
DashboardNetworkCellViewModel handles the dashboard network
*/
struct DashboardNetworkCellViewModel {
    
    /// Input structure
    struct Input {
    }

    /// Output structure
    struct Output {
        let titleLabelTextDriver: Driver<String>
        let tapToEditButtonTextDriver: Driver<String>
    }

    /// Input/Output structure variables
    let input: Input
    let output: Output

    // Initializes a new instances
    init() {
        input = Input()
        output = Output(
            titleLabelTextDriver: .just(Constants.NetworkInfo.networkInformation),
            tapToEditButtonTextDriver: .just(Constants.NetworkInfo.tapToEditNetwork))
    }
}
