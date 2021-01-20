//
//  FiberPlanDetailCellViewModel.swift
//  BiWF
//
//  Created by pooja.q.gupta on 06/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
/*
 FiberPlanDetailCellViewModel handles the FiberPlan details
 */
class FiberPlanDetailCellViewModel {
    
    /// Variables/Constants
    let planName: Driver<String?>
    var speed: Driver<String?>
    let detail : Driver<String>
    //TODO: Update price with the API
    private let price = 65
    
    /// Initializes a new instance of FiberPlanInfo
    /// - Parameter FiberPlanInfo: contains all the values of Fiber internet
    init(fiberPlanInfo: FiberPlanInfo) {
        self.planName = .just(fiberPlanInfo.productName)
        self.detail = .just("\(Constants.FiberPlanDetailCell.cardWillBeCharged) $\(fiberPlanInfo.zuoraPrice ?? 0) + \(Constants.FiberPlanDetailCell.taxesAndFees)")
        self.speed = .just("")
        self.speed = fiberPlanInfo.internetSpeed != nil && fiberPlanInfo.internetSpeed?.isEmpty == false ? .just("Speeds \(fiberPlanInfo.internetSpeed?.firstLowercased ?? "")") : .just("")
    }
}
