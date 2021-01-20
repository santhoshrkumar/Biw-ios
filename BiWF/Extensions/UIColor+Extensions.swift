//
//  UIColor+Extensions.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 01/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit

extension UIColor {
    /**
     Static custom colors.
     - Note:
     We use color literals so that is is easier for developers to infer what the color is based on design.
     A hex string or rgb value is hard to immediately tell what color the constant is refering to.
     - Remark: As per zeplin
     */
    enum BiWFColors {
        static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        static let purple = #colorLiteral(red: 0.3137254902, green: 0.1960784314, blue: 0.5882352941, alpha: 1)
        static let lavender = #colorLiteral(red: 0.4823529412, green: 0.5568627451, blue: 0.8823529412, alpha: 1)
        static let light_blue = #colorLiteral(red: 0.2196078431, green: 0.7764705882, blue: 0.9568627451, alpha: 1)
        static let eggplant = #colorLiteral(red: 0.1764705882, green: 0, blue: 0.3529411765, alpha: 1)
        static let mango = #colorLiteral(red: 1, green: 0.7058823529, blue: 0.3921568627, alpha: 1)
        static let kale = #colorLiteral(red: 0.1176470588, green: 0.6274509804, blue: 0.5882352941, alpha: 1)
        static let strawberry = #colorLiteral(red: 0.8549019608, green: 0.1921568627, blue: 0.3333333333, alpha: 1)
        static let light_grey = #colorLiteral(red: 0.8431372549, green: 0.8823529412, blue: 0.9019607843, alpha: 1)
        static let med_grey = #colorLiteral(red: 0.4705882353, green: 0.5294117647, blue: 0.568627451, alpha: 1)
        static let dark_grey = #colorLiteral(red: 0.2352941176, green: 0.2549019608, blue: 0.2941176471, alpha: 1)
        static let orange = #colorLiteral(red: 1, green: 0.4509803922, blue: 0.3333333333, alpha: 1)
        static let med_blue = #colorLiteral(red: 0.04705882353, green: 0.6196078431, blue: 0.8509803922, alpha: 1)
        static let white_grey = #colorLiteral(red: 0.937254902, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
        static let blue = #colorLiteral(red: 0, green: 0.2784313725, blue: 0.7333333333, alpha: 1)
        static let light_lavender = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        static let sub_grey = #colorLiteral(red: 0.3254901961, green: 0.337254902, blue: 0.3529411765, alpha: 1)
        static let translucentBlack = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4042629076)
    }
}
