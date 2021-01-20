//
//  AvailabledDatesTableViewCell.swift
//  BiWF
//
//  Created by pooja.q.gupta on 04/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import DPProtocols
/*
AvailableDatesTableViewCell to show available dates to book appointment
*/
class AvailableDatesTableViewCell: UITableViewCell {
    
    /// reuse identifier
    static let identifier = "AvailableDatesTableViewCell"
    
    /// Outlets
    @IBOutlet weak var selectDayLabel: UILabel! {
        didSet {
            selectDayLabel.textColor = UIColor.BiWFColors.dark_grey
            selectDayLabel.font = .regular(ofSize: UIFont.font18)
        }
    }
    
    @IBOutlet weak var instructionLabel: UILabel! {
        didSet {
            instructionLabel.textColor = UIColor.BiWFColors.med_grey
            instructionLabel.font = .regular(ofSize: UIFont.font12)
        }
    }
    
    @IBOutlet weak var availableAppointmentsLabel: UILabel! {
        didSet {
            availableAppointmentsLabel.textColor = UIColor.BiWFColors.dark_grey
            availableAppointmentsLabel.font = .regular(ofSize: UIFont.font18)
        }
    }
    
    @IBOutlet weak var calendarView: CalendarView! {
        didSet {
            calendarView.cornerRadius = 8
            calendarView.borderColor = UIColor.BiWFColors.light_grey
            calendarView.borderWidth = 1
            calendarView.clipsToBounds = true
        }
    }
    /// Vairables/Constants
    private let disposeBag = DisposeBag()
    var viewModel: AvailableDatesCellViewModel!
}

/// AvailableDatesTableViewCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension AvailableDatesTableViewCell: Bindable {
    func bindViewModel() {
        bindInputs()
        bindOutputs()
    }
    
    /// Binding all the input observers from viewmodel to get the events
    func bindInputs() {
        
    }
    
    /// Binding all the output drivers from viewmodel to get the values
    func bindOutputs() {
        viewModel.output.selectDayDriver
            .drive(selectDayLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.instructionsDriver
            .drive(instructionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.calendarViewModelObservable.subscribe(onNext: { [weak self] viewModel in
            guard let self = self else { return }
            self.calendarView.setViewModel(to: viewModel)
        }).disposed(by: disposeBag)
        
    }
}
