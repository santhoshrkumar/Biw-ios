//
//  AppointmentCancelledTableViewCell.swift
//  BiWF
//
//  Created by pooja.q.gupta on 07/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/*
 AppointmentCancelledTableViewCell to show cancelled appointment
 */
class AppointmentCancelledTableViewCell: UITableViewCell {
    /// reuse identifier
    static let identifier = "AppointmentCancelledTableViewCell"
    
    ///Outlets
    @IBOutlet weak var cellBackgroundView: UIView! {
        didSet {
            cellBackgroundView.addShadow(Constants.AppointmentCancelledCell.cornerRadius)
        }
    }
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.font = .regular(ofSize: UIFont.font16)
            descriptionTextView.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var statusView: InstallationStatusView! {
        didSet {
            statusView.statusLabel.font = .bold(ofSize: UIFont.font12)
            statusView.statusLabel.textColor = UIColor.BiWFColors.med_grey
        }
    }
    
    /// varibales/Constants
    private var disposeBag = DisposeBag()
    
    /// Holds AppointmentCancelledCellViewModel with strong reference
    var viewModel: AppointmentCancelledCellViewModel!
}

/// AppointmentCancelledTableViewCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension AppointmentCancelledTableViewCell: Bindable {
    /// Binding all the input and output observers from viewmodel to get the events and values
    func bindViewModel() {
        
        viewModel.output.descriptionTextDriver
            .drive(descriptionTextView.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.installationStatusViewModelObservable.subscribe(onNext: { [weak self] installationStatusViewModel in
            guard let self = self else { return }
            self.statusView.setViewModel(to: installationStatusViewModel)
        }).disposed(by: disposeBag)
    }
}
