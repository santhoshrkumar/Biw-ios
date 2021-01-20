//
//  PaymentDetailsCell.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 6/8/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import WebKit
import DPProtocols
import RxSwift
import RxCocoa
/*
 EditPaymentDetailsCell shows edited payment details
 */
class EditPaymentDetailsCell: UITableViewCell {
    /// reuse identifier
    static let identifier = "EditPaymentDetailsCell"
    
    /// Holds EditPaymentDetailsCellViewModel with strong reference
    var viewModel: EditPaymentDetailsCellViewModel!
    private let disposeBag = DisposeBag()

    /// Outlets
    @IBOutlet private var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
            webView.scrollView.bounces = false
            webView.scrollView.bouncesZoom = false
            webView.configuration.userContentController.addUserScript(metaTagScript)
        }
    }

    private var metaTagScript: WKUserScript {
        let source = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"

        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
}

/// EditPaymentDetailsCell extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension EditPaymentDetailsCell: Bindable {
    
    /// Binding the webview with url from viewModel
    func bindViewModel() {
        viewModel.output.urlStringDriver
            .drive(onNext: { [weak self] urlString in
                guard let self = self else { return }
                if let url = URL(string: urlString) {
                    let request = URLRequest(url: url)
                    self.webView.load(request)
                    self.webView.isHidden = true
                    self.showLoaderView(with: Constants.Common.loading)
                }
            }).disposed(by: disposeBag)
    }
}

/// EditPaymentDetailsCell extension confirming to WKNavigationDelegate
///Invoked when an error occurs during a committed main frame navigation
extension EditPaymentDetailsCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        removeSubView()
        webView.isHidden = false
    }
}
