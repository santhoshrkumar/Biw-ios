//
//  WiFiNetworkCell.swift
//  BiWF
//
//  Created by pooja.q.gupta on 29/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import DPProtocols
/*
WiFiNetworkCell shows the wifi network
*/
class WiFiNetworkCell: UITableViewCell {
    
    /// reuse identifier
    static let identifier = "WiFiNetworkCell"
    
    /// Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.cornerRadius = 8
            containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            containerView.addShadow(16)
        }
    }
    @IBOutlet weak var myHomeNetworkView: WifiNetworkView!
    @IBOutlet weak var guestNetworkView: WifiNetworkView!
    
    /// Vairables/Constants
    private var disposeBag = DisposeBag()
    
    /// Holds WiFiNetworkCellViewModel with strong reference
    var viewModel: WiFiNetworkCellViewModel!
    
    override func prepareForReuse() {
       disposeBag = DisposeBag()
    }
}

/// WiFiNetworkCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension WiFiNetworkCell: Bindable {
    
    /// Binding all the input and output observers from viewmodel to get the events and values
    func bindViewModel() {
        
        viewModel.output.myNetworkViewModelObservable.subscribe(onNext: { [weak self] viewModel in
            guard let self = self else { return }
            self.myHomeNetworkView.setViewModel(to: viewModel)
        }).disposed(by: disposeBag)
        
        viewModel.output.guestNetworkViewModelObservable.subscribe(onNext: { [weak self] viewModel in
            guard let self = self else { return }
            self.guestNetworkView.setViewModel(to: viewModel)
        }).disposed(by: disposeBag)
    }
}
