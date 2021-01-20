//
//  LogoutCellViewModel.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 5/7/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
/*
 LogoutCellViewModel to represent the logout event
 */
struct LogoutCellViewModel {
    
    /// Input structure
    struct Input {
        let logoutTapObserver: AnyObserver<Void>
    }

    /// Output structure
    struct Output {
        let logoutTitleDriver: Driver<String>
        let logoutEventObservable: Observable<Void>
    }

    /// Input & Output structure variable
    let input: Input
    let output: Output

    ///Logout subject for the user to logout
    let logoutEventSubject = PublishSubject<Void>()

    init() {
        input = Input(logoutTapObserver: logoutEventSubject.asObserver())
        output = Output(
            logoutTitleDriver: .just(Constants.Logout.logout.uppercased()),
            logoutEventObservable: logoutEventSubject.asObservable()
        )
    }
}
