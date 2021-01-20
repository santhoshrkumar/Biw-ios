//
//  RestartModemTableViewCell.swift
//  BiWF
//
//  Created by Amruta Mali on 09/11/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
/*
 RestartModemTableViewCell will show only restart modem functionality when speed test result is not available.
 */
class RestartModemTableViewCell: UITableViewCell {
    /// reuse identifier
    static let identifier = "RestartModemTableViewCell"
    
    ///Outlets
    @IBOutlet weak var restartModemButton: Button! {
        didSet {
            restartModemButton.style = .bordered
            restartModemButton.titleLabel?.font = .bold(ofSize: UIFont.font14)
        }
    }
    
    /// Holds the SpeedTestCellViewModel with strong reference
    var viewModel: RestartModemViewModel!
    private let disposeBag = DisposeBag()
    var isAlertDismissed = true
}

/// SpeedTestTableViewCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension RestartModemTableViewCell: Bindable {
    func bindViewModel() {
        bindOutput()
    }
    
    /// Binding all the output Observables from viewmodel to get the values
    func bindOutput() {
        viewModel.output.restartButtonStateDriver
            .drive(onNext: {[weak self] state in
                self?.updateRestartButtonState(modemType: state)
            }).disposed(by: disposeBag)
        //change the restart button appearance
         restartModemButton.style = viewModel.style
        ///Bind restart modem button tap
        restartModemButton.rx.tap
            .bind(onNext: {[weak self] _ in
                guard let self = self else {return}
                if self.isAlertDismissed {
                    self.isAlertDismissed = false
                    AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.restartModem)
                    if self.viewModel.isModemOnline{
                        self.showConfirmationAlert()
                    }
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
            self.restartModemButton.setTitle(Constants.SpeedTest.troubleshootingRestartModemText, for: .normal)
        case .restarting:
            self.restartModemButton.style = .disabledBordered
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
                                            self.viewModel.input.restartModemObserver.onNext(())
                                           },
                                           cancelAction: {
                                           self.isAlertDismissed = true
                                           },
                                           leftButtonTitle:  Constants.Common.cancel.capitalized,
                                           rightButtonTitle: Constants.SpeedTest.confirmationAlertRestartButtonTitle)
    }
}
