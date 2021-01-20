//
//  AdditionalInfoViewController.swift
//  BiWF
//
//  Created by pooja.q.gupta on 04/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
import RxDataSources
/*
 AdditionalInfoViewController for the user to add additional information
 */
class AdditionalInfoViewController: UIViewController, Storyboardable {
    
    /// Bar buttons
    var cancelButton: UIBarButtonItem!
    var backButton: UIBarButtonItem!
    
    /// Holds the AdditionalInfoViewModel with strong reference
    var viewModel: AdditionalInfoViewModel!
    
    let disposeBag = DisposeBag()
    
    /// Outlets
    @IBOutlet weak var moreInfoNextButton: Button!
    
    @IBOutlet weak var moreInfoLabel: UILabel! {
        didSet {
            moreInfoLabel.textColor = UIColor.BiWFColors.purple
            moreInfoLabel.font = .bold(ofSize: UIFont.font16)
        }
    }
    
    @IBOutlet weak var additionalInfoTextView: TextView! {
        didSet {
            additionalInfoTextView.placholder = Constants.AdditionalInfo.additionalInfoPlaceholder
            additionalInfoTextView.maxLength = Constants.AdditionalInfo.additionalInfoTextLenght
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        AnalyticsEvents.trackScreenVisitEvent(with: AnalyticsConstants.EventScreenName.additionalInfo)
    }
    
    //MARK:- Navigation bar setup
    func setNavigationBar() {
        self.title = Constants.AdditionalInfo.additionalInfo
        setBackButton()
        setCancelButton()
    }
    
    ///Backbutton setup
    func setBackButton() {
        backButton = UIBarButtonItem.init(image: UIImage.init(named: Constants.Common.backButtonImageName),
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        backButton.defaultSetup()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    ///Cancelbutton setup
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
/// AdditionalInfoViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension AdditionalInfoViewController: Bindable {
    func bindViewModel() {
        bindInputs()
        bindOutputs()
    }
    
    /// Binding all the input observers from viewmodel to get the events
    func bindInputs() {
        cancelButton.rx.tap
            .subscribe(onNext: { (_) in
                AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.additionalInfoCancel)
                self.viewModel.input.cancelTapObserver.onNext(())
            })
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .subscribe(onNext: { (_) in
                AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.additionalInfoBack)
                self.viewModel.input.backTapObserver.onNext(())
            })
            .disposed(by: disposeBag)
        
        moreInfoNextButton.rx.tap.bind {
            self.viewModel.scheduleCallBack.callbackReason = self.additionalInfoTextView.text
            self.viewModel.input.moreInfoObserver.onNext(self.viewModel.scheduleCallBack)
        }.disposed(by: disposeBag)
    }
    
    /// Binding all the output drivers from viewmodel to get the values
    func bindOutputs() {
        viewModel.output.moreInfoTextDriver
        .drive(moreInfoLabel.rx.attributedText)
        .disposed(by: disposeBag)
        
        viewModel.output.nextButtonTextDriver
        .drive(moreInfoNextButton.rx.title())
        .disposed(by: disposeBag)
    }
}
