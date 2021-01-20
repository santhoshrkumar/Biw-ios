//
//  UsageDetailsView.swift
//  BiWF
//
//  Created by pooja.q.gupta on 23/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
/*
UsageDetailView to show usage details information
*/
class UsageDetailView: UIStackView {
    
    /// Outlets
    @IBOutlet weak var downloadDetailLabel: UILabel! {
        didSet {
            downloadDetailLabel.font = .regular(ofSize: UIFont.font48)
            downloadDetailLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var downloadUnitLabel: UILabel! {
        didSet {
            downloadUnitLabel.font = .regular(ofSize: UIFont.font12)
            downloadUnitLabel.textColor = UIColor.BiWFColors.med_grey
        }
    }
    @IBOutlet weak var uploadDetailLabel: UILabel! {
        didSet {
            uploadDetailLabel.font = .regular(ofSize: UIFont.font48)
            uploadDetailLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var uploadUnitLabel: UILabel! {
        didSet {
            uploadUnitLabel.font = .regular(ofSize: UIFont.font12)
            uploadUnitLabel.textColor = UIColor.BiWFColors.med_grey
        }
    }
    
    /// Holds UsageDetailViewModel with strong reference
    var viewModel: UsageDetailViewModel!
    let disposeBag = DisposeBag()
    
    // MARK: - Intializers
    required init(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    /// Initial UI setup
    func initialSetup() {
        guard let containerView = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIStackView else { return }
        self.addSubview(containerView)
        constrainToSelf(with: containerView)
        containerView.setCustomSpacing(Constants.UsageDetailsView.spaceAfterDownloadUnitLabel, after: downloadUnitLabel)
    }
}

/// UsageDetailView extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension UsageDetailView: Bindable {
    func bindViewModel() {
        bindOutput()
    }
    
    /// Binding all the output observers from viewmodel to get the values
    func bindOutput() {
        viewModel.output.downloadDetailsDriver
            .drive(downloadDetailLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.downloadUnitDriver
            .drive(downloadUnitLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.uploadDetailsDriver
            .drive(uploadDetailLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.uploadUnitDriver
            .drive(uploadUnitLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
