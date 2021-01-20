//
//  ContactInfoViewController.swift
//  BiWF
//
//  Created by varun.b.r on 09/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
import RxDataSources
/*
  ContactInfoViewController handles contact information required for schedule call back
**/
class ContactInfoViewController: UIViewController, Storyboardable {
    
    /// Bar buttons
    var cancelButton: UIBarButtonItem!
    var backButton: UIBarButtonItem!
    
    /// Constants/Variables
    var viewModel: ContactInfoViewModel!
    let disposeBag = DisposeBag()
    
    // MARK: Outlet
    @IBOutlet weak var contactInfoTextLabel: UILabel! {
        didSet {
            contactInfoTextLabel.font = .bold(ofSize: UIFont.font16)
            contactInfoTextLabel.textColor = UIColor.BiWFColors.purple
            contactInfoTextLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet weak var defaultMobileNumberLabel: UILabel! {
        didSet {
            defaultMobileNumberLabel.font = .regular(ofSize: UIFont.font16)
            defaultMobileNumberLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    
    @IBOutlet weak var MobileTextLabel: UILabel! {
        didSet {
            MobileTextLabel.text = Constants.ContactInfo.mobileText
            MobileTextLabel.font = .regular(ofSize: UIFont.font16)
            MobileTextLabel.textColor = UIColor.BiWFColors.med_grey
        }
    }
    @IBOutlet weak var errorLabel: UILabel! {
        didSet {
            errorLabel.textColor = UIColor.BiWFColors.strawberry
            errorLabel.font = .regular(ofSize: UIFont.font12)
            errorLabel.text = Constants.ContactInfo.errorMessgae
        }
    }
    @IBOutlet weak var contactInfoNextButton: Button! {
        didSet {
            contactInfoNextButton.titleLabel?.font = .regular(ofSize: UIFont.font14)
            contactInfoNextButton.titleLabel?.textColor = UIColor.BiWFColors.white
        }
    }
    
    @IBOutlet weak var mobileNumberTextField: TextComponentsView! {
        didSet {
            mobileNumberTextField.textField.delegate = self
            mobileNumberTextField.textField.placeholder = Constants.ContactInfo.mobileNumberplaceholder
            mobileNumberTextField.textField.textColor = UIColor.BiWFColors.dark_grey
            mobileNumberTextField.textField.keyboardType = .phonePad
        }
    }
    @IBOutlet weak var topStackView: UIView!
    @IBOutlet weak var selectMobileButton: UIButton!
    @IBOutlet weak var selectOtherPhoneButton: UIButton!
    @IBOutlet weak var defaultMobileViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        AnalyticsEvents.trackScreenVisitEvent(with: AnalyticsConstants.EventScreenName.additionalInfo)
    }
    
    //MARK:- Navigation bar setup
    func setNavigationBar() {
        self.title = Constants.ContactInfo.contactInfo
        setBackButton()
        setCancelButton()
    }
    
    func setBackButton() {
        backButton = UIBarButtonItem.init(image: UIImage.init(named: Constants.Common.backButtonImageName),
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        backButton.defaultSetup()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func setCancelButton() {
        cancelButton = UIBarButtonItem.init(title: Constants.Common.cancel.uppercased(),
                                            style: .plain,
                                            target: nil,
                                            action: nil)
        cancelButton.defaultSetup()
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
}

//MARK:- Bindable
/// ContactInfoViewController Extension confirm Bindable protocol.
/// This is provide a standard interface to all it's internal elements to be bound to a view model
extension ContactInfoViewController: Bindable {
    
    ///Binding view model to SpeedTestView to handle event and UI data
    func bindViewModel() {
        bindInputs()
        bindOutputs()
    }
    
    func bindInputs() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self]  (_) in
                AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.additionalInfoCancel)
                self?.viewModel.input.cancelTapObserver.onNext(())
            })
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .subscribe(onNext: { [weak self]  (_) in
                AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.additionalInfoBack)
                self?.viewModel.input.backTapObserver.onNext(())
            })
            .disposed(by: disposeBag)
        
        contactInfoNextButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.view.endEditing(true)
                self.viewModel.scheduleCallBack.phone = self.viewModel.mobileNumber
                self.viewModel.mobileNumber.isEmpty || self.viewModel.mobileNumber.count < Constants.ContactInfo.maxPhoneLimit ? self.viewModel.shouldShowErrorSubject.onNext(true) : self.viewModel.input.nextContactInfoTapObserver.onNext(self.viewModel.scheduleCallBack)
            })
            .disposed(by: disposeBag)
        
        selectMobileButton.rx.tap
            .subscribe(onNext: { [weak self]  (_) in
                self?.mobileNumberTextField.textField.text = ""
                self?.viewModel.input.isMobileSelectedObserver.onNext(true)
            })
            .disposed(by: disposeBag)
        
        selectOtherPhoneButton.rx.tap
            .subscribe(onNext: { [weak self]  (_) in
                self?.viewModel.input.isMobileSelectedObserver.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    func bindOutputs() {
        viewModel.output.nextButtonTitledriver
            .drive(contactInfoNextButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.output.contactInfoMainTextDriver
            .drive(contactInfoTextLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.defaultNumberDriver
            .drive(defaultMobileNumberLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.shouldShowErrorObservable
            .subscribe(onNext: { [weak self]  (shouldShowError) in
                DispatchQueue.main.async {
                    self?.errorLabel.isHidden = !shouldShowError
                    if shouldShowError {
                        self?.mobileNumberTextField.state = .errorWithOutMessage
                        self?.selectOtherPhoneButton.setImage( UIImage(named: Constants.AvailableTimeSlotTableViewCell.selectedWithError), for: .normal)
                    }
                }
            }).disposed(by: disposeBag)
        
        viewModel.output.isMobileSelectedObservable.subscribe(onNext: { (isMobileSelected) in
            self.selectMobileButton.setImage( UIImage(named: isMobileSelected ?
                                                               Constants.AvailableTimeSlotTableViewCell.selected :
                                                               Constants.AvailableTimeSlotTableViewCell.unSelected), for: .normal)
            
            self.selectOtherPhoneButton.setImage( UIImage(named: !isMobileSelected ?
                                                               Constants.AvailableTimeSlotTableViewCell.selected :
                                                               Constants.AvailableTimeSlotTableViewCell.unSelected), for: .normal)
            self.mobileNumberTextField.state = isMobileSelected ? .disable : .normal("")
        }).disposed(by: disposeBag)
        
        viewModel.output.shouldHideDefaultMobileViewObservable
            .subscribe(onNext: { (shouldShow) in
                DispatchQueue.main.async {
                    self.defaultMobileViewContainer.isHidden = !shouldShow
                    self.selectOtherPhoneButton.isHidden = !shouldShow
                    self.mobileNumberTextField.state = shouldShow ? .disable : .normal("")
                }
            }).disposed(by: disposeBag)
    }
}

/// ContactInfoViewController Extension confirm UITextFieldDelegate
extension ContactInfoViewController : UITextFieldDelegate {
    ///Handle 10 digit mobile number validation
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let newText = textField.text?.replace(with: string, in: range) else { return false }
        self.viewModel.mobileNumber = newText
        return newText.count <= Constants.PersonalInformation.validPhoneNumberLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
