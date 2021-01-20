//
//  PreferenceAndSettingsCell.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 09/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/**
 A TableView cell representing the preference and setting information
 */
class PreferenceAndSettingsCell: UITableViewCell {
    
    /// reuse identifier
    static let identifier = "PreferenceAndSettingsCell"
    
    /// Outlets
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var logInSettingsHeaderLabel: UILabel!
    @IBOutlet weak var useFaceIDLabel: UILabel!
    @IBOutlet weak var faceIDSwitch: UISwitch!
    @IBOutlet weak var communicationPreferenceHeaderLabel: UILabel!
    @IBOutlet weak var serviceCallTextLabel: UILabel!
    @IBOutlet weak var serviceCallDescriptionLabel: UILabel!
    @IBOutlet weak var serviceCallSwitch: UISwitch!
    @IBOutlet weak var marketingEmailTextLabel: UILabel!
    @IBOutlet weak var marketingEmailDescriptionLabel: UILabel!
    @IBOutlet weak var marketingEmailSwitch: UISwitch!
    @IBOutlet weak var marketingTextCallLabel: UILabel!
    @IBOutlet weak var marketingTextCallDescriptionLabel: UILabel!
    @IBOutlet weak var marketingTextCallSwitch: UISwitch!
    
    private var disposeBag = DisposeBag()
    
    // Holds the PreferenceAndSettingsCellViewModel with a strong reference
    var viewModel: PreferenceAndSettingsCellViewModel!
    
    /// Observable for change in face id
    var changeFaceIdObservableValue: Observable<Bool>?
    
    /// Observable for change in service call
    var changeServiceCallObservableValue: Observable<Bool>?
    
    /// Observable for change in marketing email
    var changeMarketingEmailObservableValue: Observable<Bool>?
    
    /// Observable for change in marketing call
    var changeMarketingCallObservableValue: Observable<Bool>?
    
    /// Setting different attributes for the labels
    private func initialSetup() {
        self.headerLabel.font = .bold(ofSize: UIFont.font20)
        self.headerLabel.textColor = UIColor.BiWFColors.purple
        self.logInSettingsHeaderLabel.font = .bold(ofSize: UIFont.font16)
        self.logInSettingsHeaderLabel.textColor = UIColor.BiWFColors.purple
        self.useFaceIDLabel.font = .regular(ofSize: UIFont.font16)
        self.useFaceIDLabel.textColor = UIColor.BiWFColors.dark_grey
        self.communicationPreferenceHeaderLabel.font = .bold(ofSize: UIFont.font16)
        self.communicationPreferenceHeaderLabel.textColor = UIColor.BiWFColors.purple
        self.serviceCallTextLabel.font = .regular(ofSize: UIFont.font16)
        self.serviceCallTextLabel.textColor = UIColor.BiWFColors.dark_grey
        self.serviceCallDescriptionLabel.font = .regular(ofSize: UIFont.font12)
        self.serviceCallDescriptionLabel.textColor = UIColor.BiWFColors.med_grey
        self.marketingEmailTextLabel.font = .regular(ofSize: UIFont.font16)
        self.marketingEmailTextLabel.textColor = UIColor.BiWFColors.dark_grey
        self.marketingEmailDescriptionLabel.font = .regular(ofSize: UIFont.font12)
        self.marketingEmailDescriptionLabel.textColor = UIColor.BiWFColors.med_grey
        self.marketingTextCallLabel.font = .regular(ofSize: UIFont.font16)
        self.marketingTextCallLabel.textColor = UIColor.BiWFColors.dark_grey
        self.marketingTextCallDescriptionLabel.font = .regular(ofSize: UIFont.font12)
        self.marketingTextCallDescriptionLabel.textColor = UIColor.BiWFColors.med_grey
        
        /// Setting tableview selection background to clear color
        let selectionBackgroundView = UIView()
        selectionBackgroundView.backgroundColor = .clear
        UITableViewCell.appearance().selectedBackgroundView = selectionBackgroundView

    }
    
///this is called just before the cell is returned from the table view method
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

/// PreferenceAndSettingsCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension PreferenceAndSettingsCell: Bindable {
    func bindViewModel() {
        initialSetup()
        bindOutputs()
        bindInputs()
    }
    
    /// Binding all the output drivers from viewmodel to get the values
    private func bindOutputs() {
        viewModel.output.header
            .drive(headerLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.loginSettingsHeader
            .drive(logInSettingsHeaderLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.faceIDText
            .drive(useFaceIDLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.communicationPreferenceHeader
            .drive(communicationPreferenceHeaderLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.serviceCallText
            .drive(serviceCallTextLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.serviceCallDescriptionText
            .drive(serviceCallDescriptionLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.marketingEmailText
            .drive(marketingEmailTextLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.marketingEmailDescriptionText
            .drive(marketingEmailDescriptionLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.marketingCallText
            .drive(marketingTextCallLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.marketingCallDescriptionText
            .drive(marketingTextCallDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.faceIDSwitch
            .drive(faceIDSwitch.rx.isOn)
            .disposed(by: disposeBag)

        viewModel.output.serviceCallSwitch
            .drive(serviceCallSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        viewModel.output.marketingEmailSwitch
            .drive(marketingEmailSwitch.rx.isOn)
            .disposed(by: disposeBag)

        viewModel.output.marketingCallSwitch
            .drive(marketingTextCallSwitch.rx.isOn)
            .disposed(by: disposeBag)

    }

    /// Binding all the input observers from viewmodel to get the events
    private func bindInputs() {

        faceIDSwitch.rx.isOn.changed.subscribe(onNext: { (value) in
            AnalyticsEvents.trackBiometricEvent(with: value)
            self.viewModel.input.faceIDSwitchObserver.onNext(value)
        }).disposed(by: disposeBag)

        serviceCallSwitch.rx.isOn.changed.subscribe(onNext: { (value) in
            AnalyticsEvents.trackToggleButtonChangeEvent(with: AnalyticsConstants.EventToggleButton.Name.serviceCalls, value: value)
            self.viewModel.input.serviceCallSwitchObserver.onNext(value)
        }).disposed(by: disposeBag)
            
        marketingEmailSwitch.rx.isOn.changed.subscribe(onNext: { (value) in
            AnalyticsEvents.trackToggleButtonChangeEvent(with: AnalyticsConstants.EventToggleButton.Name.marketingEmails, value: value)
            self.viewModel.input.marketingEmailSwitchObserver.onNext(value)
        }).disposed(by: disposeBag)
           

        marketingTextCallSwitch.rx.isOn.changed.subscribe(onNext: { (value) in
            AnalyticsEvents.trackToggleButtonChangeEvent(with: AnalyticsConstants.EventToggleButton.Name.marketingCallsTexts, value: value)
            self.viewModel.input.marketingCallSwitchObserver.onNext(value)
        }).disposed(by: disposeBag)
                
        changeFaceIdObservableValue = faceIDSwitch.rx.isOn.changed.asObservable()
        changeServiceCallObservableValue = serviceCallSwitch.rx.isOn.changed.asObservable()
        changeMarketingEmailObservableValue = marketingEmailSwitch.rx.isOn.changed.asObservable()
        changeMarketingCallObservableValue = marketingTextCallSwitch.rx.isOn.changed.asObservable()
    }
}
