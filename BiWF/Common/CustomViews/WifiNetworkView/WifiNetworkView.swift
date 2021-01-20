//
//  WifiNetworkView.swift
//  BiWF
//
//  Created by pooja.q.gupta on 30/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
/*
WifiNetworkView to show network information
*/
class WifiNetworkView: UIView {
    
    /// Outlets
    @IBOutlet weak var qrCodeImageView: UIImageView!
   @IBOutlet weak var networkEnableDisableButton: UIButton!
    @IBOutlet weak var scanLabel: UILabel! {
        didSet {
            scanLabel.font = .regular(ofSize: UIFont.font14)
            scanLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var networkNameLabel: UILabel! {
        didSet {
            networkNameLabel.font = .bold(ofSize: UIFont.font14)
            networkNameLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var tapToZoomLabel: UILabel! {
        didSet {
            tapToZoomLabel.font = .regular(ofSize: UIFont.font12)
            tapToZoomLabel.textColor = UIColor.BiWFColors.med_grey
        }
    }
    
    @IBOutlet weak var expandQRCodeButton: UIButton! 
    
    /// Holds WifiNetworkViewModel with strong reference
    var viewModel: WifiNetworkViewModel!
    private let disposeBag = DisposeBag()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        loadFromNib()
        self.layoutIfNeeded()
    }
}

/// WifiNetworkView extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension WifiNetworkView: Bindable {
    func bindViewModel() {
        bindInputs()
        bindOutputs()
    }
    
    /// Binding all the input observers from viewmodel to get the events
    func bindInputs() {
        expandQRCodeButton.rx.tap
            .bind(to: viewModel.input.expandQRCodeObserver)
            .disposed(by: disposeBag)
        networkEnableDisableButton.rx.tap
            .bind(to: viewModel.input.networkEnableDisableObserver)
            .disposed(by: disposeBag)
    }
    
    /// Binding all the output observers from viewmodel to get the values
    func bindOutputs() {
        viewModel.output.networkNameDriver
            .drive(networkNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.scanToJoinDriver
            .drive(scanLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.tapCodeDriver
            .drive(tapToZoomLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.qrCodeImage
            .drive(qrCodeImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.output.networkEnableDisableImage
            .drive(networkEnableDisableButton.rx.image())
        .disposed(by: disposeBag)
    }
}
