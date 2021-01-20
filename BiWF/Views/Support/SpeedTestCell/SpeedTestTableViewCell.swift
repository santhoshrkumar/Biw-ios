//
//  SpeedTestTableViewCell.swift
//  BiWF
//
//  Created by pooja.q.gupta on 10/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
/*
 SpeedTestTableViewCell to test the speed of the modem
 */
class SpeedTestTableViewCell: UITableViewCell {
    
    /// reuse identifier
    static let identifier = "SpeedTestTableViewCell"
    
    
    ///Outlets
    @IBOutlet weak var speedTestView: SupportSpeedTestView!
    
    /// Holds the SpeedTestCellViewModel with strong reference
    var viewModel: SpeedTestCellViewModel!
    private let disposeBag = DisposeBag()
}

/// SpeedTestTableViewCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension SpeedTestTableViewCell: Bindable {
    func bindViewModel() {
        bindOutput()
    }
    
    /// Binding all the output Observables from viewmodel to get the values
    func bindOutput() {
        viewModel.output.speedTestViewModelObservable.subscribe(onNext: { [weak self] speedTestViewModel in
            guard let self = self else { return }
            self.speedTestView.setViewModel(to: speedTestViewModel)
        }).disposed(by: disposeBag)
    }
}
