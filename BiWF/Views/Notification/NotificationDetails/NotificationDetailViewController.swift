//
//  NotificationDetailViewController.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 03/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import DPProtocols
import RxSwift
import RxCocoa
import WebKit
/*
 NotificationDetailViewController to show details about notifications
 */
class NotificationDetailViewController: UIViewController, Storyboardable {
    
    /// Outlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleText: UILabel!
    
    /// Holds NotificationDetailViewModel with strong reference
    var viewModel: NotificationDetailViewModel!
    let disposeBag = DisposeBag()
    
    /// TODO: Webview url binding required but unable to add, as RxWebViewKit cannot be added with Swift Package Dependencies
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// Load file at path
        guard let url = URL(string: viewModel?.url ?? "") else {
            return
        }
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.absoluteString) {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        } else { /// load web url within the application
            webView.load(url.absoluteString)
        }
    }
}

/// WKWebView extension contains methods related webview
extension WKWebView {
    
    /// Loads the web view
    /// - Parameter urlString : url of the wwb to be loaded
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
//MARK:- Bindable
/// NotificationDetailViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension NotificationDetailViewController: Bindable {
    
    func bindViewModel() {
        bindActions()
    }
    
    /// Binding all the input observers from viewmodel to get the events
    private func bindActions() {
        
        guard let backObserver = self.viewModel?.input.backObserver,
            let closeObserver = self.viewModel?.input.closeObserver else {
                return
        }
        
        /// Binding all the output observers from viewmodel to get the values
        viewModel.output.titleTextDriver
            .drive(titleText.rx.text)
            .disposed(by: disposeBag)
        
        /// Close button binding with closeObserver
        closeButton.rx.tap
            .bind(to: (closeObserver))
            .disposed(by: disposeBag)
        
        /// Back button binding with closeObserver
        backButton.rx.tap
            .bind(to: (backObserver))
            .disposed(by: disposeBag)
    }
}

