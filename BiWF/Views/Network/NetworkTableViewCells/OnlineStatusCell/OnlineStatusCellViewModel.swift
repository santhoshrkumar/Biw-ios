//
//  OnlineStatusCellViewModel.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 6/25/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
/*
   OnlineStatusCellViewModel representing the network online status with details
**/
struct OnlineStatusCellViewModel {
    struct Input {
        
    }
    
    /// Output structure
    struct Output {
        let viewModelObservable: Observable<OnlineStatusViewModel>
    }

    /// Input & Output structure variable
    let input: Input
    let output: Output

    /// Initializes a new instance of network repository with
    /// - Parameter networkRepository: min payment value of a task
    ///             type: max payment value of a task
    init(networkRepository: NetworkRepository, type: OnlineStatusViewModel.StatusType) {
        input = Input()
        let onlineStatusViewModel = OnlineStatusViewModel(networkRepository: networkRepository, type: type)
        output = Output(viewModelObservable: .just(onlineStatusViewModel))
    }
}
