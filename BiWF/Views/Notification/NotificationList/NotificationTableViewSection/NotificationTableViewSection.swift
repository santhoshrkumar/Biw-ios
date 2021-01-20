//
//  NotificationTableViewSection.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 27/03/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/**
 A TableView section representing the notification list header
 */
class NotificationTableViewSection: UITableViewHeaderFooterView {
    /// Outlets
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var sectionButton: UIButton!
    @IBOutlet weak var dividerLine: UIView!

    /// Header reuse identifier
    static let identifier = "NotificationTableViewSection"
    var viewModel: NotificationSectionViewModel!
    var section: Int = 0
    let disposeBag = DisposeBag()
    
    /**
     Closure to section button tapped
     */
    var sectionButtonTappedClosure: ((Int, ButtonType) -> ())?
    
    /// Event Handling for section header button clicked
    /// - Parameter sender: UIButton
    @IBAction func setionButtonPressed(_ sender: UIButton) {
        let buttonType: ButtonType = sectionButton.titleLabel?.text == ButtonType.clearAll.rawValue ? ButtonType.clearAll : ButtonType.markAllAsRead
        sectionButtonTappedClosure?(section, buttonType)
    }
}

/// NotificationTableViewCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension NotificationTableViewSection: Bindable {
    
    /// Binding all the output observers from viewmodel to get the values
    func bindViewModel() {

        viewModel.output.headerTextDriver
            .drive(header.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.buttonTitleTextDriver
            .drive(sectionButton.rx.attributedTitle(for: .normal))
            .disposed(by: disposeBag)
        
    }
}
