//
//  LoginViewModel.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 3/24/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//
import Foundation
import UIKit
import DPProtocols
import RxSwift
import RxCocoa
import AppAuth
import SwiftKeychainWrapper

class LoginViewModel: NSObject {
    
    /**
     OAuth 2 redirection URI for the client.
     */
    var redirectionUri: String {
        return EnvironmentPath.Login.redirectionUriScheme + EnvironmentPath.Login.redirectionUri
    }
    /**
     Class property to store the authorization state.
     */
    var authState: OIDAuthState?
    
    /// Holds LoginViewController with strong reference
    var controller: LoginViewController?

    /// Input structure
    struct Input {}
    
    /// Output structure
    struct Output {
        let viewComplete: Observable<LoginCoordinator.Event>
        let viewStatusObservable: Observable<ViewStatus>
    }
    
    /// Input&Output structure available
    let input: Input
    let output: Output
    
    /// Subject to handle view status
    let viewStatusSubject = PublishSubject<ViewStatus>()
    
    /// Subject to handle url
    let loginUrl =  PublishSubject<URL>()
    
    /// Subject to handle go to tab view tap
    let goToTabViewSubject = PublishSubject<Void>()
    let logoutSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    /// Initializes a new instance
    override init() {
        input = Input()
        let goToTabViewEventObservable = goToTabViewSubject.asObservable().map { _ in
            return LoginCoordinator.Event.goToTabView
        }
        
        let logOutObservable = logoutSubject.asObservable().map { _ in
            return LoginCoordinator.Event.logout
        }
        
        let viewCompleteObservable = Observable.merge(goToTabViewEventObservable,logOutObservable)
        output = Output(viewComplete: viewCompleteObservable,
                        viewStatusObservable: viewStatusSubject)
    }
}
