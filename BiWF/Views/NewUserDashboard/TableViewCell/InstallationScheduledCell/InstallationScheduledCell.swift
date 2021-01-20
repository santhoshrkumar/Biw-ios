//
//  InstallationStatusCell.swift
//  BiWF
//
//  Created by pooja.q.gupta on 30/03/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/*
 InstallationScheduledCell to show the scheduled call for installation
 */
class InstallationScheduledCell: UITableViewCell {
    
    /// reuse identifier
    static let identifier = "InstallationScheduledCell"
    
    ///Outlets
    @IBOutlet weak var cellBackgroundView: UIView! {
        didSet {
            cellBackgroundView.addShadow(16)
        }
    }
    @IBOutlet weak var statusView: InstallationStatusView!
    @IBOutlet weak var appointmentView: UIView! {
        didSet {
            appointmentView.backgroundColor = UIColor.BiWFColors.lavender.withAlphaComponent(0.1)
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.font = .bold(ofSize: UIFont.font36)
            dateLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.font = .regular(ofSize: UIFont.font12)
            timeLabel.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var changeAppointmentButton: Button! {
        didSet {
            changeAppointmentButton.style = .bordered
        }
    }
    @IBOutlet weak var cancelAppointmentButton: Button! {
        didSet {
            cancelAppointmentButton.style = .bordered
        }
    }
    
    /// varibales/Constants
    private var disposeBag = DisposeBag()
    
    
    /// Holds InstallationScheduledCellViewModel with strong reference
    var viewModel: InstallationScheduledCellViewModel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

/// InstallationScheduledCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension InstallationScheduledCell: Bindable {
    
    /// Binding all the input and output observers from viewmodel to get the events and values
    func bindViewModel() {
        
        viewModel.output.appointmentDateTextDriver
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.appointmentTimeTextDriver
            .drive(timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.changeAppointmentDriver
            .drive(changeAppointmentButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.output.cancelAppointmentDriver
            .drive(cancelAppointmentButton.rx.title())
            .disposed(by: disposeBag)
        
        cancelAppointmentButton.rx.tap
            .bind(to: viewModel.input.cancelAppointmentObserver)
            .disposed(by: disposeBag)
        
        changeAppointmentButton.rx.tap
            .bind(to: viewModel.input.changeAppointmentObserver)
            .disposed(by: disposeBag)
        
        viewModel.output.installationStatusViewModelObservable.subscribe(onNext: { [weak self] installationStatusViewModel in
            guard let self = self else { return }
            self.statusView.setViewModel(to: installationStatusViewModel)
        }).disposed(by: disposeBag)
    }
}


