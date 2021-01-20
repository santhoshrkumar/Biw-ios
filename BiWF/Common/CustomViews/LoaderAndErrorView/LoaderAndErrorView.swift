//
//  ErrorView.swift
//  BiWF
//
//  Created by pooja.q.gupta on 08/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
/*
 Status of the loader
 */
enum ViewStatus {
    case loading(loadingText:String?)
    case loaded
    case error(errorMsg: String?, retryButtonHandler: (() -> Void)?)
}
/*
 LoaderAndErrorView to show status loader view
 */
class LoaderAndErrorView: UIView {
    
    /// Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
            activityIndicator.color = UIColor.BiWFColors.purple
        }
    }
    
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            messageLabel.font = .regular(ofSize: UIFont.font16)
            messageLabel.textColor = UIColor.BiWFColors.purple
        }
    }
    @IBOutlet weak var refreshButton: UIButton! {
        didSet {
            refreshButton.setImage(UIImage.init(named: Constants.LoaderErrorView.reloadImageName), for: .normal)
        }
    }
    
    /// Holds LoaderAndErrorViewModel eth strong reference
    var viewModel: LoaderAndErrorViewModel!
    let disposeBag = DisposeBag()
    
    // MARK: - Intializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
        initialSetup()
    }
    
    private func initialSetup() {
        self.tag = Constants.LoaderErrorView.tag
        self.backgroundColor = .clear
    }
    
    // MARK: - Configures views
    func showLoaderView() {
        refreshButton.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func showErrorView( ) {
        refreshButton.isHidden = false
        activityIndicator.stopAnimating()
    }
}

/// LoaderAndErrorView extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension LoaderAndErrorView: Bindable {
    
    /// Binding all the output observers from viewmodel to get the values
    func bindViewModel() {
        
        viewModel.output.messageTextDriver
            .drive(messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.reloadHandlerDriver
            .drive(onNext: { [weak self] reloadHandler in
                if let handler = reloadHandler {
                    self?.refreshButton.actionHandler(controlEvents: .touchUpInside, forAction: handler)
                }
            }).disposed(by: disposeBag)
        
        viewModel.output.showLoaderObservable
            .subscribe(onNext: {[weak self] showLoaderView in
                showLoaderView ? self?.showLoaderView() : self?.showErrorView()
            }).disposed(by: disposeBag)
    }
}

