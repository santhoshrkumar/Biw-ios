//
//  EditPaymentViewController.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 7/20/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import WebKit
import DPProtocols
import RxSwift
import RxCocoa
/*
 EditPaymentViewController to show edited payment
 */
class EditPaymentViewController: UIViewController, Storyboardable {
    
    /// Holds EditPaymentViewModel with strong reference
    var viewModel: EditPaymentViewModel!
    private let disposeBag = DisposeBag()

    /// Bar Buttons
    var doneButton: UIBarButtonItem!
    var backButton: UIBarButtonItem!

    /// Outlets
    @IBOutlet private var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
            webView.scrollView.bounces = false
            webView.scrollView.bouncesZoom = false
            webView.configuration.userContentController.addUserScript(metaTagScript)
        }
    }
    
    @IBOutlet weak var noteLabel: UILabel! {
        didSet {
            noteLabel.text = Constants.EditPayment.userNoteDetail
            noteLabel.font = .regular(ofSize: UIFont.font12)
            noteLabel.textColor = UIColor.BiWFColors.med_grey
            noteLabel.numberOfLines = 2
        }
    }
        
    private var metaTagScript: WKUserScript {
        // This script scales the web view based on the device's size, and
        // prevents the web view from automatically zooming in on text fields
        let source = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"

        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    //MARK: - Navigation bar setup
    private func setNavigationBar() {
        self.title = Constants.Subscription.editBillingInfo
        setDoneButton()
        setBackButton()
    }

    /// Backbutton setup
    private func setBackButton() {
        backButton = UIBarButtonItem(image: UIImage.init(named: "back"), style: .plain, target: nil, action: nil)
        backButton.defaultSetup()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    /// Donebutton setup
    private func setDoneButton() {
        doneButton = UIBarButtonItem.init(title: Constants.Common.done,
                                          style: .plain,
                                          target: nil,
                                          action: nil)
        doneButton.defaultSetup()
        self.navigationItem.rightBarButtonItem = doneButton
    }
}

/// EditPaymentViewController extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension EditPaymentViewController: Bindable {
    
    /// Binding all the input observers from viewmodel to get the events
    func bindViewModel() {
        backButton.rx.tap.bind(onNext: {[weak self] _ in
            AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.editPaymentInformationBack)
            self?.viewModel.input.backTappedObserver.onNext(())
        }).disposed(by: disposeBag)
        
        doneButton.rx.tap.bind(onNext: {[weak self] _ in
            AnalyticsEvents.trackButtonTapEvent(with: AnalyticsConstants.EventButtonTitle.editPaymentInformationDone)
            self?.viewModel.input.doneTappedObserver.onNext(())
        }).disposed(by: disposeBag)

        viewModel.output.urlStringDriver
            .drive(onNext: { [weak self] urlString in
                guard let self = self else { return }
                if let url = URL(string: urlString) {
                    let request = URLRequest(url: url)
                    self.webView.load(request)
                    self.webView.isHidden = true
                    self.view.showLoaderView(with: Constants.Common.loading)
                }
            }).disposed(by: disposeBag)
    }
}

/// EditPaymentDetailsCell extension confirming to WKNavigationDelegate
///Invoked when an error occurs during a committed main frame navigation
extension EditPaymentViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.removeSubView()
        webView.isHidden = false
        AnalyticsEvents.trackScreenVisitEvent(with: AnalyticsConstants.EventScreenName.editPaymentInformation)
    }
}
