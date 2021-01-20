//
//  OnlineStatusCell.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 6/25/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa

class OnlineStatusCell: UITableViewCell {

    /// reuse identifier
    static let identifier = "OnlineStatusCell"

    /// This will create OnlineStatusView from nib
    private var onlineStatusView = OnlineStatusView.createFromNib() {
        didSet {
            onlineStatusView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(onlineStatusView)
            onlineStatusView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            onlineStatusView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            onlineStatusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            onlineStatusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        }
    }
    
    /// Constants/Variables
    var viewModel: OnlineStatusCellViewModel!
    private let disposeBag = DisposeBag()
}

/// OnlineStatus Cell Extension
extension OnlineStatusCell: Bindable {
    /// binding  viewModelObservable to viewmodel
    func bindViewModel() {
        viewModel.output.viewModelObservable
            .bind {[weak self] viewModel in
                guard let self = self else { return }
                self.onlineStatusView.setViewModel(to: viewModel)
            }.disposed(by: disposeBag)
    }
}
