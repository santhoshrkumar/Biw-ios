//
//  AvailableTimeSlotTableViewCell.swift
//  BiWF
//
//  Created by pooja.q.gupta on 04/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import DPProtocols
/*
AvailableTimeSlotTableViewCell to show available time slot to book appointment
*/
class AvailableTimeSlotTableViewCell: UITableViewCell {
    
    /// reuse identifier
    static let identifier = "AvailableTimeSlotTableViewCell"
    
    /// Outlets
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.textColor = UIColor.BiWFColors.dark_grey
            timeLabel.font = .regular(ofSize: UIFont.font16)
        }
    }
    
    @IBOutlet weak var selectedButton: UIButton!
    
    /// Vairables/Constants
    private var disposeBag = DisposeBag()
    var viewModel: AvailableTimeSlotCellViewModel!
    
    /// It will call just before the cell is returned from the table view method
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

/// AvailableDatesTableViewCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension AvailableTimeSlotTableViewCell: Bindable {
    
    /// Binding all the output drivers from viewmodel to get the values
    func bindViewModel() {
        viewModel.output.titleDriver
            .drive(timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.isSelectedDriver
            .drive(onNext: { [weak self] isSelected in
                self?.selectedButton.setImage(UIImage(named: isSelected ?
                    Constants.AvailableTimeSlotTableViewCell.selected :
                    Constants.AvailableTimeSlotTableViewCell.unSelected), for: .normal)
            }).disposed(by: disposeBag)
        
        viewModel.output.showErrorState
            .drive(onNext: { [weak self] isError in
                if isError {
                    self?.selectedButton.setImage(UIImage(named: Constants.AvailableTimeSlotTableViewCell.unSelectedError), for: .normal)
                }
            }).disposed(by: disposeBag)
        
        selectedButton.rx.tap
            .bind(to: viewModel.input.isSelectedObserver)
            .disposed(by: disposeBag)
    }
}
