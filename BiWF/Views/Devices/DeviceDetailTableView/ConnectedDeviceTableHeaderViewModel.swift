//
//  ConnectedDeviceTableHeaderViewModel.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 18/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
/**
View model for Connected Device Table Header
*/
class ConnectedDeviceTableHeaderViewModel {
    
    struct Input {
    }
    
    /// Output structure
    struct Output {
        var headerTextDriver: Driver<String>
        var countTextDriver: Driver<String>
        var buttonTitleTextDriver: Driver<NSAttributedString>
    }
    
    /// Input & Output structure variable
    let input: Input
    let output: Output
    
    /// Subject to expand or collapse device list
    let shouldExpandSubject = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    var isExpanded: Bool = false
    
    /// Initializes a new instance of Connected Device Table Heade viewmodel with
    /// - Parameter ConnectedDeviceCount: Number of  connected devices
    ///             isExpanded: state of view whether it is expanded or collapse
    init(withConnectedDeviceCount count: Int, isExpanded: Bool) {
        input = Input()
        
        output = Output(
            headerTextDriver: .just(Constants.Device.connectedDeviceHeader),
            countTextDriver: .just("\(count)"),
            buttonTitleTextDriver: .just("".attributedString())
        )
        self.isExpanded = isExpanded
    }
}

