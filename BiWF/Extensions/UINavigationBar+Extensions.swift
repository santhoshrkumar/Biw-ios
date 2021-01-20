//
//  UINavigationBar+Extensions.swift
//  BiWF
//
//  Created by pooja.q.gupta on 16/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    /// This would do the default setup of navigation bar
    func defaultSetup() {
        setColor()
        setTitleAttributes()
    }
    
    /// This method would set Background color of Navigation bar
    /// - Parameters:
    ///   - color: Background color(deafult is white)
    private func setColor(_ color: UIColor = UIColor.BiWFColors.white) {
        backgroundColor = color
        barTintColor = color
        tintColor = UIColor.BiWFColors.purple
    }
    
    /// This would set of the naviagation bar title attributes
    /// - Parameters:
    ///   - textColor: Text color (default is dark blue)
    ///   - font: Font (default is bold of size 18)
    private func setTitleAttributes(textColor: UIColor = UIColor.BiWFColors.purple, font: UIFont = .bold(ofSize: 18)) {
        titleTextAttributes = [.foregroundColor: textColor, .font: font]
    }
}
