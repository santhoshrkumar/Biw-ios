//
//  UIBarButtonItem+Extensions.swift
//  BiWF
//
//  Created by pooja.q.gupta on 17/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// This would do the default setup of Bar button item
    func defaultSetup() {
        setTitleAttributes()
    }
    
    
    /// This would set the title attributes
    /// - Parameter
    ///  - font: UIFont (default is bold of size 14)
    ///  - textColor: Text color (default is blue)
    private func setTitleAttributes(font: UIFont = .bold(ofSize: 14), textColor: UIColor = UIColor.BiWFColors.purple) {
        setTitleTextAttributes([.font : font, .foregroundColor: textColor], for: .normal)
        setTitleTextAttributes([.font : font, .foregroundColor: textColor], for: .highlighted)
        setTitleTextAttributes([.font : font, .foregroundColor: textColor.withAlphaComponent(0.3)], for: .disabled)
    }
}
