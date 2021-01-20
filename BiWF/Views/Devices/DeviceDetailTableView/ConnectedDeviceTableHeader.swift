//
//  ConnectedDeviceTableHeader.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 18/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/**
 A TableView section representing the Connected Device Table Header
 */
class ConnectedDeviceTableHeader: UITableViewHeaderFooterView {
    
    // MARK: - Outlets
    /// Outlets
    @IBOutlet weak var header: UILabel! {
        didSet {
            header.font = .regular(ofSize: UIFont.font24)
            header.textColor = UIColor.BiWFColors.dark_grey
        }
    }
    @IBOutlet weak var sectionButton: UIButton!
    @IBOutlet weak var countLabel: UILabel! {
        didSet {
            countLabel.font = .bold(ofSize: 24)
            countLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var constraintSectionButtonWidth: NSLayoutConstraint!
    
    // MARK: - Variable
    /// Header reuse identifier
    static let identifier = "ConnectedDeviceTableHeader"
    var viewModel: ConnectedDeviceTableHeaderViewModel!
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

/// ConnectedDeviceTableHeader  Extension confirm Bindable protocol.
/// This is provide a standard interface to all it's internal elements to be bound to a view model
extension ConnectedDeviceTableHeader: Bindable {
    
    // binding view to viewmodel
    func bindViewModel() {
        
        viewModel.output.headerTextDriver
            .drive(header.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.countTextDriver
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.buttonTitleTextDriver
            .drive(sectionButton.rx.attributedTitle(for: .normal))
            .disposed(by: disposeBag)
        
        sectionButton.rx.tap
            .bind {[weak self] in
                guard let self = self else { return }
                self.viewModel.shouldExpandSubject.onNext(self.viewModel.isExpanded)
        }.disposed(by: disposeBag)
        
        if countLabel.text != "0" {
            let buttonImage = viewModel.isExpanded ?
                UIImage.init(named: Constants.FAQTopics.expandCellArrowImage) :
                UIImage.init(named: Constants.Device.collapseCellArrowImage)
            sectionButton.setImage(buttonImage, for: .normal)
            constraintSectionButtonWidth.constant = Constants.Device.buttonWidthConstant
        } else { constraintSectionButtonWidth.constant = 0 }
    }
}
