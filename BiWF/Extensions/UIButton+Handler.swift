//
//  UIButton+Handler.swift
//  BiWF
//
//  Created by pooja.q.gupta on 09/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit

/// Use this to add a closure on button target
extension UIButton {
    
    private func actionHandler(action:(() -> Void)? = nil) {
        struct __ { static var action :(() -> Void)? }
        if action != nil { __.action = action }
        else { __.action?() }
    }
    
    @objc private func triggerActionHandler() {
        self.actionHandler()
    }

    /// This method will add the closure on button taget
    /// - Parameters:
    ///   - control: button control event
    ///   - action: closure which you want to call
    func actionHandler(controlEvents control :UIControl.Event, forAction action:@escaping () -> Void) {
        self.actionHandler(action: action)
        self.addTarget(self, action: #selector(triggerActionHandler), for: control)
    }
}
