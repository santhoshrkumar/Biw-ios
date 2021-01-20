//
//  SelectTimeViewController+Bindable.swift
//  BiWF
//
//  Created by Amruta Mali on 14/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxCocoa
import DPProtocols
import RxSwift
import RxKeyboard

//MARK:- Bindable
/// SelectTimeViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension SelectTimeViewController: Bindable {
    func bindViewModel() {
        bindInput()
        bindOutput()
        bindEvents()
    }
    
    /// Binding all the input observers from viewmodel to get the events
    func bindInput() {
        cancelButton.rx.tap.bind(onNext: {[weak self] _ in
            self?.viewModel.input.cancelTapObserver.onNext(())
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.bind(onNext: {[weak self] _ in
            self?.viewModel.input.backTapObserver.onNext(())
        }).disposed(by: disposeBag)
        
        asapTimeSelectButton.rx.tap.bind {[weak self] _ in
            self?.viewModel.input.isAsapTimeSelectTapObserver.onNext(true)
        }.disposed(by: disposeBag)
        
        pickSpecificTimeSelectButton.rx.tap.bind {[weak self] _ in
            self?.viewModel.input.isAsapTimeSelectTapObserver.onNext(false)
        }.disposed(by: disposeBag)
        
        callMeButton.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.viewModel.scheduleCallbackInfo.callbackTime = Date.createDateFromDateAndTime(from: self?.datePicker.date, time: self?.timePicker.date).toString(withFormat: Constants.DateFormat.yyyyMMddHHmmss)
            self?.viewModel.input.callMeTapObserver.onNext(())
        }).disposed(by: disposeBag)
    }
    
    /// Binding all the output observers from viewmodel to get the values
    func bindOutput() {
        //Label
        viewModel.output.callUsTextDriver
            .drive(callUsLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.nextAvailableTimeTextDriver
            .drive(nextAvailableTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.availabelTimeInfoSubHeaderTextDriver
            .drive(availabelTimeInfoSubHeaderLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.dateObservable
            .subscribe(onNext: {[weak self] date in
                if let selectedDate = date {
                    self?.dateTextComponent.textField.text = selectedDate.toString(withFormat: Constants.DateFormat.MMddyyyy)
                }
            }).disposed(by: disposeBag)
        
        viewModel.output.timeObservable
            .subscribe(onNext: {[weak self] time in
                if let selectedTime = time {
                    self?.timeTextComponent.textField.text = selectedTime.toString(withFormat: Constants.DateFormat.hMMa)
                }
            }).disposed(by: disposeBag)
        
        viewModel.output.isSelectedAsapTimeDriver.subscribe(onNext: { (isAsapSelected) in
            self.asapTimeSelectButton.setImage( UIImage(named: isAsapSelected ?
                                                               Constants.AvailableTimeSlotTableViewCell.selected :
                                                               Constants.AvailableTimeSlotTableViewCell.unSelected), for: .normal)
            
            self.pickSpecificTimeSelectButton.setImage( UIImage(named: !isAsapSelected ?
                                                               Constants.AvailableTimeSlotTableViewCell.selected :
                                                               Constants.AvailableTimeSlotTableViewCell.unSelected), for: .normal)
            self.viewModel.scheduleCallbackInfo.asap = isAsapSelected
            self.viewModel.scheduleCallbackInfo.handleOption = isAsapSelected
            self.shouldEnableDateTimeView(isAsapSelected)

        }).disposed(by: disposeBag)
        
        viewModel.output.startLoadingIndicatorObserver.subscribe(onNext: {[weak self] (isStartLading) in
            DispatchQueue.main.async {
                self?.loadingIndicator.isHidden = !isStartLading
                isStartLading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
            }
        }).disposed(by: disposeBag)
    }
    
    /// Binding all the observers from viewmodel to get the events
    func bindEvents() {
        tapGesture.rx.event.bind(onNext: {[weak self] recognizer in
            self?.view.endEditing(true)
        }).disposed(by: disposeBag)
        
        //DatePicker
        datePicker.rx.controlEvent(.valueChanged).bind(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.dateTextComponent.textField.text = self.datePicker.date.toString(withFormat: Constants.DateFormat.MMddyyyy)
        }).disposed(by: disposeBag)
        
        datePicker.rx.controlEvent(.valueChanged).map {[weak self] _ in
            return self?.datePicker.date
        }.bind(to: viewModel.input.selectedDateObserver)
            .disposed(by: disposeBag)
        
        dateTextComponent.leftButton?.rx.tap.bind(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.dateTextComponent.textField.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        //Time Picker
        timePicker.rx.controlEvent(.valueChanged).bind(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.timeTextComponent.textField.text = self.timePicker.date.toString(withFormat: Constants.DateFormat.hMMa)
        }).disposed(by: disposeBag)
        
        timePicker.rx.controlEvent(.valueChanged).map {[weak self] _ in
            return self?.timePicker.date
        }.bind(to: viewModel.input.selectedDateObserver)
            .disposed(by: disposeBag)
        
        timeTextComponent.leftButton?.rx.tap.bind(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.timeTextComponent.textField.becomeFirstResponder()
        }).disposed(by: disposeBag)
    }
    
    func shouldEnableDateTimeView(_ shouldShowDisable: Bool) {
        self.dateTextComponent.state = shouldShowDisable ? .disable : .normal("")
        self.timeTextComponent.state = shouldShowDisable ? .disable : .normal("")
        self.dateTextComponent.textField.text = shouldShowDisable ? "" : self.dateTextComponent.textField.placeholder
        self.timeTextComponent.textField.text = shouldShowDisable ? "" :  self.timeTextComponent.textField.placeholder
    }
}
