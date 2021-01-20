//
//  TechnicianDetailView.swift
//  BiWF
//
//  Created by pooja.q.gupta on 22/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import DPProtocols
/*
TechnicianDetailView to show technician detail information
*/
class TechnicianDetailView: UIView {
    
    /// Outlets
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.font = .bold(ofSize: UIFont.font16)
            nameLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var statusLabel: UILabel! {
        didSet {
            statusLabel.font = .regular(ofSize: UIFont.font12)
            statusLabel.textColor = .black
        }
    }
    
    @IBOutlet weak var arrivalTimeLabel: UILabel! {
        didSet {
            arrivalTimeLabel.font = .bold(ofSize: UIFont.font21)
            arrivalTimeLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var gradientView: UIView!
        
    /// Holds TechnicianDetailViewModel with strong reference
    var viewModel: TechnicianDetailViewModel!
    private let disposeBag = DisposeBag()
    
    //MARK:- init methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    func initialSetup() {
        loadFromNib()
        setGradient()
        self.layoutIfNeeded()
    }
    
    func setGradient() {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            let gradient = CAGradientLayer()
            gradient.frame = self.gradientView.bounds
            gradient.colors = [UIColor.BiWFColors.white.withAlphaComponent(0).cgColor, UIColor.BiWFColors.white.cgColor]
            self.gradientView.layer.addSublayer(gradient)
        }
    }
}
/// TechnicianDetailView extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension TechnicianDetailView: Bindable {
    
    /// Binding all the observers from viewmodel to get the values
    func bindViewModel() {
        viewModel.name
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.status
            .drive(statusLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.estimatedArrivalTime
            .drive(arrivalTimeLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
