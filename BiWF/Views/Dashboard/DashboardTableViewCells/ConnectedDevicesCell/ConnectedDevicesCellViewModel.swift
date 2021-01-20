//
//  ConnectedDevicesCellViewModel.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/19/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
/*
 ConnectedDevicesViewModel to handle the connected device
 */
struct ConnectedDevicesViewModel {

    /// Output structure
    struct Output {
        let connectedDeviceCount: Observable<Int>
        let connectedDevicesTextDriver: Driver<String>
        let tapToViewTextDriver: Driver<String>
    }

    /// Input/Output structure variables
    let output: Output
    
    /// Initializes a new instance
    init(withConnectedDeviceCount deviceCount: Int) {
        output = Output(connectedDeviceCount: .just(deviceCount),
                        connectedDevicesTextDriver: .just(Constants.ConnectedDevices.connectedDevicesText),
                        tapToViewTextDriver: .just(Constants.ConnectedDevices.tapToViewText)
        )
    }
}
