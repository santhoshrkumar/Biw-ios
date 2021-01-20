//
//  CancelSubscriptionViewController+UITextfieldDelegate.swift
//  BiWF
//
//  Created by pooja.q.gupta on 05/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
/*
 CancelSubscriptionViewController confirming UITextFieldDelegate
 */
extension CancelSubscriptionViewController: UITextFieldDelegate {
    
    /// It will call once the textfield start editing 
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Set the active textfield frame
        activeTextfieldFrame = textField.superview?.frame
        return true
    }
}
