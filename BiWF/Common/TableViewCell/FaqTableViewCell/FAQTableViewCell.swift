//
//  FAQTableViewCell.swift
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
 FAQTableViewCell to show FAQ option
 */
class FAQTableViewCell: UITableViewCell {
    
    /// reuse identifier
    static let identifier = "FAQTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    ///Holds FaqCellViewModel with strong reference
    var viewModel: FaqCellViewModel!
}

/// FAQTableViewCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension FAQTableViewCell: Bindable {
    /// Binding all the iobservers from viewmodel to get the values
    func bindViewModel() {
        
        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
