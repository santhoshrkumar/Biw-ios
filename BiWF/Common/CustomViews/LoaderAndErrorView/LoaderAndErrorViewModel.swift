//
//  LoaderAndErrorViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 10/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
/*
LoaderAndErrorViewModel to handle status loader view
*/
class LoaderAndErrorViewModel {
    
    /// Output structure
    struct Output {
        let messageTextDriver: Driver<String?>
        let reloadHandlerDriver: Driver<(() -> Void)?>
        let showLoaderObservable: Observable<Bool>
    }
    
    /// Input structure
    struct Input {
        let showLoaderObserver: AnyObserver<Bool> // If you want to show loader then pass true, if error then pass false
    }
    
    /// Input/Output structure variable
    let input: Input
    let output: Output
    
    /// Subject to handle loader status
    private let showLoaderSubject = PublishSubject<Bool>()
    
    
    /// init method
    /// - Parameters:
    ///   - message: The message you want to show with the loader/error
    ///   - reloadHandler: The handler which will be called on refresh click in case of error
    init(with message: String?, reloadHandler: (() -> Void)? = nil) {
    
        input = Input(showLoaderObserver: showLoaderSubject.asObserver())
        
        output = Output(messageTextDriver: .just(message),
                        reloadHandlerDriver: .just(reloadHandler),
                        showLoaderObservable: showLoaderSubject.asObservable())
    }
}
