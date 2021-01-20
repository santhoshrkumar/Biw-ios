//
//  UsageDetailsViewController.swift
//  BiWF
//
//  Created by pooja.q.gupta on 17/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
import RxKeyboard
/*
   UsageDetailsViewController to show detail of device.
**/
class UsageDetailsViewController: UIViewController, Storyboardable {
    
    /// Outlets
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var usageTodayLabel: UILabel! {
        didSet {
            usageTodayLabel.font = .regular(ofSize: UIFont.font16)
            usageTodayLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var usageTodayStackView: UsageDetailView!
    @IBOutlet weak var lastTwoWeeksUsageLabel: UILabel! {
        didSet {
            lastTwoWeeksUsageLabel.font = .regular(ofSize: UIFont.font16)
            lastTwoWeeksUsageLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var lastTwoWeeksUsageStackView: UsageDetailView!
    @IBOutlet weak var pauseResumeButton: Button! {
        didSet {
            pauseResumeButton.style = .bordered
        }
    }
    @IBOutlet weak var tapToPauseLabel: UILabel! {
        didSet {
            tapToPauseLabel.font = .regular(ofSize: UIFont.font12)
            tapToPauseLabel.textColor = UIColor.BiWFColors.med_grey
        }
    }
    @IBOutlet weak var removeButton: Button! {
        didSet {
            //TODO: Currently we are hidding this functionality will remove comment in future
            removeButton.isHidden = true
            removeButton.style = .withoutBorder
        }
    }
    @IBOutlet weak var countLimitLabel: UILabel! {
        didSet {
            countLimitLabel.font = .regular(ofSize: UIFont.font12)
            countLimitLabel.textColor = UIColor.BiWFColors.med_grey
        }
    }
    
    @IBOutlet weak var deviceOrganizationLabel: UILabel! {
        didSet {
            deviceOrganizationLabel.text = Constants.UsageDetails.deviceOrganization
            deviceOrganizationLabel.font = .bold(ofSize: UIFont.font16)
            deviceOrganizationLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    
    @IBOutlet weak var nickNameDeviceLabel: UILabel! {
        didSet {
            nickNameDeviceLabel.text = Constants.UsageDetails.devicesNickname
            nickNameDeviceLabel.font = .regular(ofSize: UIFont.font12)
            nickNameDeviceLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    
    @IBOutlet weak var nicknameOptionalLabel: UILabel! {
        didSet {
            nicknameOptionalLabel.text = Constants.UsageDetails.nicknameOptional
            nicknameOptionalLabel.font = .regular(ofSize: UIFont.font12)
            nicknameOptionalLabel.textColor = UIColor.BiWFColors.med_grey
        }
    }
    @IBOutlet weak var nickNameView: TextComponentsView! {
        didSet {
            nickNameView.textField.placeholder = viewModel.deviceInfo.nickName ?? viewModel.deviceInfo.hostname
            nickNameView.textField.delegate = self
        }
    }
    @IBOutlet weak var constraintScrollviewBottom: NSLayoutConstraint!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    /// Bar buttons
    var doneButton: UIBarButtonItem!
    
    /// Constants/Variables
    var viewModel: UsageDetailsViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: Initial Steup
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavbar()
        pauseResumeButton.backgroundColor = UIColor.BiWFColors.light_blue
        showLoaderView(with: Constants.Common.loading)
        self.scrollview.isHidden = true
        AnalyticsEvents.trackScreenVisitEvent(with: AnalyticsConstants.EventScreenName.devicesDetail)
    }
    
    func setNavbar() {
        self.title = viewModel.deviceInfo.nickName ?? viewModel.deviceInfo.hostname
        
        doneButton = UIBarButtonItem.init(title: Constants.Common.done,
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        doneButton.defaultSetup()
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func showLoaderView(with lodingText: String) {
        self.view.showLoaderView(with: lodingText)
        self.doneButton.isEnabled = false
    }
    
    // MARK:
    ///This will show alert click on remove device
    func showRemoveDeviceAlert() {
        let title = "\(Constants.UsageDetails.wantToRemove) \"\(viewModel.deviceInfo.hostname ?? "")\" \(Constants.UsageDetails.fromTheNetwork)?"
        self.showAlert(with: title,
                       message: Constants.UsageDetails.youCanRestoreAccess,
                       leftButtonTitle: Constants.Common.cancelButtonTitle, leftButtonStyle: .cancel,
                       rightButtonTitle: Constants.Common.remove,
                       leftButtonDidTap: {
                        AnalyticsEvents.trackButtonTapEvent(with:AnalyticsConstants.EventButtonTitle.canncelRemoveDeviceConfirmation)
                       }) { [weak self] in
            AnalyticsEvents.trackButtonTapEvent(with:AnalyticsConstants.EventButtonTitle.removeDeviceConfirmation)
            self?.viewModel.input.removeDeviceObserver.onNext(())
        }
    }
   
    func showValidationAlert() {
        AlertPresenter.showCustomAlertViewController(title: Constants.Common.anErrorOccurred, message: Constants.Common.specialCharacterValidation.attributedString(with: UIFont.regular(ofSize: UIFont.font16), textColor: UIColor.BiWFColors.dark_grey), buttonText: Constants.Common.discardChangesAndClose)
    }
}

/// UsageDetailsViewController Extension confirm Bindable protocol.
/// This is provide a standard interface to all it's internal elements to be bound to a view model
extension UsageDetailsViewController: Bindable {
    func bindViewModel() {
        bindInputs()
        bindOutputs()
        bindKeyboardEvents()
    }
    
    /// Binding all the input observers from viewmodel to get the events
    func bindInputs() {
        doneButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                guard let self = self else {return}
                AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.deviceDetailDone)
                self.viewModel.input.doneTapObserver.onNext(())
            })
            .disposed(by: disposeBag)
        
        pauseResumeButton.rx.tap
            .bind(onNext: {[weak self] _ in
                self?.viewModel.input.pauseResumeObserver.onNext(())
            })
            .disposed(by: disposeBag)
        
        removeButton.rx.tap
            .bind(onNext: {[weak self] _ in
                guard let self = self else {return}
                AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.removeDeviceConncection)
                self.showRemoveDeviceAlert()
            })
            .disposed(by: disposeBag)
        
        nickNameView.textField.rx.text
            .map { text in
                return text ?? ""
            }.bind(to: viewModel.input.deviceNameFieldObserver)
            .disposed(by: disposeBag)
    }
    
    /// Binding all the output from viewmodel to get the events to subscribe
    func bindOutputs() {
        viewModel.output.pauseResumeTitleObservable.bind(to: pauseResumeButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.output.pauseResumeImageObservable
            .bind(to: pauseResumeButton.rx.image())
            .disposed(by: disposeBag)
        
        viewModel.output.pauseResumeBackgroundStyleObservable
            .subscribe(onNext: { [weak self] (style) in
                guard let self = self else {return}
                self.pauseResumeButton.style = style
            }).disposed(by: disposeBag)
        
        viewModel.output.tapToPauseObservable
            .bind(to: tapToPauseLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.usageTodayDriver
            .drive(usageTodayLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.lastTwoWeeksUsageDriver
            .drive(lastTwoWeeksUsageLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.removeDeviceDriver
            .drive(removeButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.output.countLimitDriver
            .drive(countLimitLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.showLoading.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(onNext: { [weak self] (shouldShowIndicator) in
                guard let self = self else {return}
                shouldShowIndicator ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = !shouldShowIndicator
                self.pauseResumeButton.setImage(nil, for: .normal)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.enablePauseResumeDriver
            .drive(onNext: { [weak self] isEnable in
                guard let self = self else {return}
                self.viewModel.deviceInfo.networStatus = isEnable ? .connected : .paused
                DispatchQueue.main.async {
                    self.viewModel.setUpPauseResumeButton()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.todayUsageDetailsObservable
            .subscribe(onNext: { [weak self] viewModel in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.usageTodayStackView.setViewModel(to: viewModel)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.lastTwoWeeksUsageDetailsObservable
            .subscribe(onNext: { [weak self] viewModel in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.lastTwoWeeksUsageStackView.setViewModel(to: viewModel)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.viewStatusObservable.subscribe(onNext: { [weak self] viewStatus in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch viewStatus{
                case .loading(let loadingText):
                    self.showLoaderView(with: loadingText ?? "")
                    
                case .loaded:
                    self.view.removeSubView()
                    self.scrollview.isHidden = false
                    self.doneButton.isEnabled = true
                case .error(errorMsg: let errorMsg, retryButtonHandler: let retryButtonHandler):
                    self.view.showErrorView(with: errorMsg, reloadHandler: retryButtonHandler)
                    self.scrollview.isHidden = true
                    self.doneButton.isEnabled = true
                }
            }
        }).disposed(by: disposeBag)
        
        viewModel.output.viewValidationPopupObservable.subscribe(onNext: { [weak self]  (_) in
            self?.showValidationAlert()
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

/// UsageDetailsViewController Extension for UITextField Delegate method
extension UsageDetailsViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let newText = textField.text?.replace(with: string, in: range) else { return false }
        ///Added restriction on nickname string length
        return newText.count <= Constants.UsageDetails.nicknameMaxlength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

