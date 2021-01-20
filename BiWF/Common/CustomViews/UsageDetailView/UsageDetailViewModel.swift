//
//  UsageDetailViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 23/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
/*
UsageDetailViewModel to handle usage details information
*/
class UsageDetailViewModel {
    
    /// Output structure
    struct Output {
        let downloadDetailsDriver: Driver<String>
        let downloadUnitDriver: Driver<String>
        let uploadDetailsDriver: Driver<String>
        let uploadUnitDriver: Driver<String>
    }
    
    /// Output structure variable
    let output: Output
    
    /// Initializes a new instance of WiFiNetwork
    /// - Parameter usageDetail : contains all values of usageDetail
    /// isPaused : device is paused or not
    init(with usageDetail: UsageDetailsList, isPaused: Bool) {
        let uploadUsage = usageDetail.getUploadUsage()
        let downloadUsage = usageDetail.getDownloadUsage()
        
        output = Output(downloadDetailsDriver: .just((isPaused ? "- -" : downloadUsage.value)),
                        downloadUnitDriver: .just("\(downloadUsage.unit)\n\(Constants.UsageDetails.download)"),
                        uploadDetailsDriver: .just((isPaused ? "- -" : uploadUsage.value)),
                        uploadUnitDriver: .just("\(uploadUsage.unit)\n\(Constants.UsageDetails.upload)"))
    }
}
