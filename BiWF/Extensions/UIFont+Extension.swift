//
//  UIFont+Extensions.swift
//  BiWF
//
//  Created by nicholas.a.klacik on 4/10/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit

extension UIFont {
    static func regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Arial", size: size)!
    }

    static func bold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Arial-BoldMT", size: size)!
    }
    
    // Different font sizes
    static let font48: CGFloat = 48.0
    static let font36: CGFloat = 36.0
    static let font32: CGFloat = 32.0
    static let font24: CGFloat = 24.0
    static let font22: CGFloat = 22.0
    static let font21: CGFloat = 21.0
    static let font20: CGFloat = 20.0
    static let font18: CGFloat = 18.0
    static let font16: CGFloat = 16.0
    static let font14: CGFloat = 14.0
    static let font12: CGFloat = 12.0
}
