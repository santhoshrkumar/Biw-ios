//
//  ConnectedDevicesCell.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/19/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
/*
 ConnectedDevicesCell to show connected devices to the network
 */
class ConnectedDevicesCell: UITableViewCell {
    /// reuse identifier
    static let identifier = "ConnectedDevicesCell"
    
    /// Outlets
    @IBOutlet private var containerView: UIView!
    @IBOutlet var deviceCountLabel: UILabel!
    @IBOutlet var connectedDevicesLabel: UILabel!
    @IBOutlet var tapToViewLabel: UILabel!
    
    /// Holds ConnectedDevicesViewModel with strong reference
    var viewModel: ConnectedDevicesViewModel!
    let disposeBag = DisposeBag()

    /// Initial UI setup
    private func initialSetup() {
        containerView.backgroundColor = UIColor.BiWFColors.lavender.withAlphaComponent(0.06)
        deviceCountLabel.font = .bold(ofSize: UIFont.font24)
        deviceCountLabel.textColor = UIColor.BiWFColors.purple
        connectedDevicesLabel.font = .bold(ofSize: UIFont.font16)
        connectedDevicesLabel.textColor = UIColor.BiWFColors.dark_grey
        tapToViewLabel.font = .bold(ofSize: UIFont.font12)
        tapToViewLabel.textColor = UIColor.BiWFColors.purple
    }
}

/// ConnectedDevicesCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension ConnectedDevicesCell: Bindable {
    func bindViewModel() {
        initialSetup()
        bindOutputs()
    }

    /// Binding all the output observers from viewmodel to get the  values
    private func bindOutputs() {
        viewModel.output.connectedDevicesTextDriver
            .drive(connectedDevicesLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.tapToViewTextDriver
            .drive(tapToViewLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.connectedDeviceCount
            .subscribe(onNext: { (count) in
                DispatchQueue.main.async {
                    self.deviceCountLabel.text = "\(count)"
                }
            })
            .disposed(by: disposeBag)
        
    }
}
