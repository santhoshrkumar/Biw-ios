//
//  SupportBtnViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 26/03/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
/*
    SupportButtonViewModel to handle support events
**/
struct SupportButtonViewModel {
    
    /// Output structure  lo handle output events
    struct Output {
        let viewComplete: Observable<TabCoordinator.Event>
    }
    
    /// Input structure to handle input events
    struct Input {
        let tapObserver: AnyObserver<Void>
    }
    
    ///Subject to handle support button tap
    private let tapSubject = PublishSubject<Void>()
    
    /// Input/Output structure variables
    let output: Output
    let input: Input
    
    /// Initializes a new instance of SupportButtonViewModel
    init() {
        input = Input(
            tapObserver: tapSubject.asObserver()
        )
        
        let tapEventObservable = tapSubject.asObserver().map { _  in
            return TabCoordinator.Event.goToSupport
        }
        
        output = Output(
            viewComplete: tapEventObservable
        )
    }
}
