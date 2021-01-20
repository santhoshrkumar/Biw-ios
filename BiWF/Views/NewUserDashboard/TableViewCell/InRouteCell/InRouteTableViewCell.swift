//
//  InRouteTableViewCell.swift
//  BiWF
//
//  Created by pooja.q.gupta on 22/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
import MapKit
/*
 InRouteTableViewCell to show the in route appointment status
 */
class InRouteTableViewCell: UITableViewCell {
    
    /// reuse identifier
    static let identifier = "InRouteTableViewCell"
    
    /// Outlets
    @IBOutlet weak var cellBackgroundView: UIView! {
        didSet {
            cellBackgroundView.addShadow(16)
        }
    }
    @IBOutlet weak var installationStatusView: InstallationStatusView!
    @IBOutlet weak var mapView: MapView!
    @IBOutlet weak var technicianDetailView: TechnicianDetailView!
    
    //Variables/Constants
    private let disposeBag = DisposeBag()
    var viewModel: InRouteCellViewModel!
}

/// InRouteTableViewCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension InRouteTableViewCell: Bindable {
    
    /// Binding all the output observers from viewmodel to get the values
    func bindViewModel() {
        
        viewModel.output.installationStatusViewModelObservable.subscribe(onNext: { [weak self] installationStatusViewModel in
            guard let self = self else { return }
            self.installationStatusView.setViewModel(to: installationStatusViewModel)
        }).disposed(by: disposeBag)
        
        viewModel.output.mapViewModelObservable.subscribe(onNext: { [weak self] mapViewModel in
            guard let self = self else { return }
            self.mapView.setViewModel(to: mapViewModel)
        }).disposed(by: disposeBag)
        
        viewModel.output.technicianDetailViewModelObservable.subscribe(onNext: { [weak self] technicianDetailViewModel in
            guard let self = self else { return }
            self.technicianDetailView.setViewModel(to: technicianDetailViewModel)
        }).disposed(by: disposeBag)
        
    }
}

