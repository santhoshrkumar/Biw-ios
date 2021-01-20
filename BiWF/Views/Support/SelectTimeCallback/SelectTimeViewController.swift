//
//  SelectTimeViewController.swift
//  BiWF
//
//  Created by Amruta Mali on 14/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/*
  SelectTimeViewController get time information required for schedule call back
**/
class SelectTimeViewController: UIViewController, Storyboardable, UITextFieldDelegate {
    // MARK: Outlet
    @IBOutlet weak var callUsLabel: UILabel! {
        didSet {
            callUsLabel.font = .bold(ofSize: UIFont.font16)
            callUsLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    
    @IBOutlet weak var nextAvailableTimeLabel: UILabel! {
        didSet {
            nextAvailableTimeLabel.font = .regular(ofSize: UIFont.font16)
            nextAvailableTimeLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    
    @IBOutlet weak var availabelTimeInfoSubHeaderLabel: UILabel! {
        didSet {
            availabelTimeInfoSubHeaderLabel.font = .regular(ofSize: UIFont.font12)
            availabelTimeInfoSubHeaderLabel.textColor = UIColor.BiWFColors.med_grey
        }
    }
    
    @IBOutlet weak var asapTimeSelectButton: UIButton!
    @IBOutlet weak var pickSpecificTimeSelectButton: UIButton!
    @IBOutlet weak var callMeButton: Button!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var pickTimeLabel: UILabel! {
        didSet {
            pickTimeLabel.font = .regular(ofSize: UIFont.font16)
            pickTimeLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }

    @IBOutlet weak var dateTextComponent: TextComponentsView! {
        didSet {
            dateTextComponent.textFieldName = Constants.SelectTimeScheduleCallback.date
            dateTextComponent.textField.placeholder = Date().toString(withFormat: Constants.DateFormat.MMddyyyy)
            datePicker.datePickerMode = UIDatePicker.Mode.date
            dateTextComponent.textField.inputView = datePicker
            dateTextComponent.textField.delegate = self
            dateTextComponent.leftImageView = UIImage.init(named: Constants.CancelSubscription.calendarImageName)
            dateTextComponent.isOptional = false
        }
    }
    
    @IBOutlet weak var timeTextComponent: TextComponentsView! {
        didSet {
            timeTextComponent.textFieldName = Constants.SelectTimeScheduleCallback.time
            timeTextComponent.textField.placeholder = Date().nearestFifteenthMinute().toString(withFormat: Constants.DateFormat.hMMa)
            timeTextComponent.textField.inputView = timePicker
            timeTextComponent.textField.delegate = self
            timeTextComponent.isOptional = false
        }
    }
    
    /// Bar buttons
    var cancelButton: UIBarButtonItem!
    var backButton: UIBarButtonItem!
    
    ///Picker
    let datePicker: UIDatePicker = UIDatePicker()
    var timePicker: UIDatePicker = UIDatePicker()
    
    /// Tap gesture
    let tapGesture = UITapGestureRecognizer()
    
    /// Constants/Variables
    var viewModel: SelectTimeViewModel!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        initialSetup()
    }
    
    //MARK:- UI setup
    func initialSetup() {
        addGesture()
        setDatePicker()
        setTimePicker()
    }
    
    func setNavigationBar() {
        self.title = Constants.SelectTimeScheduleCallback.selectTime
        setBackButton()
        setCancelButton()
    }
    
    func addGesture() {
        view.addGestureRecognizer(tapGesture)
    }
    
    func setDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Constants.CancelSubscription.maxCancellationDate.toDate(with: DateFormat.MMMMddyyyy)
    }
    
    func setTimePicker() {
        timePicker.minimumDate =  Date.createDateFromDateAndTime(from: Date(), time: Date().nearestFifteenthMinute())
        timePicker.datePickerMode = UIDatePicker.Mode.time
        timePicker.minuteInterval = 15
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
