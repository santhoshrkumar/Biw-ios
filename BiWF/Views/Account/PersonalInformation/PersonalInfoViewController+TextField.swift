//
//  PersonalInfoViewController+TextField.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 26/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
/*
 PersonalInfoViewController confirming to UITextFieldDelegate protocol
 */
extension PersonalInfoViewController: UITextFieldDelegate {
    
    /// selecting the textfield type
    enum TextFieldType: Int {
        case email = 101
        case password
        case confirmPassword
        case mobile
    }
    
    ///  providing security  for the password textfield
    func updateSecurityText(forTextField textField: UITextField) {
        
        textField.isSecureTextEntry = !textField.isSecureTextEntry
        let passwordRightViewImage = textField.isSecureTextEntry ? Constants.PersonalInformation.offCopy : Constants.PersonalInformation.onCopy
        if let textFieldSuperView = textField.superview?.superview as? TextComponentsView {
            textFieldSuperView.rightImageView = UIImage.init(named: passwordRightViewImage)
            bindTextFieldsRightView()
        }
    }
    
    /// validating the textfields
    /// returns true or false depends upon the validation
    func validateFields() -> Bool {
        var fieldsValidations = true
        passwordView.state = (passwordView.textField.text != confirmPasswordView.textField.text && confirmPasswordView.textField.text != "") ? .error(Constants.PersonalInformation.passwordDonotMatch) : .normal("")
        confirmPasswordView.state = (passwordView.textField.text != confirmPasswordView.textField.text && confirmPasswordView.textField.text != "") ? .error(Constants.PersonalInformation.passwordDonotMatch) : .normal("")
        mobileView.state = (mobileView.textField.text?.replacingOccurrences(of: "-", with: "").count ?? 0 < Constants.PersonalInformation.validPhoneNumberLength ||  (mobileView.textField.text ?? "").containsSpecialCharacter || !(viewModel.isValidPhone(phone: mobileView.textField.text ?? ""))) ? .error(Constants.PersonalInformation.invalidPhoneNumberLength) : .normal("")
        requiredFieldsLabel.isHidden = !((passwordView.textField.text != confirmPasswordView.textField.text && confirmPasswordView.textField.text != "") || mobileView.textField.text == "")
        fieldsValidations = (requiredFieldsLabel.isHidden || confirmPasswordView.textField.text == "") && viewModel.isValidPhone(phone: mobileView.textField.text ?? "") && !((mobileView.textField.text ?? "").containsSpecialCharacter)
        return fieldsValidations
    }
    
    /// It will call when your starts editing the textfield
    /// return false to ignore this
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == TextFieldType.email.rawValue {
            return false
        }
        return true
    }
    
///Tells the delegate when the text selection changes in the specified text field
    func textFieldDidChangeSelection(_ textField: UITextField) {
        var shouldUpdate = false
        if textField.tag == TextFieldType.mobile.rawValue && viewModel.isValidPhone(phone: textField.text ?? "") {
            shouldUpdate = true
        }
        viewModel.updateTextviewStateSubject.onNext(shouldUpdate)
    }
    
    /// It will call when the return key is pressed
    /// - Parameter textField : specified text field
    /// returns false to ignore this
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == TextFieldType.password.rawValue {
            textField.resignFirstResponder()
            confirmPasswordView.textField.becomeFirstResponder()
        } else if textField.tag == TextFieldType.confirmPassword.rawValue {
            textField.resignFirstResponder()
            mobileView.textField.becomeFirstResponder()
        }
        return true
    }

    ///Handle 10 digit mobile number validation
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileView.textField {
            guard let newText = textField.text?.replace(with: string, in: range) else { return false }
            return newText.replacingOccurrences(of: "-", with: "").count <= Constants.PersonalInformation.validPhoneNumberLength
        }
        return true
    }
}
