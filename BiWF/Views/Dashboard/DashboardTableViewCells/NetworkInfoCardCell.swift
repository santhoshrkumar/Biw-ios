//
//  NetworkInfoCardCell.swift
//  BiWF
//
//  Created by varun.b.r on 10/11/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import DPProtocols
/*
 NetworkInfoCardCell to show network info on Dashboard
 */
class NetworkInfoCardCell: UITableViewCell {
    
    /// Outlets
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var networkInfoCardView: NetworkInfoCardView! {
        didSet {
            networkInfoCardView.cornerRadius = 16
            networkInfoCardView.addShadow(16)
        }
    }
    
    @IBOutlet weak var guestInfoCardView: NetworkInfoCardView! {
        didSet {
            guestInfoCardView.cornerRadius = 16
            guestInfoCardView.addShadow(16)
        }
    }
    
    /// Reuse cell Identifier
    static let identifier = "NetworkInfoCardCell"
    
    /// Vairables/Constants
    private var disposeBag = DisposeBag()
    
    /// Holds NetworkInfoCardCellViewModel with strong reference
    var viewModel: NetworkInfoCardCellViewModel!
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}

/// NetworkInfoCardCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension NetworkInfoCardCell: Bindable {
    
    /// Binding all the input and output observers from viewmodel to get the events and values
    func bindViewModel() {
        
        viewModel.output.myNetworkViewModelObservable.subscribe(onNext: { [weak self] viewModel in
            guard let self = self else { return }
            self.networkInfoCardView.setViewModel(to: viewModel)
        }).disposed(by: disposeBag)
        
        viewModel.output.guestNetworkViewModelObservable.subscribe(onNext: { [weak self] viewModel in
            guard let self = self else { return }
            self.guestInfoCardView.setViewModel(to: viewModel)
        }).disposed(by: disposeBag)
    }
}
