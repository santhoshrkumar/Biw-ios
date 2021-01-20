//
//  NetworkDetailTableViewCell.swift
//  BiWF
//
//  Created by pooja.q.gupta on 13/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/*
   NetworkDetailTableViewCell representing the network details
**/
class NetworkDetailTableViewCell: UITableViewCell {
    
    /// reuse identifier
    static let identifier = "NetworkDetailTableViewCell"
    
    /// Outlets
    @IBOutlet weak var networkDetailView: NetworkView!
    
    ///Variables/Constants
    private let disposeBag = DisposeBag()
    var viewModel: NetworkDetailCellViewModel!
}

extension NetworkDetailTableViewCell: Bindable {
    /// binding viewmodel to networkDetailView
    func bindViewModel() {
        viewModel.output.networkViewModelObservable.subscribe(onNext: { [weak self] viewmodel in
            guard let self = self else { return }
            self.networkDetailView.setViewModel(to: viewmodel)
        }).disposed(by: disposeBag)
    }
}
