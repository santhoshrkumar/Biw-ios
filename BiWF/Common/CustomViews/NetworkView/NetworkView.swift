//
//  NetworkView.swift
//  BiWF
//
//  Created by pooja.q.gupta on 12/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
/*
 NetworkView to show network information
 */
class NetworkView: UIView {
    /// Outlets
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .bold(ofSize: UIFont.font20)
            titleLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    
    @IBOutlet weak var errorLabel: UILabel! {
        didSet {
            errorLabel.font = .regular(ofSize: UIFont.font12)
            errorLabel.textColor = UIColor.BiWFColors.strawberry
            errorLabel.isHidden = true
        }
    }
    @IBOutlet weak var networkNameView: TextComponentsView! {
        didSet {
            networkNameView.isOptional = false
            networkNameView.textField.delegate = self
        }
    }
    @IBOutlet weak var passwordView: TextComponentsView! {
        didSet {
            passwordView.textField.isSecureTextEntry = true
            passwordView.rightImageView = UIImage.init(named: Constants.PersonalInformation.offCopy)
            passwordView.isOptional = false
            passwordView.showDescriptionInNormalState = true
            passwordView.textField.delegate = self
            passwordView.textField.font = .regular(ofSize: UIFont.font12)
            passwordView.textField.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var enableDisableButton: Button! {
        didSet {
            enableDisableButton.style = .enabledWithLightPurpleBackground
        }
    }
    @IBOutlet weak var tapToEnableDisableLabel: UILabel! {
        didSet {
            tapToEnableDisableLabel.font = .regular(ofSize: UIFont.font12)
            tapToEnableDisableLabel.textColor = UIColor.BiWFColors.med_grey
        }
    }
    
    /// Holds NetworkViewModel with strong reference
    var viewModel: NetworkViewModel!
    
    private let disposeBag = DisposeBag()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        loadFromNib()
        enableDisableButton.backgroundColor = UIColor.BiWFColors.lavender
        self.layoutIfNeeded()
    }
}

/// NetworkView extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension NetworkView: Bindable {
    func bindViewModel() {
        bindOutputs()
        bindInputs()
        bindTextFieldsRightView()
    }
    
    /// Binding all the input observers from viewmodel to get the events
    func bindInputs() {
        networkNameView.textField.rx.text
            .map { text in
                return text ?? ""
        }.bind(to: viewModel.input.networkNameObserver)
            .disposed(by: disposeBag)
        
        passwordView.textField.rx.text
            .map { text in
                return text ?? ""
        }.bind(to: viewModel.input.networkPasswordObserver)
            .disposed(by: disposeBag)
        
        enableDisableButton.rx.tap
            .bind(to: viewModel.input.enableDisableTapObserver)
            .disposed(by: disposeBag)
    }
    
    /// Binding all the output observers from viewmodel to get the values
    func bindOutputs() {
        viewModel.output.titleDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.errorDriver
            .drive(errorLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.networkNameDriver
            .drive(onNext: { [weak self] networkName in
                self?.networkNameView.textFieldName = networkName
                self?.networkNameView.textField.placeholder = networkName
            })
            .disposed(by: disposeBag)
        
        viewModel.output.networkNameValueDriver
            .drive(networkNameView.textField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.passwordDriver
            .drive(onNext: { [weak self] password in
                self?.passwordView.textFieldName = password
                self?.passwordView.textField.placeholder = password
            })
            .disposed(by: disposeBag)
        
        viewModel.output.passwordValueDriver
            .drive(passwordView.textField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.passwordDescriptionDriver
            .drive(passwordView.errorLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.buttonTextDriver
            .drive(enableDisableButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.output.tapToEnableDisableDriver
            .drive(tapToEnableDisableLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.networkNameStateDriver
            .drive(onNext: {[weak self] (viewState) in
                self?.networkNameView.state = viewState
                self?.hideUnhideErrorLabel()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.networkPasswordStateDriver
            .drive(onNext: {[weak self] (viewState) in
                self?.passwordView.state = viewState
                self?.hideUnhideErrorLabel()
                
            })
            .disposed(by: disposeBag)
        
        viewModel.output.networkEnableDisableDriver
            .drive(onNext: {[weak self] (isEnabled) in
                //Button
                DispatchQueue.main.async {[weak self] in
                    self?.enableDisableButton.style = isEnabled ? .enabledWithLightPurpleBackground : .enabledWithGrayBackground
                    let image = UIImage(named: (isEnabled ? Constants.UsageDetails.connectedImageName : Constants.UsageDetails.pauseImageName))
                    self?.enableDisableButton.setImage(image, for: .normal)
                    //TextField
                    self?.networkNameView.textField.isEnabled = isEnabled
                    self?.passwordView.textField.isEnabled = isEnabled
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// To show or hide error label
    func hideUnhideErrorLabel() {
        
        var hideErrorLabel = true
        switch passwordView.state {
        case .error( _):
            hideErrorLabel = false
        default:
            break
        }
        
        switch networkNameView.state {
        case .error( _):
            hideErrorLabel = false
        default:
            break
        }
        
        errorLabel.isHidden = hideErrorLabel
    }
    
    /// Setting right image to textfield
    func bindTextFieldsRightView() {
        passwordView.rightButton?.rx.tap.subscribe(onNext:{ text in
            self.updateSecurityText(forTextField: self.passwordView.textField)
        }).disposed(by: disposeBag)
    }
}

/// NetworkView extension
extension NetworkView {
    /// Giving security texts to text field
    func updateSecurityText(forTextField textField: UITextField) {
        
        textField.isSecureTextEntry = !textField.isSecureTextEntry
        textField.font = textField.isSecureTextEntry ? .regular(ofSize: UIFont.font12) : .regular(ofSize: UIFont.font16)
        let passwordRightViewImage = textField.isSecureTextEntry ? Constants.PersonalInformation.offCopy : Constants.PersonalInformation.onCopy
        if let textFieldSuperView = textField.superview?.superview as? TextComponentsView {
            textFieldSuperView.rightImageView = UIImage.init(named: passwordRightViewImage)
            bindTextFieldsRightView()
        }
    }
}

/// NetworkView extension confirming to UITextFieldDelegate
extension NetworkView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.input.textFieldDidEndEditingObserver.onNext(())
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        viewModel.input.textFieldDidBeginEditingObserver.onNext(())
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let newText = textField.text?.replace(with: string, in: range) else { return false }
        return (textField == networkNameView.textField) ? (newText.count <= Constants.NetworkInfo.networkNameMaxLength) : (newText.count <= Constants.NetworkInfo.passwordMaxLength)
    }
}
