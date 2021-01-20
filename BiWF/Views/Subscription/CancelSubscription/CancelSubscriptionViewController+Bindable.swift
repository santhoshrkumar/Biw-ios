//
//  CancelSubscriptionViewController+Bindable.swift
//  BiWF
//
//  Created by pooja.q.gupta on 28/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxCocoa
import DPProtocols
import RxSwift
import RxKeyboard

//MARK:- Bindable
/// CancelSubscriptionViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension CancelSubscriptionViewController: Bindable {
    func bindViewModel() {
        bindInput()
        bindOutput()
        bindEvents()
        bindKeyboardEvents()
        bindViewStatus()
    }
    
    /// Binding all the input observers from viewmodel to get the events
    func bindInput() {
        cancelButton.rx.tap.bind(onNext: {[weak self] _ in
            AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.cancelSubscriptionDetailCancel)
            self?.viewModel.input.cancelTapObserver.onNext(())
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.bind(onNext: {[weak self] _ in
            AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.cancelSubscriptionDetailBack)
            self?.viewModel.input.backTapObserver.onNext(())
        }).disposed(by: disposeBag)
        
        commentsTextView.rx.text
            .bind(to: viewModel.input.commentsObserver)
            .disposed(by: disposeBag)
    }
    
    /// Binding all the output drivers from viewmodel to get the values
    func bindOutput() {
        //Label
        viewModel.output.headerTextDriver
            .drive(headerLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.rateExperienceTextDriver
            .drive(ratingLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.output.specifyReasonTextDriver
            .drive(specifyReasonLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.output.commentsTextDriver
            .drive(commentsLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        //Button
        viewModel.output.submitBtnTextDriver
            .drive(submitButton.rx.title())
            .disposed(by: disposeBag)
        
        //ViewModel
        viewModel.output.pickerViewModelObservable.subscribe(onNext: { [weak self] pickerViewModel in
            guard let self = self else { return }
            self.cancellationReasonPicker.setViewModel(to: pickerViewModel)
        }).disposed(by: disposeBag)
        
        viewModel.output.ratingViewModelObservable.subscribe(onNext: { [weak self] ratingViewModel in
            guard let self = self else { return }
            self.ratingView.setViewModel(to: ratingViewModel)
        }).disposed(by: disposeBag)
        
        viewModel.output.cancellationReasonSelectedObservable
            .subscribe(onNext: {[weak self] (reason) in
                self?.hideCancellationReasonView((reason != Constants.CancelSubscription.CancellationReason.other))
            }).disposed(by: disposeBag)
        
        viewModel.output.cancellationReasonSelectedObservable
            .bind(to: cancellationReasonView.textField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.ratingUpdatedObservable
            .subscribe(onNext: {[weak self] (_) in
                self?.view.endEditing(true)
            }).disposed(by: disposeBag)
        
        viewModel.output.cancellationDateObservable
            .subscribe(onNext: {[weak self] date in
                if let cancellationDate = date {
                    self?.cancellationDateView.textField.text = cancellationDate.toString(withFormat: DateFormat.MMMMddyyyy)
                }
            }).disposed(by: disposeBag)
    }
    
    /// Binding all the events from viewmodel
    func bindEvents() {
        tapGesture.rx.event.subscribe(onNext: {[weak self] recognizer in
            self?.view.endEditing(true)
        }).disposed(by: disposeBag)
        
        //DatePicker
        datePicker.rx.controlEvent(.valueChanged).subscribe(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.cancellationDateView.textField.text = self.datePicker.date.toString(withFormat: DateFormat.MMMMddyyyy)
        }).disposed(by: disposeBag)
        
        datePicker.rx.controlEvent(.valueChanged).map {[weak self] _ in
            return self?.datePicker.date
        }.bind(to: viewModel.input.cancellationDateObserver)
            .disposed(by: disposeBag)
        
        // button
        submitButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.view.endEditing(true)
            self.isValidDate() ? self.showConfirmationAlert() : self.showValidationError(true)
            AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.submitCancelSubscription)
        }).disposed(by: disposeBag)
        
        cancellationDateView.leftButton?.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.cancellationDateView.textField.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        cancellationReasonView.rightButton?.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.cancellationReasonView.textField.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        //textfield
        cancellationDateView.textField.rx.controlEvent(.editingDidBegin).subscribe(onNext: {[weak self] _ in
            guard let self = self else {return}
            self.showValidationError(false)
        }).disposed(by: disposeBag)
    }
    
    /// Bindng keyboard events from viewModel
    func bindKeyboardEvents() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                self?.constraintScrollviewBottom.constant = keyboardVisibleHeight
                if let activeTextfieldFrame = self?.activeTextfieldFrame {
                    self?.scrollview.scrollRectToVisible(activeTextfieldFrame, animated: true)
                }
                self?.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    /// Binding the view status
    func bindViewStatus() {
        
        viewModel.output.viewStatusObservable.subscribe(onNext: { [weak self] viewStatus in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch viewStatus{
                case .loading(let message):
                    self.view.showLoaderView(with: message)
                    
                case .loaded:
                    self.view.removeSubView()
                    
                case .error(_, _):
                    self.view.removeSubView()
                }
            }
        }).disposed(by: disposeBag)
    }
}

