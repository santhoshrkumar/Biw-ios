//
//  Support.swift
//  BiWF
//
//  Created by pooja.q.gupta on 26/03/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DPProtocols

/**
 Use this to add the floating support button. Add these two lines to the view where you want to add the floating button
 var supportBtn = SupportButton()
 supportBtn.addTo(self)
 */

class SupportButton: UIButton {
    var viewModel: SupportButtonViewModel!
    private let disposeBag = DisposeBag()
    
    // constants
    let bottomSpace: CGFloat = 24
    let trailingSpace: CGFloat = 24
    let height: CGFloat = 56
    let width: CGFloat = 129
    
    //MARK:- init methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    //MARK:- Setup methods
    
    /// This will do the initial set up for the UI
    private func initialSetup() {
        self.setBackgroundImage(UIImage(named: Constants.Support.supportButton),
                                for: .normal)
        self.backgroundColor = .clear
        addShadowToButton()
    }
    
    /// This will set the corner radius and shadow of the button
    private func addShadowToButton() {
        cornerRadius = height/2
        shadowAplha = 0.25
        shadowOffset = CGSize.init(width: 0, height: 5)
        shadowBlur = 15
    }
    
    /// This will add the button constants
    /// - Parameter superView: The superview of the button in which it is added
    private func addSelfConstraints(with superView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -trailingSpace).isActive = true
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -bottomSpace).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    /// This methods will be called from the viewController in which it is to be added
    /// - Parameter viewController: The viewController in which button is to be added
    internal func addTo(_ viewController: UIViewController) {
        viewController.view.addSubview(self)
        addSelfConstraints(with: viewController.view)
    }
}

extension SupportButton: Bindable {
    func bindViewModel() {
        
        rx.tap
            .bind(onNext: {[weak self] _ in
            AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.supportButton)
            self?.viewModel.input.tapObserver.onNext(())
        }).disposed(by: disposeBag)
    }
}
