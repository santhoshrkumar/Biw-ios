//
//  ErrorAlertPresenter.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 7/15/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
/*
 Custom alertPresenter to show the alerts
 */
struct AlertPresenter {

    static var topViewController: UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController  {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }

    /// Retry alert
    static func showRetryErrorAlert(title: String, message: String, retryAction: AlertActionDidTap?, cancelAction: AlertActionDidTap?, leftButtonTitle: String?, rightButtonTitle: String?) {
        DispatchQueue.main.async {
            topViewController?.showAlert(with: title,
                                    message: message,
                                    leftButtonTitle: leftButtonTitle ?? "",
                                    rightButtonTitle: rightButtonTitle ?? "",
                                    leftButtonDidTap: cancelAction,
                                    rightButtonDidTap: retryAction)
        }
    }

    /// Custom alert all over the application
    static func showCustomAlertViewController(title: String, message: NSAttributedString, buttonText: String) {
        DispatchQueue.main.async {
            var viewController = CustomAlertViewController.instantiate(fromStoryboardNamed: String(describing: AccountViewController.self))
            viewController.setViewModel(to: CustomAlertViewModel(withTitle: title,
                                                                 message: message,
                                                                 buttonTitleText: buttonText,
                                                                 isPresentedFromWindow: true))
            viewController.modalPresentationStyle = .overCurrentContext
            topViewController?.present(viewController,
                                   animated: true,
                                   completion: nil)
        }
    }
}
