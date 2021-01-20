//
//  Alert.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 05/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit

struct AlertAction {
    let buttonTitle: String
    let handler: (() -> Void)?
}

struct SingleButtonAlert {
    let title: String
    let message: String?
    let action: AlertAction
}

protocol SingleButtonAlertPresenter {
    func presentSingleButtonAlert(alert: SingleButtonAlert)
}

extension SingleButtonAlertPresenter where Self: UIViewController {
    func presentSingleButtonAlert(alert: SingleButtonAlert) {
        let alertController = UIAlertController(title: alert.title,
                                                message: alert.message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: alert.action.buttonTitle,
                                                style: .default,
                                                handler: { _ in alert.action.handler?() }))
        self.present(alertController, animated: true, completion: nil)
    }
}
