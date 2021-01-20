//
//  SupportSpeedTestView.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 03/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa

/*
    SupportSpeedTestView to show speed test result on support view controller
**/
class SupportSpeedTestView: UIView {
    // MARK: Outlet
    @IBOutlet weak var uploadSpeedLabel: UILabel! {
        didSet {
            uploadSpeedLabel.font = .bold(ofSize: 32)
            uploadSpeedLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var uploadFrequencyLabel: UILabel! {
        didSet {
            uploadFrequencyLabel.font = .regular(ofSize: 12)
            uploadFrequencyLabel.textColor = UIColor.BiWFColors.lavender
        }
    }
    @IBOutlet weak var downloadSpeedLabel: UILabel! {
        didSet {
            downloadSpeedLabel.font = .bold(ofSize: 32)
            downloadSpeedLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var downloadFrequencyLabel: UILabel! {
        didSet {
            downloadFrequencyLabel.font = .regular(ofSize: 12)
            downloadFrequencyLabel.textColor = UIColor.BiWFColors.lavender
        }
    }
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var downloadImageView: UIImageView!
    @IBOutlet weak var runSpeedTestButton: UIButton!
    @IBOutlet weak var restartModemButton: Button! {
        didSet {
            restartModemButton.style = .bordered
        }
    }
    @IBOutlet private var upActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private var downActivityIndicator: UIActivityIndicatorView!
    
    // MARK: Variables
    var viewModel: SupportSpeedTestViewModel!
    private let disposeBag = DisposeBag()
    
    var isAlertDismissed = true
    
    ///  Initializes and returns a newly allocated SupportSpeedTestView view object.
    /// - Parameter
    ///     - frame : frame size in CGRect
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        loadFromNib()
        self.layoutIfNeeded()
    }
}

/// SupportSpeedTestView Extension confirm Bindable protocol.
/// This is provide a standard interface to all it's internal elements to be bound to a view model
extension SupportSpeedTestView: Bindable {
    func bindViewModel() {
        
        viewModel.output.runNewTestTextDriver
            .drive(runSpeedTestButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.output.uploadSpeedTextDriver
            .drive(uploadSpeedLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.uploadMbpsTextDriver
            .drive(uploadFrequencyLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.downloadSpeedTextDriver
            .drive(downloadSpeedLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.downloadMbpsTextDriver
            .drive(downloadFrequencyLabel.rx.text)
            .disposed(by: disposeBag)
        
        runSpeedTestButton.rx.tap
            .bind(onNext: {[weak self] _ in
                AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.runSpeedTest)
                self?.viewModel.input.runSpeedTestTappedObserver.onNext(())
            }).disposed(by: disposeBag)
        
        runSpeedTestButton.translatesAutoresizingMaskIntoConstraints = false
        ///Bind restart modem button tap
        restartModemButton.rx.tap
            .bind(onNext: {[weak self] _ in
                guard let self = self else {return}
                if self.isAlertDismissed {
                    self.isAlertDismissed = false
                    AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.restartModem)
                    self.showConfirmationAlert()
                }
            }).disposed(by: disposeBag)
        
        viewModel.output.restartButtonStateDriver
            .drive(onNext: {[weak self] state in
                self?.updateRestartButtonState(modemType: state)
            }).disposed(by: disposeBag)
        
        viewModel.output.isSpeedTestRunningDriver
            .drive(upActivityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.isSpeedTestRunningDriver
            .drive(downActivityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.output.isSpeedTestRunningDriver
            .drive(uploadSpeedLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.isSpeedTestRunningDriver
            .drive(downloadSpeedLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.enableSpeedTestDriver
            .drive(runSpeedTestButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.output.enableSpeedTestDriver
            .map { shouldEnable -> UIColor in
                self.restartModemButton.style = shouldEnable ? .bordered : .disabledBordered
                return shouldEnable ? UIColor.BiWFColors.purple : UIColor.BiWFColors.purple.withAlphaComponent(0.25)
            }.drive(runSpeedTestButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.output.isSpeedTestRunningDriver
            .drive(onNext: { [weak self] isRunning in
                guard let self = self else { return }
                if isRunning {
                    self.restartModemButton.style = .disabledBordered
                }
            }).disposed(by: disposeBag)
    }
    
    /// Handle restart modem button state according to ModemState
    /// - Parameter
    ///     - modemType : State of modem like restart, restarting, isOnline
    func updateRestartButtonState(modemType: ModemRestartManager.ModemState) {
        switch modemType {
        case .restartModem:
            self.restartModemButton.style = .bordered
            self.restartModemButton.setTitle(Constants.SpeedTest.restartModemText, for: .normal)
        case .restarting:
            self.restartModemButton.style = .withIndicator
            self.restartModemButton.setTitle(Constants.SpeedTest.restartingModemText, for: .normal)
            if ModemRestartManager.shared.isRebooting != .restarting {
                viewModel.checkModemStatus()
            }
        case .isOnline: break;
        }
    }
    
    /// Show restart modem confirmation alert
    func showConfirmationAlert() {
        AlertPresenter.showRetryErrorAlert(title: Constants.SpeedTest.confirmationAlertTitle,
                                           message: Constants.SpeedTest.confirmationAlertMessage,
                                           retryAction: {
                                            self.isAlertDismissed = true
                                            self.viewModel.input.restartModemTappedObserver.onNext(())
                                           },
                                           cancelAction: {
                                           self.isAlertDismissed = true
                                           },
                                           leftButtonTitle:  Constants.Common.cancel.capitalized,
                                           rightButtonTitle: Constants.SpeedTest.confirmationAlertRestartButtonTitle)
    }
}
