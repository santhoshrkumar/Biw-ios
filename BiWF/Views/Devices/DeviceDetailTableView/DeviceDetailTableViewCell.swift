//
//  DeviceDetailTableViewCell.swift
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
 A TableView cell representing the Device Detail Table View Cell
 */
class DeviceDetailTableViewCell: UITableViewCell {
    
    /// reuse identifier
    static let identifier = "DeviceDetailTableViewCell"
    
    /// Outlets
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var strengthButton: UIButton!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView! {
        didSet {
            loadingIndicator.startAnimating()
        }
    }
    private var disposeBag = DisposeBag()
    var viewModel: DeviceDetailTableCellViewModel!
}

/// DeviceDetailTableViewCell Extension confirm Bindable protocol.
/// This is provide a standard interface to all it's internal elements to be bound to a view model
extension DeviceDetailTableViewCell: Bindable {
    func bindViewModel() {
        bindOutputs()
        bindInputs()
        initialSetup()
    }
    
    /// Binding all the output from viewmodel to get the events to subscribe
    private func bindOutputs() {
        viewModel.output.connectedDevices
            .drive(deviceNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.showLoading.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(onNext: { [weak self] (shouldShowIndicator) in
                shouldShowIndicator ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
                self?.loadingIndicator.isHidden = !shouldShowIndicator
                self?.strengthButton.isHidden = shouldShowIndicator
            })
            .disposed(by: disposeBag)
    }
    
    /// Binding all the input observers from viewmodel to get the events
    private func bindInputs() {
        strengthButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                guard let self = self else {return}
                (!self.loadingIndicator.isAnimating && self.viewModel.deviceInfo.networStatus == .error) ? self.viewModel.retryNetworkInfoTapSubject.onNext(self.viewModel.deviceInfo) :
                    self.viewModel.pauseResumeSubject.onNext(self.viewModel.deviceInfo)
            })
            .disposed(by: disposeBag)
    }
    
    /// Initial setup 
    private func initialSetup() {
        if self.viewModel.isBlockedDevice {
            deviceNameLabel.font = .regular(ofSize: UIFont.font16)
            deviceNameLabel.textColor = UIColor.BiWFColors.med_grey
            //border
            cellBackgroundView.borderColor = UIColor.BiWFColors.light_grey
            cellBackgroundView.borderWidth = Constants.Device.viewBorderWidth
            //remove shadow
            cellBackgroundView.shadowOffset = CGSize.init(width: 0, height: 0)
            //set button image
            strengthButton.setImage(viewModel.networkStregthImage, for: .normal)
            loadingIndicator.isHidden = true
        } else {
            //Label color
            deviceNameLabel.font = .regular(ofSize: UIFont.font16)
            deviceNameLabel.textColor = UIColor.BiWFColors.dark_grey
            //border
            cellBackgroundView.borderColor = UIColor.BiWFColors.light_grey
            cellBackgroundView.borderWidth = Constants.Device.viewBorderWidth
            //Add shadow
            cellBackgroundView.shadowColor = UIColor.BiWFColors.dark_grey.withAlphaComponent(0.08)
            
            cellBackgroundView.shadowBlur = Constants.Device.shadowBlur
            cellBackgroundView.shadowAplha = Constants.Device.shadowAplha
            cellBackgroundView.shadowOffset = CGSize.init(width: 0, height: 3)
            //set button images
            strengthButton.setImage(viewModel.networkStregthImage, for: .normal)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

