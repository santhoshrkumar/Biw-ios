//
//  CancelSubscriptionViewController+Validation.swift
//  BiWF
//
//  Created by pooja.q.gupta on 28/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxCocoa
import DPProtocols
import RxSwift

//MARK:- Validation
extension CancelSubscriptionViewController {
    /// Checking if the date is valid or not
    func isValidDate() -> Bool{
        return (cancellationDateView.textField.text?.count != 0)
    }
    
    /// Hides the Reason for cacellation
    /// - Parameter isHidden : Returns bool value
    func hideCancellationReasonView(_ isHidden: Bool) {
        if isHidden {
            self.constraintReasonStackviewHeight.constant = Constants.CancelSubscription.stackSubviewsSpacing
            self.constraintSpecifyReasonTextviewHeight.constant = 0
            self.specifyReasonStackViewTop.constant = 0
        } else {
            self.constraintReasonStackviewHeight.constant = Constants.CancelSubscription.cancellationReasonViewHeight
            self.constraintSpecifyReasonTextviewHeight.constant = Constants.CancelSubscription.cancellationReasonTextviewHeight
            self.specifyReasonStackViewTop.constant = Constants.CancelSubscription.specifyReasonStackViewTopSpace
        }
    }
    
    /// Used to show validation error if exist
    /// - Parameter isShown : Returns bool value
    func showValidationError(_ isShown: Bool) {
        if isShown {
            cancellationDateView.state = .error("")
            errorLabel.text = Constants.CancelSubscription.fieldRequired
            constraintErrorLabelTop.constant = Constants.CancelSubscription.errorLabelTopSpace
        } else {
            cancellationDateView.state = .normal("")
            errorLabel.text = nil
            constraintErrorLabelTop.constant = 0
        }
    }
}

