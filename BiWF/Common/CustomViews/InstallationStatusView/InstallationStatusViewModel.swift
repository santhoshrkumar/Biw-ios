//
//  InstallationStatusViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 21/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class InstallationStatusViewModel {
    
    let title: Driver<String>
    let status: Driver<String>
    let state: Driver<InstallationState>
    
    init(with title: String, status: String, state: InstallationState) {
        self.title = .just(title)
        self.status = .just(status)
        self.state = .just(state)
    }
}
