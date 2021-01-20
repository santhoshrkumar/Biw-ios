//
//  CustomAlertViewController.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 27/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
import RxFeedback
/*
 CustomAlertViewController to show the custom alert
 */
class CustomAlertViewController: UIViewController, Storyboardable {
    
    //Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView! {
        didSet {
            detailsTextView.isScrollEnabled = false
            detailsTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var closeButton: Button!
    
    /// Holds CustomAlertViewModel with strong reference
    var viewModel: CustomAlertViewModel!
    let disposeBag = DisposeBag()
}

/// CustomAlertViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension CustomAlertViewController: Bindable {
    /// Binding all the input and output observers from viewmodel to get the events and values
    func bindViewModel() {
        
        viewModel.output.titleTextDriver
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.buttonTitleTextDriver
            .drive(button.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.output.messageTextDriver
            .drive(detailsTextView.rx.attributedText)
            .disposed(by: disposeBag)
        
        if viewModel.isPresentedFromWindow {
            button.rx.tap
                .bind(to: viewModel.input.closeButtonTapObserver)
                .disposed(by: disposeBag)
            
            closeButton.rx.tap
                .bind(to: viewModel.input.closeButtonTapObserver)
                .disposed(by: disposeBag)
            
            viewModel.dismissSubject.subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        } else {
            button.rx.tap
                .bind(to: viewModel.input.buttonTapObserver)
                .disposed(by: disposeBag)
            
            closeButton.rx.tap
                .bind(to: viewModel.input.buttonTapObserver)
                .disposed(by: disposeBag)
        }
    }
}
