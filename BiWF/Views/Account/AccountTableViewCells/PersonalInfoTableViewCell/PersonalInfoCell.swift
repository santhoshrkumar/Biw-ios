//
//  PersonalInfoCell.swift
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
 A TableView cell representing the personal information
 */
class PersonalInfoCell: UITableViewCell {
    
    /// reuse identifier
    static let identifier = "PersonalInfoCell"
    
    /// Outlets
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var cellPhoneLabel: UILabel!
    @IBOutlet weak var cellPhoneValueField: UITextView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailValueLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordValueLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    
    /// Holds the PersonalInfoCellViewModel with a strong reference
    var viewModel: PersonalInfoCellViewModel!
    
    /// Setting different attributes for the labels
    private func initialSetup() {
        headerLabel.font = .bold(ofSize: UIFont.font20)
        headerLabel.textColor = UIColor.BiWFColors.purple
        cellPhoneLabel.font = .regular(ofSize: UIFont.font16)
        cellPhoneLabel.textColor = UIColor.BiWFColors.med_grey
        cellPhoneValueField.font = .regular(ofSize: UIFont.font16)
        cellPhoneValueField.textColor = UIColor.BiWFColors.dark_grey
        cellPhoneValueField.textContainerInset = UIEdgeInsets.zero
        cellPhoneValueField.sizeToFit()
        cellPhoneValueField.isScrollEnabled = false
        cellPhoneValueField.textContainerInset = UIEdgeInsets.zero
        cellPhoneValueField.textContainer.lineFragmentPadding = 0
        emailLabel.font = .regular(ofSize: UIFont.font16)
        emailLabel.textColor = UIColor.BiWFColors.med_grey
        emailValueLabel.font = .regular(ofSize: UIFont.font16)
        emailValueLabel.textColor = UIColor.BiWFColors.dark_grey
        passwordLabel.font = .regular(ofSize: UIFont.font16)
        passwordLabel.textColor = UIColor.BiWFColors.med_grey
        passwordValueLabel.font = .regular(ofSize: UIFont.font18)
        passwordValueLabel.textColor = UIColor.BiWFColors.dark_grey
        backgroundColor = UIColor.BiWFColors.white
        
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

/// PersonalInfoCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension PersonalInfoCell: Bindable {
    /// Binding all the drivers from viewmodel to get the values
    func bindViewModel() {
        initialSetup()
        viewModel.header
            .drive(headerLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.cellPhoneText
            .drive(cellPhoneLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.cellPhoneValue
            .drive(cellPhoneValueField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.emailInfoText
            .drive(emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.emailInfoValue
            .drive(emailValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.passwordText
            .drive(passwordLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.passwordValue
            .drive(passwordValueLabel.rx.text)
            .disposed(by: disposeBag)
    }
}



