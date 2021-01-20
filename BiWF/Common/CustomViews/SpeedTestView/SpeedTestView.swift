//
//  SpeedTestView.swift
//  BiWF
//
//  Created by pooja.q.gupta on 09/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa

/*
    SpeedTestView to show speed test details
**/
class SpeedTestView: UIView {
    // MARK: Outlet
    @IBOutlet weak var lastRunLabel: UILabel!
    @IBOutlet weak var uploadSpeedLabel: UILabel! {
        didSet {
            uploadSpeedLabel.font = .bold(ofSize: 48)
            uploadSpeedLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var uploadFrequencyLabel: UILabel! {
        didSet {
            uploadFrequencyLabel.font = .regular(ofSize: 12)
            uploadFrequencyLabel.textColor = UIColor.BiWFColors.lavender
        }
    }
    @IBOutlet weak var downloadSpeedLabel: UILabel! {
        didSet {
            downloadSpeedLabel.font = .bold(ofSize: 48)
            downloadSpeedLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var downloadFrequencyLabel: UILabel! {
        didSet {
            downloadFrequencyLabel.font = .regular(ofSize: 12)
            downloadFrequencyLabel.textColor = UIColor.BiWFColors.lavender
        }
    }
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var downloadImageView: UIImageView!
    @IBOutlet weak var runSpeedTestButton: Button!
    @IBOutlet private var upActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var downActivityIndicator: UIActivityIndicatorView!
    
    // MARK: Variable
    var viewModel: SpeedTestViewModel!
    private let disposeBag = DisposeBag()
    
    ///  Initializes and returns a newly allocated SpeedTestView view object.
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
        self.layoutIfNeeded()
    }
}

/// SpeedTestView Extension confirm Bindable protocol.
/// This is provide a standard interface to all it's internal elements to be bound to a view model
extension SpeedTestView: Bindable {
    ///Binding view model to SpeedTestView to handle event and UI data
    func bindViewModel() {
        
        viewModel.output.lastTestTextDriver
            .drive(lastRunLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.output.runNewTestTextDriver
            .drive(runSpeedTestButton.rx.title())
            .disposed(by: disposeBag)
        
        viewModel.output.uploadSpeedTextDriver
            .drive(uploadSpeedLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.uploadMbpsTextDriver
            .drive(uploadFrequencyLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.downloadSpeedTextDriver
            .drive(downloadSpeedLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.downloadMbpsTextDriver
            .drive(downloadFrequencyLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output.isSpeedTestRunningDriver
            .drive(upActivityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.output.isSpeedTestRunningDriver
            .drive(downActivityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.output.isSpeedTestRunningDriver
            .drive(uploadSpeedLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.output.isSpeedTestRunningDriver
            .drive(downloadSpeedLabel.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.output.enableSpeedTestDriver
            .drive(runSpeedTestButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.output.enableSpeedTestDriver
            .map { shouldEnable -> UIColor in
                return shouldEnable ? UIColor.BiWFColors.purple : UIColor.BiWFColors.purple.withAlphaComponent(0.25)
            }.drive(runSpeedTestButton.rx.backgroundColor)
            .disposed(by: disposeBag)

        runSpeedTestButton.rx.tap
            .bind(to: viewModel.input.runSpeedTestObserver)
            .disposed(by: disposeBag)
    }
}
