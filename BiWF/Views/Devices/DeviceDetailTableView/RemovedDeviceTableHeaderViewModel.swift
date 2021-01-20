//
//  RemovedDeviceTableHeaderViewModel.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 18/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RemovedDeviceTableHeaderViewModel {

    struct Input {
    }
    
    /// Output structure
    struct Output {
        var headerTextDriver: Driver<String>
        var subHeaderTextDriver: Driver<String>
    }
    
    /// Input & Output structure variable
    let input: Input
    let output: Output
    
    /// Subject for header and subheader text
    private let headerSubject = BehaviorSubject<String>(value: "")
    private let subHeaderTextSubject = BehaviorSubject<String>(value: "")
    private let disposeBag = DisposeBag()
    
    /// Initializes a new instance of Removed Device Table sHeader viewmodel with
    init() {
        input = Input()
        output = Output(
            headerTextDriver: .just(Constants.Device.removedDevicesHeader),
            subHeaderTextDriver: .just(Constants.Device.tapToRestore)
        )
    }
}


