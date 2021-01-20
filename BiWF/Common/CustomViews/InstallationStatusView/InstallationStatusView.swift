//
//  InstallationStatusView.swift
//  BiWF
//
//  Created by pooja.q.gupta on 06/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols
/*
    InstallationStatusView to show installtion progress status
**/
class InstallationStatusView: UIView {
    
    // MARK: Outlet
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .bold(ofSize: UIFont.font16)
            titleLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var statusLabel: UILabel! {
        didSet {
            statusLabel.font = .regular(ofSize: UIFont.font12)
            statusLabel.textColor = UIColor.BiWFColors.dark_grey.withAlphaComponent(0.65)
        }
    }
    @IBOutlet weak var progressStackView: UIStackView!
    
    // MARK: Variables
    private let disposeBag = DisposeBag()
    var viewModel: InstallationStatusViewModel!
   
    ///  Initializes and returns a newly allocated SupportSpeedTestView view object.
    /// - Parameter
    ///     - frame : frame size in CGRect
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        loadFromNib()
        setProgressView()
        self.layoutIfNeeded()
    }
    
    ///setProgressView will set view according to state of installation progress
    private func setProgressView() {
        for tag in 1...4 {
            if let view = self.viewWithTag(tag) {
                view.backgroundColor = UIColor.BiWFColors.light_lavender
                view.cornerRadius = Constants.InstallationStatusView.cornerRadius
            }
        }
    }
    
    func updateState(_ state: InstallationState) {
        setProgressView()
        if state == .cancelled {
            if let view = self.viewWithTag(1) {
                view.backgroundColor = UIColor.BiWFColors.strawberry
                return
            }
        }
        
        let stateIntValue = state.rawValue
        for tag in 1...stateIntValue {
            if let view = self.viewWithTag(tag) {
                view.backgroundColor = UIColor.BiWFColors.purple
            }
        }
    }
}

/// InstallationStatusView Extension confirm Bindable protocol.
/// This is provide a standard interface to all it's internal elements to be bound to a view model
extension InstallationStatusView: Bindable {
    ///Binding view model to SpeedTestView to handle event and UI data
    func bindViewModel() {
        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.status
            .drive(statusLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.state.drive(onNext: { [weak self] state in
            self?.updateState(state)
        })
            .disposed(by: disposeBag)
        
    }
}
