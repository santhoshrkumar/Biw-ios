//
//  DashboardSpeedTestCell.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/17/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
/*
 DashboardSpeedTestCell shows the speed test on dashboard
 */
class DashboardSpeedTestCell: UITableViewCell {

    /// reuse identifier
    static let identifier = "DashboardSpeedTestCell"
    
    /// Outlets
    @IBOutlet private var speedTestView: SpeedTestView!

    /// Holds DashboardSpeedTestCellViewModel with strong reference
    var viewModel: DashboardSpeedTestCellViewModel!
    let disposeBag = DisposeBag()
}

/// DashboardSpeedTestCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension DashboardSpeedTestCell: Bindable {
    
    /// Binding all the input and output observers from viewmodel to get the events and values
    func bindViewModel() {
        viewModel.output.speedTestViewModelObservable
            .subscribe(onNext: { [weak self] speedTestViewModel in
                guard let self = self else { return }
                self.speedTestView.setViewModel(to: speedTestViewModel)
            }).disposed(by: disposeBag)
    }
    
    
}
