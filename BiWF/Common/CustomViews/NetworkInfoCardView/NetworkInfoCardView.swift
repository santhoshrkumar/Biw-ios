//
//  NetworkInfoCardView.swift
//  BiWF
//
//  Created by varun.b.r on 06/11/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
/*
 NetworkInfoCardView to show network information
 */
class NetworkInfoCardView: UIView {
    
    /// Outlets
    @IBOutlet weak var networkInfoCardNameLabel: UILabel! {
        didSet {
            networkInfoCardNameLabel.font = .bold(ofSize: UIFont.font16)
            networkInfoCardNameLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    
    @IBOutlet weak var networkInfoCardHeaderLabel: UILabel! {
        didSet {
            networkInfoCardHeaderLabel.font = .bold(ofSize: UIFont.font16)
            networkInfoCardHeaderLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    
    @IBOutlet weak var tapToZoomLabel: UILabel! {
        didSet {
            tapToZoomLabel.font = .regular(ofSize: UIFont.font12)
            tapToZoomLabel.textColor = UIColor.BiWFColors.med_grey
        }
    }
    @IBOutlet weak var scanLabel: UILabel! {
        didSet {
            scanLabel.font = .regular(ofSize: UIFont.font16)
            scanLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    
    @IBOutlet weak var wifiEnableDisableButton: UIButton!
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    @IBOutlet weak var expandQRCodeButton: UIButton!
    
    /// Holds NetworkInfoCardViewModel with strong reference
    var viewModel: NetworkInfoCardViewModel!
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

/// NetworkInfoCardView extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension NetworkInfoCardView: Bindable {
    
    func bindViewModel() {
        bindInputs()
        bindOutputs()
    }
    
    /// Binding all the input observers from viewmodel to get the events
    func bindInputs() {
        expandQRCodeButton.rx.tap
            .bind(to: viewModel.input.expandQRCodeObserver)
            .disposed(by: disposeBag)
        
        wifiEnableDisableButton.rx.tap
            .bind(to: viewModel.input.networkEnableDisableObserver)
            .disposed(by: disposeBag)
    }
    
    /// Binding all the output observers from viewmodel to get the values
    func bindOutputs() {
        
        viewModel.output.qrCodeImage
            .drive(qrCodeImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.output.networkNameDriver
            .drive(networkInfoCardNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.networkHeaderDriver
            .drive(networkInfoCardHeaderLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.scanToJoinDriver
            .drive(scanLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.tapCodeDriver
            .drive(tapToZoomLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.networkEnableDisableImage
            .drive(wifiEnableDisableButton.rx.image())
            .disposed(by: disposeBag)
    }
}
