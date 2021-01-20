//
//  QRCodeViewController.swift
//  BiWF
//
//  Created by Amruta Mali on 03/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
import RxDataSources
/*
 QRCodeViewController to show qrcode
 */
class QRCodeViewController: UIViewController, Storyboardable {
    
    /// Outlets
    @IBOutlet private var qrcodeImageView: UIImageView!
    @IBOutlet weak var joinToScanLabel: UILabel! {
        didSet {
            joinToScanLabel.font = .regular(ofSize: UIFont.font22)
            joinToScanLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var wifiNetworkNameLabel: UILabel! {
        didSet {
            wifiNetworkNameLabel.font = .bold(ofSize: UIFont.font22)
            wifiNetworkNameLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var infoSubtitleLabel: UILabel! {
        didSet {
            infoSubtitleLabel.font = .regular(ofSize: UIFont.font14)
            infoSubtitleLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var addToAppleWalletButton: Button! {
        didSet {
            addToAppleWalletButton.style = .bordered
        }
    }
    
    private var doneButton: UIBarButtonItem!
    
    /// Holds QRCodeViewModel with strong reference
    var viewModel: QRCodeViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        addToAppleWalletButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        QRCodeUtility.shared.increaseBrightness()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        QRCodeUtility.shared.setBrightnessToDefault()
    }
    
    /// Navigation bar setup
    private func setNavigationBar() {
        self.title = Constants.JoinQRCode.joinQRCode
        doneButton = UIBarButtonItem.init(title: Constants.Common.done,
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        doneButton.defaultSetup()
        doneButton.tintColor = UIColor.BiWFColors.purple
        self.navigationItem.rightBarButtonItem = doneButton
    }
}

/// DashboardViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension QRCodeViewController: Bindable {
    func bindViewModel() {
        bindInput()
        bindOutput()
    }
    
    /// Binding all the input  observers from viewmodel to get the events
    func bindInput() {
        doneButton.rx.tap
            .bind(to: (viewModel.input.doneTapObserver))
            .disposed(by: disposeBag)
    }
    
    /// Binding all the output  observers from viewmodel to get the values
    func bindOutput() {
        viewModel.output.qrCodeImageDriver
            .drive(qrcodeImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.output.scanToJoinTextDriver
            .drive(joinToScanLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.wifiNetworkNameTextDriver
            .drive(wifiNetworkNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.infoSubtitleTextDriver
            .drive(infoSubtitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.addToWallettextDriver
            .drive(addToAppleWalletButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
}
