//
//  LoginViewController.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 13/08/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
import AppAuth
/*
 LoginViewController to show login screen
 */
class LoginViewController: UIViewController, Storyboardable {

    /// Holds LoginViewModel with strong reference
    var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.BiWFColors.purple
        viewModel.controller = self
        viewModel.authState = viewModel.loadState()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    /// Initial UI set up
    func initialSetup() {
        if viewModel.authState == nil {
            viewModel.authorizeRp(configuration: viewModel.getOIDCProviderConfiguration())
        }
    }
}

/// LoginViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension LoginViewController: Bindable {
    func bindViewModel() {
    }
}
