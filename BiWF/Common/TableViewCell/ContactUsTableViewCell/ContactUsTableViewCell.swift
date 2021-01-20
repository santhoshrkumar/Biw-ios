//
//  ContactUsTableViewCell.swift
//  BiWF
//
//  Created by pooja.q.gupta on 09/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import DPProtocols
/*
 ContactUsTableViewCell shows the contact us option
 */
class ContactUsTableViewCell: UITableViewCell {
    /// reuse identifier
    static let identifier = "ContactUsTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = .regular(ofSize: 12)
            descriptionLabel.textColor = UIColor.BiWFColors.med_grey.withAlphaComponent(0.5)
        }
    }
    
    private let disposeBag = DisposeBag()
    
    /// Holds ContactUsCellViewModel with strong reference
    var viewModel: ContactUsCellViewModel!
}

/// ContactUsTableViewCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension ContactUsTableViewCell: Bindable {
    /// Binding all the observers from viewmodel to get the values
    func bindViewModel() {
        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.description
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
