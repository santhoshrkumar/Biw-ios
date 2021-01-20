//
//  AccountOwnerDetailsCell.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 10/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/**
 A TableView cell representing the account owner details
 */
class AccountOwnerDetailsCell: UITableViewCell {
    
    /// reuse identifier
    static let identifier = "AccountOwnerDetailsCell"
    
    /// Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var serviceAddressLabel: UILabel!
    @IBOutlet weak var serviceAddressValueLabel: UILabel!
    @IBOutlet weak var serviceUnitLabel: UILabel!
    @IBOutlet weak var serviceCityLabel: UILabel!
    @IBOutlet weak var serviceStateLabel: UILabel!
    @IBOutlet weak var serviceZipLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    
    /// Holds the AccountOwnerDetailsCellViewModel with a strong reference
    var viewModel: AccountOwnerDetailsCellViewModel!
    
    /// Setting different attributes for the labels
    private func initialSetup() {
        self.nameLabel.font = .bold(ofSize: UIFont.font24)
        self.nameLabel.textColor = UIColor.BiWFColors.purple
        self.serviceAddressLabel.font = .regular(ofSize: UIFont.font16)
        self.serviceAddressLabel.textColor = UIColor.BiWFColors.med_grey
        self.serviceAddressValueLabel.sizeToFit()
        self.serviceAddressValueLabel.font = .systemFont(ofSize: UIFont.font16)
        self.serviceAddressValueLabel.textColor = UIColor.BiWFColors.dark_grey
        self.serviceUnitLabel.font = .systemFont(ofSize: UIFont.font16)
        self.serviceUnitLabel.textColor = UIColor.BiWFColors.dark_grey
        self.serviceUnitLabel.sizeToFit()
        self.serviceCityLabel.font = .systemFont(ofSize: UIFont.font16)
        self.serviceCityLabel.textColor = UIColor.BiWFColors.dark_grey
        self.serviceStateLabel.font = .systemFont(ofSize: UIFont.font16)
        self.serviceStateLabel.textColor = UIColor.BiWFColors.dark_grey
        self.serviceZipLabel.font = .systemFont(ofSize: UIFont.font16)
        self.serviceZipLabel.textColor = UIColor.BiWFColors.dark_grey
        
        
        self.backgroundColor = UIColor.BiWFColors.white
        
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

/// AccountOwnerDetailsCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension AccountOwnerDetailsCell: Bindable {
    /// Binding all the drivers from viewmodel to get the values
    func bindViewModel() {

        initialSetup()
        
        viewModel.nameTextDriver
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.serviceAdressTextDriver
            .drive(serviceAddressLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.serviceAdressValueDriver
            .drive(serviceAddressValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.serviceCityDriver
            .drive(serviceCityLabel.rx.text)
        .disposed(by: disposeBag)
        
        viewModel.serviceStateDriver
            .drive(serviceStateLabel.rx.text)
        .disposed(by: disposeBag)
        
        viewModel.serviceUnitDriver
            .drive(serviceUnitLabel.rx.text)
        .disposed(by: disposeBag)
        
        viewModel.serviceZipDriver
            .drive(serviceZipLabel.rx.text)
        .disposed(by: disposeBag)
    }
}
