//
//  UIViewController+Extensions.swift
//  BiWF
//
//  Created by pooja.q.gupta on 24/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit

typealias AlertActionDidTap = (() -> Void)

extension UIViewController {
    func showAlert(with title: String, message: String,
                   leftButtonTitle: String, leftButtonStyle: UIAlertAction.Style = .default,
                   rightButtonTitle: String, rightButtonStyle: UIAlertAction.Style = .default,
                   leftButtonDidTap: AlertActionDidTap? = nil,
                   rightButtonDidTap: AlertActionDidTap? = nil) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: leftButtonTitle,
                                      style: leftButtonStyle,
                                      handler: { action in
                                        if let closure = leftButtonDidTap {
                                            closure()
                                        }
        }))
        alert.addAction(UIAlertAction(title: rightButtonTitle,
                                      style: rightButtonStyle,
                                      handler: { action in
                                        if let closure = rightButtonDidTap {
                                            closure()
                                        }
        }))
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
    
    
    /// This will open the url
    /// - Parameter urlString: urlString to open
    func openUrl(with urlString: String) {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func presentSingleAlert(alert: SingleButtonAlert) {
        let alertController = UIAlertController(title: alert.title,
                                                message: alert.message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: alert.action.buttonTitle,
                                                style: .default,
                                                handler: { _ in alert.action.handler?() }))
        self.present(alertController, animated: true, completion: nil)
    }
}
