//
//  InstallationCompletedTableViewCell.swift
//  BiWF
//
//  Created by pooja.q.gupta on 26/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/*
 InstallationCompletedTableViewCell to show installation completed status
 */
class InstallationCompletedTableViewCell: UITableViewCell {
    
    /// reuse identifier
    static let identifier = "InstallationCompletedTableViewCell"
    
    /// Outlets
    @IBOutlet weak var cellBackgroundView: UIView! {
        didSet {
            cellBackgroundView.addShadow(16)
        }
    }
    @IBOutlet weak var installationStatusView: InstallationStatusView!
    @IBOutlet weak var allSetLabel: UILabel! {
        didSet {
            allSetLabel.font = .bold(ofSize: UIFont.font16)
            allSetLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = .regular(ofSize: UIFont.font12)
            descriptionLabel.textColor = UIColor.BiWFColors.med_grey
        }
    }
    @IBOutlet weak var getStartedButton: Button! {
        didSet {
            getStartedButton.style = .filledBackground
        }
    }
    
    //Variables/Constants
    private let disposeBag = DisposeBag()
    
    /// Holds InstallationCompletedCellViewModel with strong reference
    var viewModel: InstallationCompletedCellViewModel!
}

/// InstallationCompletedTableViewCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension InstallationCompletedTableViewCell: Bindable {
    
    /// Binding all the output observers from viewmodel to get the values
    func bindViewModel() {
        
        viewModel.output.welcomeTextDriver
            .drive(allSetLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.descriptionTextDriver
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.getStartedTextDriver
            .drive(getStartedButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.output.installationStatusViewModelObservable.subscribe(onNext: { [weak self] installationStatusViewModel in
            guard let self = self else { return }
            self.installationStatusView.setViewModel(to: installationStatusViewModel)
        }).disposed(by: disposeBag)
        
        getStartedButton.rx.tap
            .bind(to: viewModel.input.getStartedTappedObvserver)
            .disposed(by: disposeBag)
    }
}
