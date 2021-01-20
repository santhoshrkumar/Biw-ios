//
//  RemovedDeviceTableHeader.swift
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
 A TableView section representing the Removed Device Table Header
 */
class RemovedDeviceTableHeader: UITableViewHeaderFooterView {
    
    // MARK: - Outlets
    /// Outlets
    @IBOutlet weak var headerLabel: UILabel! {
        didSet {
            headerLabel.font = .bold(ofSize: 16)
            headerLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var subHeaderLabel: UILabel! {
        didSet {
            subHeaderLabel.font = .regular(ofSize: 12)
            subHeaderLabel.textColor = UIColor.BiWFColors.med_grey
        }
    }

    // MARK: - Variable
    /// Header reuse identifier
    static let identifier = "RemovedDeviceTableHeader"
    var viewModel: RemovedDeviceTableHeaderViewModel!
    let disposeBag = DisposeBag()
}

/// Removed Device Table Header Extension
extension RemovedDeviceTableHeader: Bindable {
    // binding view to viewmodel
    func bindViewModel() {

        viewModel.output.headerTextDriver
            .drive(headerLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.subHeaderTextDriver
            .drive(subHeaderLabel.rx.text)
            .disposed(by: disposeBag)
    }
}


