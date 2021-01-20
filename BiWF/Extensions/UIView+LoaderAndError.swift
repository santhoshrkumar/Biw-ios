//
//  UIViewController+ViewStatus.swift
//  BiWF
//
//  Created by pooja.q.gupta on 08/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit

extension UIView {
    
    /// This will add a loader view in the current view
    /// - Parameter loadingText: loading Text
    func showLoaderView(with loadingText: String?) {
        removeSubView()
        
        var loadingView = LoaderAndErrorView.init(frame: self.frame)
        let viewmodel = LoaderAndErrorViewModel.init(with: loadingText)
        loadingView.setViewModel(to: viewmodel)
        viewmodel.input.showLoaderObserver.onNext(true)
        self.addSubview(loadingView)
        self.constrainToSelf(with: loadingView)
    }
    
    /// This will add a error view in the current view
    /// - Parameters:
    ///   - errorMsg: error msg you want to show
    ///   - reloadHandler: the closure you want to call on reload click
    func showErrorView(with errorMsg: String?, reloadHandler: (() -> Void)? ) {
        removeSubView()
        
        var errorView = LoaderAndErrorView.init(frame: self.frame)
        let viewmodel = LoaderAndErrorViewModel.init(with: errorMsg, reloadHandler: reloadHandler)
        errorView.setViewModel(to: viewmodel)
        viewmodel.input.showLoaderObserver.onNext(false)
        self.addSubview(errorView)
        self.constrainToSelf(with: errorView)
    }
    
    ///This method will remove the loading & error view(if any) from current view/ Indicator view from current view
    func removeSubView() {
        if let view = self.viewWithTag(Constants.LoaderErrorView.tag) {
            view.removeFromSuperview()
        }
        else if let view = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.viewWithTag(Constants.IndicatorView.viewTag) {
            //remove the view you just created from the window. Use the same tag reference
            view.removeFromSuperview()
        }
    }
    
    ///This will add indicator view on current view
    ///- Parameters:
    ///- titleText: The title of the view
    ///- messageText: The message on the view
    func showIndicatorView(withTitleText titleText: String?, messageText: String?) {
        removeSubView()
        var indicatorView = IndicatorView.init(frame: UIScreen.main.bounds)
        let viewmodel = IndicatorViewModel.init(withMessage: messageText, titleText: titleText)
        
        indicatorView.setViewModel(to: viewmodel)
        // self.addSubview(indicatorView)
        
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(indicatorView)
        self.constrainToWindow(with: indicatorView)
    }
    
     func constrainToWindow(with view: UIView) {
        let windowView = UIApplication.shared.keyWindow ?? self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: windowView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: windowView.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: windowView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: windowView.bottomAnchor).isActive = true
    }
}
