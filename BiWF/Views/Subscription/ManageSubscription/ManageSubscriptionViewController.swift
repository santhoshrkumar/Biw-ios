//
//  ManageSubscriptionViewController.swift
//  BiWF
//
//  Created by pooja.q.gupta on 14/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
/*
 ManageSubscriptionViewController to show the managed subscription details
 */
class ManageSubscriptionViewController: UIViewController, Storyboardable {
    
    /// Outlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var headerLabel: UILabel! {
        didSet {
            headerLabel.textColor = UIColor.BiWFColors.purple
            headerLabel.font = .bold(ofSize: UIFont.font16)
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.textColor = UIColor.BiWFColors.dark_grey
            descriptionLabel.font = .regular(ofSize: UIFont.font16)
        }
    }
    @IBOutlet weak var continueButton: Button! {
        didSet {
            continueButton.style = .rowType
        }
    }
    
    /// Barbuttons
    var doneButton: UIBarButtonItem!
    var backButton: UIBarButtonItem!
    
    /// Holds ManageSubscriptionViewModel with strong reference
    var viewModel: ManageSubscriptionViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavbar()
        AnalyticsEvents.trackScreenVisitEvent(with: AnalyticsConstants.EventScreenName.cancelSubscription)
    }
    
    /// Navigationbar setup
    func setNavbar() {
        self.title = Constants.Subscription.viewTitleText
        setBackButton()
        setDoneButton()
    }
    
    /// Backbutton setup
    func setBackButton() {
        backButton = UIBarButtonItem(image: UIImage.init(named: Constants.Common.backButtonImageName),
                                     style: .plain,
                                     target: nil,
                                     action: nil)
        backButton.defaultSetup()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    /// Donebutton setup
    func setDoneButton() {
        doneButton = UIBarButtonItem.init(title: Constants.Common.done.uppercased(),
                                            style: .plain,
                                            target: nil,
                                            action: nil)
        doneButton.defaultSetup()
        self.navigationItem.rightBarButtonItem = doneButton
    }
}

//MARK: Bindable
/// ManageSubscriptionViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension ManageSubscriptionViewController: Bindable {
    func bindViewModel() {
        bindInput()
        bindOutput()
    }
    
    /// Binding all the input observers from viewmodel to get the events
    func bindInput() {
        continueButton.rx.tap
            .bind(to: (viewModel.input.continueTapObserver))
            .disposed(by: disposeBag)
        
        doneButton.rx.tap.bind(onNext: {[weak self] _ in
            AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.cancelSubscriptionCancel)
            self?.viewModel.input.cancelTapObserver.onNext(())
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.bind(onNext: {[weak self] _ in
            AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.cancelSubscriptionBack)
            self?.viewModel.input.backTapObserver.onNext(())
        }).disposed(by: disposeBag)
    }
    
    /// Binding all the output drivers from viewmodel to get the values
    func bindOutput() {
        viewModel.output.headerTextDriver
            .drive(headerLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.descriptionTextDriver
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.continueBtnTextDriver
            .drive(continueButton.rx.title())
            .disposed(by: disposeBag)
    }
}

