//
//  PersonalInfoViewController.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 22/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
import RxFeedback
import RxKeyboard

/*
PersonalInfoViewController for the user to give their personal information
*/
class PersonalInfoViewController: UIViewController, Storyboardable, SingleButtonAlertPresenter {
    
    //Outlets
    @IBOutlet weak var loginInformationHeadingLabel: UILabel!
    @IBOutlet weak var phoneNumberHeaderLabel: UILabel!
    @IBOutlet weak var requiredFieldsLabel: UILabel!
    @IBOutlet weak var emailView: TextComponentsView! {
            didSet {
                emailView.textFieldName = Constants.PersonalInformation.emailAddress
                emailView.textField.textColor = UIColor.BiWFColors.med_grey
                emailView.textField.delegate = self
                emailView.textField.tag = TextFieldType.email.rawValue
                emailView.rightImageView = UIImage.init(named: Constants.PersonalInformation.question)
                emailView.isOptional = false
            }
        }
    
    @IBOutlet weak var passwordView: TextComponentsView! {
            didSet {
                passwordView.textFieldName = Constants.PersonalInformation.password
                passwordView.textField.delegate = self
                passwordView.textField.tag = TextFieldType.password.rawValue
                passwordView.textField.returnKeyType = .next
                passwordView.textField.isSecureTextEntry = true
                passwordView.rightImageView = UIImage.init(named: Constants.PersonalInformation.offCopy)
                passwordView.isOptional = false
            }
        }
    
    @IBOutlet weak var confirmPasswordView: TextComponentsView! {
            didSet {
                confirmPasswordView.textFieldName = Constants.PersonalInformation.confirmPassword
                confirmPasswordView.textField.delegate = self
                confirmPasswordView.textField.tag = TextFieldType.confirmPassword.rawValue
                confirmPasswordView.textField.isSecureTextEntry = true
                confirmPasswordView.textField.returnKeyType = .next
                confirmPasswordView.rightImageView = UIImage.init(named: Constants.PersonalInformation.offCopy)
                confirmPasswordView.isOptional = false
            }
        }
    
    @IBOutlet weak var mobileView: TextComponentsView! {
            didSet {
                mobileView.textFieldName = Constants.PersonalInformation.mobileNumber
                mobileView.textField.delegate = self
                mobileView.textField.tag = TextFieldType.mobile.rawValue
                mobileView.isOptional = false
                mobileView.textField.returnKeyType = .done
                mobileView.textField.keyboardType = .numberPad
            }
        }
    
    @IBOutlet weak var scrollview: UIScrollView!

    @IBOutlet weak var constraintScrollviewBottom: NSLayoutConstraint!

    /// Bar buttons
    var doneButton: UIBarButtonItem!
    
    /// Holds the PersonalInfoViewModel with a strong reference
    var viewModel: PersonalInfoViewModel!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        AnalyticsEvents.trackScreenVisitEvent(with: AnalyticsConstants.EventScreenName.personalInformation)
    }
    
    /// /// NavigationBar Setup
    private func setNavigationBar() {
        self.title = Constants.PersonalInformation.personalInformation
        doneButton = UIBarButtonItem.init(title: Constants.Common.done,
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        doneButton.defaultSetup()
        self.navigationItem.rightBarButtonItem = doneButton
    }
}

/// PersonalInfoViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension PersonalInfoViewController: Bindable {
    
    func bindViewModel() {
        bindInputs()
        bindOutputs()
        bindTextFieldsRightView()
        bindKeyboardEvents()
    }
    
    /// Binding all the input observers from viewmodel to get the events
    private func bindInputs() {
        emailView.textField.rx.text
            .map { text in
                return text ?? ""
        }.bind(to: viewModel.input.emailObserver)
            .disposed(by: disposeBag)
        
        passwordView.textField.rx.text
            .map { text in
                return text ?? ""
        }.bind(to: viewModel.input.passwordObserver)
            .disposed(by: disposeBag)
        
        confirmPasswordView.textField.rx.text
            .map { text in
                return text ?? ""
        }.bind(to: viewModel.input.confirmPasswordObserver)
            .disposed(by: disposeBag)
        
        mobileView.textField.rx.text
            .map { text in
                return text ?? ""
        }
        .bind(to: viewModel.input.moblieNumberObserver)
        .disposed(by: disposeBag)
        
        doneButton.rx.tap.subscribe({ _ in
            AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.personalInformationDone)
            if self.validateFields() {
                self.viewModel.input.doneObserver.onNext(())
            }
        }).disposed(by: disposeBag)
        
        emailView.rightButton?.rx.tap.subscribe(onNext:{ text in
            let message = Constants.PersonalInformation.detail.attribStringWithNumber
            let title = Constants.PersonalInformation.title
            self.viewModel.openCustomAlert(withMessage: message,
                                           title: title)
        }).disposed(by: disposeBag)
        
        viewModel?.onShowError = { [weak self] alert in
            self?.presentSingleButtonAlert(alert: alert)
        }
    }
    
    /// Binding all the output drivers from viewmodel to get the values
    private func bindOutputs() {
        
        viewModel.output.loginInformationHeaderTextDriver
            .drive(loginInformationHeadingLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.emailTextDriver
            .drive(emailView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.emailFieldTextDriver
            .drive(emailView.textField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.passwordTextDriver
            .drive(passwordView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.passwordFieldTextDriver
            .drive(passwordView.textField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.confirmPasswordTextDriver
            .drive(confirmPasswordView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.phoneNumberTextDriver
            .drive(phoneNumberHeaderLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.mobilePhoneTextDriver
            .drive(mobileView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.mobilePhoneFieldTextDriver
            .drive(mobileView.textField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.requiredFiledTextDriver
            .drive(requiredFieldsLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.passwordDonotMatchTextDriver
            .drive(passwordView.errorLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.confirmPasswordDonotMatchTextDriver
            .drive(confirmPasswordView.errorLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.phoneNumberLengthDriver
        .drive(mobileView.errorLabel.rx.text)
        .disposed(by: disposeBag)
        
        viewModel.output.viewStatusObservable.subscribe(onNext: { [weak self] viewStatus in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch viewStatus{
                case .loading(_):
                    self.view.showLoaderView(with: Constants.Common.loading)
                case .loaded:
                    self.view.removeSubView()
                case .error(errorMsg: let errorMsg, retryButtonHandler: let retryButtonHandler):
                    self.view.showErrorView(with: errorMsg, reloadHandler: retryButtonHandler)
                }
            }
        }).disposed(by: disposeBag)
    }

    /// Binding textfield right view image
    func bindTextFieldsRightView() {
        passwordView.rightButton?.rx.tap.subscribe(onNext:{ text in
            self.updateSecurityText(forTextField: self.passwordView.textField)
        }).disposed(by: disposeBag)
        
        confirmPasswordView.rightButton?.rx.tap.subscribe(onNext:{ text in
            self.updateSecurityText(forTextField: self.confirmPasswordView.textField)
        }).disposed(by: disposeBag)
    }
    
    /// Handle view when keyboard is appeared/hide
    func bindKeyboardEvents() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                self?.scrollview.contentInset.bottom = keyboardVisibleHeight + Constants.TextField.topInset
                self?.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
}
