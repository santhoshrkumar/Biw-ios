//
//  Double+Extensions.swift
//  BiWF
//
//  Created by pooja.q.gupta on 19/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

extension Double {
    func getUsageAndUnit() -> DataUsage {
        if self <= 999 {
            /// 1MB until 999MB
            return DataUsage.init(value: String(format: "%.0f", self), unit: Constants.Common.mb)
        } else if (self > 999 && self <= 999000) {
            /// 1GB until 999GB
            return DataUsage.init(value: String(format: "%.1f", self/1000), unit: Constants.Common.gb)
        } else {
            return DataUsage.init(value: String(format: "%.1f", self/1000000), unit: Constants.Common.tb)
        }
    }
}
