//
//  AppointmentConfirmationViewController.swift
//  BiWF
//
//  Created by pooja.q.gupta on 06/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/*
AppointmentConfirmationViewController to book an appointment
*/
class AppointmentConfirmationViewController: UIViewController, Storyboardable {
    
    /// Outlets
    @IBOutlet weak var technicianWillArriveLabel: UILabel! {
        didSet {
            technicianWillArriveLabel.font = .bold(ofSize: UIFont.font18)
            technicianWillArriveLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = .regular(ofSize: UIFont.font14)
            descriptionLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    
    @IBOutlet weak var addToCalendarButton: Button! {
        didSet {
            addToCalendarButton.style = .bordered
            addToCalendarButton.isHidden = true
        }
    }
    @IBOutlet weak var goToDashboardButton: Button!{
         didSet {
            goToDashboardButton.style = .filledBackground
        }
    }
    
    /// Bar buttons
    var doneButton: UIBarButtonItem!
    
    /// Constants/Variables
    var viewModel: AppointmentConfirmationViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavbar()
    }
    
    /// NavigationBar Setup
    func setNavbar() {
        self.title = Constants.AppointmentConfirmation.title
        self.navigationItem.hidesBackButton = true
        setCancelButton()
    }
    
    /// Bar buttons setup
    func setCancelButton() {
        doneButton = UIBarButtonItem.init(title: Constants.Common.done,
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        doneButton.defaultSetup()
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
}

/// AppointmentConfirmationViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension AppointmentConfirmationViewController: Bindable {
    func bindViewModel() {
        bindInputs()
        bindOutputs()
    }
    
    /// Binding all the input observers from viewmodel to get the events
    func bindInputs() {
        doneButton.rx.tap
            .bind(to: (viewModel.input.doneTapObserver))
            .disposed(by: disposeBag)
        
        addToCalendarButton.rx.tap
            .bind(to: (viewModel.input.addAppointmentTapObserver))
            .disposed(by: disposeBag)
        
        goToDashboardButton.rx.tap
            .bind(to: (viewModel.input.viewDashboardTapObserver))
            .disposed(by: disposeBag)
    }
    
    /// Binding all the output drivers from viewmodel to get the values
    func bindOutputs() {
        viewModel.output.technicianWillArriveTextDriver
            .drive(technicianWillArriveLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.descriptionTextDriver
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.viewDashabordTextDriver
            .drive(goToDashboardButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.output.addAppointmentTextDriver
            .drive(addToCalendarButton.rx.title())
            .disposed(by: disposeBag)
    }
}
