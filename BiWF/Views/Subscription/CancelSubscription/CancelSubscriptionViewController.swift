//
//  CancelSubscriptionViewController.swift
//  BiWF
//
//  Created by pooja.q.gupta on 22/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/*
 CancelSubscriptionViewController to show Cancel Subscription details
 */
class CancelSubscriptionViewController: UIViewController, Storyboardable {
    
    /// Outlets
    @IBOutlet weak var headerLabel: UILabel! {
        didSet {
            headerLabel.font = .bold(ofSize: UIFont.font16)
            headerLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var errorLabel: UILabel! {
        didSet {
            errorLabel.font = .regular(ofSize: UIFont.font12)
            errorLabel.textColor = UIColor.BiWFColors.strawberry
        }
    }
    @IBOutlet weak var cancellationDateView: TextComponentsView! {
        didSet {
            cancellationDateView.textFieldName = Constants.CancelSubscription.cancellationDate
            cancellationDateView.textField.placeholder = Date().toString(withFormat: DateFormat.MMMMddyyyy)
            cancellationDateView.textField.inputView = datePicker
            cancellationDateView.textField.delegate = self
            cancellationDateView.leftImageView = UIImage.init(named: Constants.CancelSubscription.calendarImageName)
            cancellationDateView.isOptional = false
        }
    }
    
    @IBOutlet weak var cancellationReasonView: TextComponentsView! {
        didSet {
            cancellationReasonView.textFieldName = Constants.CancelSubscription.cancellationReason
            cancellationReasonView.textField.placeholder = Constants.CancelSubscription.select
            cancellationReasonView.textField.inputView = cancellationReasonPicker
            cancellationReasonView.textField.delegate = self
            cancellationReasonView.rightImageView = UIImage.init(named: Constants.CancelSubscription.dropDownImageName)
            cancellationReasonView.isOptional = true
        }
    }
    
    @IBOutlet weak var specifyReasonStackView: UIStackView!
    @IBOutlet weak var specifyReasonLabel: UILabel! {
        didSet {
            specifyReasonLabel.font = .regular(ofSize: UIFont.font12)
        }
    }
    @IBOutlet weak var specifyReasonTextView: TextView! {
        didSet {
            specifyReasonTextView.placholder = Constants.CancelSubscription.moreInfo
        }
    }
    @IBOutlet weak var ratingLabel: UILabel! {
        didSet {
            ratingLabel.font = .regular(ofSize: UIFont.font12)
        }
    }
    @IBOutlet weak var ratingView: Rating!
    @IBOutlet weak var commentsLabel: UILabel! {
        didSet {
            commentsLabel.font = .regular(ofSize: UIFont.font12)
        }
    }
    @IBOutlet weak var commentsTextView: TextView! {
        didSet {
            commentsTextView.placholder = Constants.CancelSubscription.tellMoreAboutExperience
        }
    }
    @IBOutlet weak var submitButton: Button!
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var constraintReasonStackviewHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintSpecifyReasonTextviewHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintErrorLabelTop: NSLayoutConstraint!
    @IBOutlet weak var specifyReasonStackViewTop: NSLayoutConstraint!
    @IBOutlet weak var constraintScrollviewBottom: NSLayoutConstraint!
    
    /// Bar buttons
    var cancelButton: UIBarButtonItem!
    var backButton: UIBarButtonItem!
    
    ///Picker
    let datePicker: UIDatePicker = UIDatePicker()
    var cancellationReasonPicker = PickerView()
    
    /// Tap gesture
    let tapGesture = UITapGestureRecognizer()
    
    /// Holds CancelSubscriptionViewModel with strong reference
    var viewModel: CancelSubscriptionViewModel!
    
    /// Constants/Variables
    let disposeBag = DisposeBag()
    var activeTextfieldFrame: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavbar()
        initialSetup()
        AnalyticsEvents.trackScreenVisitEvent(with: AnalyticsConstants.EventScreenName.cancelSubscriptionDetails)
    }
    
    //MARK:- UI setup
    func initialSetup() {
        addGesture()
        setDatePicker()
        hideCancellationReasonView(true)
    }
    
    func addGesture() {
        view.addGestureRecognizer(tapGesture)
    }
    
    /// Date Picker setup
    func setDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date().isCurrentTimeLessThan(hour: 22) ? Date() : Date().dateAfterDays(1)
        datePicker.maximumDate = Constants.CancelSubscription.maxCancellationDate.toDate(with: DateFormat.MMMMddyyyy)
    }
    
    /// Navigation bar setup
    func setNavbar() {
        self.title = Constants.CancelSubscription.cancelSubscription
        setBackButton()
        setCancelButton()
    }
    
    /// Backbutton setup
    func setBackButton() {
        backButton = UIBarButtonItem.init(image: UIImage.init(named: Constants.Common.backButtonImageName),
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        backButton.defaultSetup()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    /// Cancelbutton setup
    func setCancelButton() {
        cancelButton = UIBarButtonItem.init(title: Constants.Common.done.uppercased(),
                                            style: .plain,
                                            target: nil,
                                            action: nil)
        cancelButton.defaultSetup()
        self.navigationItem.rightBarButtonItem = cancelButton
    }
}

//MARK: Alert
extension CancelSubscriptionViewController {
    
    /// Show confirmation alert on cancelling subscription
    func showConfirmationAlert() {
        AnalyticsEvents.trackScreenVisitEvent(with: AnalyticsConstants.EventScreenName.cancelSubscriptionPopup)
        let message = "\(Constants.CancelSubscription.serviceEndOn) \(viewModel.subscriptionEndDate), \(Constants.CancelSubscription.noAccessForService)"
        
        self.showAlert(with: Constants.CancelSubscription.sureWantToCancel,
                       message: message,
                       leftButtonTitle: Constants.CancelSubscription.keepService,
                       rightButtonTitle: Constants.CancelSubscription.cancelService,
                       rightButtonStyle: .cancel,
                       leftButtonDidTap: {[weak self] in
                        
                        guard let self = self else { return }
                        AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.keepServices)
                        self.viewModel.keepServiceTapSubject.onNext(())
                        
        }) {[weak self] in
            //TODO:- Save the details
            guard let self = self else { return }
            self.viewModel.cancelServiceTapSubject.onNext(())
        }
    }
}
