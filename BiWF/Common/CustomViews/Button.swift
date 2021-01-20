//
//  FilledBackgroundButton.swift
//  BiWF
//
//  Created by pooja.q.gupta on 13/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit

enum ButtonStyle {
    case clearBackground
    case filledBackground
    case bordered
    case rowType
    case withIndicator
    case disabledBordered
    case enabledWithLightPurpleBackground
    case enabledWithGrayBackground
    case withoutBorder
    case offline
}

class Button: UIButton {
    
    let indicator = UIActivityIndicatorView()
    
    private enum Constants: CGFloat {
        case cornerRadius = 22
        case borderWidth = 2
    }
    
    var style: ButtonStyle = .filledBackground {
        didSet {
            initialSetup()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    private func initialSetup() {
        clipsToBounds = true
        layer.masksToBounds = true
        indicator.isHidden = true
        self.isEnabled = true
        switch style {
            
        case .clearBackground:
            setTitleColor(UIColor.BiWFColors.purple, for: .normal)
            backgroundColor = UIColor.BiWFColors.white
            titleLabel?.font = UIFont.bold(ofSize: UIFont.font14)
            cornerRadius = (self.frame.size.height / 2)
            
        case .filledBackground:
            setTitleColor(UIColor.BiWFColors.white, for: .normal)
            backgroundColor = UIColor.BiWFColors.purple
            titleLabel?.font = UIFont.bold(ofSize: UIFont.font14)
            cornerRadius = (self.frame.size.height / 2)
            
        case .bordered:
            setTitleColor(UIColor.BiWFColors.purple, for: .normal)
            backgroundColor = UIColor.BiWFColors.white
            titleLabel?.font = UIFont.bold(ofSize: UIFont.font14)
            cornerRadius = (self.frame.size.height / 2)
            borderColor = UIColor.BiWFColors.purple
            borderWidth = Constants.borderWidth.rawValue
            
        case .rowType:
            setTitleColor(UIColor.BiWFColors.dark_grey, for: .normal)
            backgroundColor = UIColor.clear
            titleLabel?.font = UIFont.regular(ofSize: UIFont.font16)
            contentHorizontalAlignment = .left
            contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 24, bottom: 0, right: 15)
            borderColor = UIColor.BiWFColors.light_grey
            borderWidth = 1
            
        case .withIndicator:
            indicator.isHidden = false
            isEnabled = false
            indicator.color = UIColor.BiWFColors.purple
            indicator.shadowColor = UIColor.BiWFColors.purple
            let buttonHeight = self.bounds.size.height
            if let buttonTitleX = self.titleLabel?.frame.minX {
                indicator.frame.origin = CGPoint(x: (buttonTitleX - 5), y: buttonHeight/2)
            }
            indicator.tag = tag
            addSubview(indicator)
            indicator.startAnimating()
            
        case .disabledBordered:
            isEnabled = false
            setTitleColor(UIColor.BiWFColors.purple.withAlphaComponent(0.25), for: .normal)
            backgroundColor = UIColor.BiWFColors.white
            titleLabel?.font = UIFont.bold(ofSize: UIFont.font14)
            cornerRadius = (self.frame.size.height / 2)
            borderColor = UIColor.BiWFColors.purple.withAlphaComponent(0.25)
            borderWidth = Constants.borderWidth.rawValue
            
        case .enabledWithLightPurpleBackground:
            setTitleColor(UIColor.BiWFColors.purple, for: .normal)
            backgroundColor = UIColor.BiWFColors.light_lavender
            titleLabel?.font = UIFont.bold(ofSize: UIFont.font16)
            cornerRadius = (self.frame.size.height / 2)
            borderColor = UIColor.BiWFColors.purple
            borderWidth = Constants.borderWidth.rawValue
            
            
        case .enabledWithGrayBackground:
            setTitleColor(UIColor.BiWFColors.dark_grey, for: .normal)
            backgroundColor = UIColor.BiWFColors.white_grey
            titleLabel?.font = UIFont.bold(ofSize: UIFont.font16)
            cornerRadius = (self.frame.size.height / 2)
            borderColor = UIColor.BiWFColors.med_grey
            borderWidth = Constants.borderWidth.rawValue
            
        case .withoutBorder:
            setTitleColor(UIColor.BiWFColors.purple, for: .normal)
            backgroundColor = UIColor.clear
            titleLabel?.font = UIFont.bold(ofSize: UIFont.font14)
            borderWidth = 0
            
        case .offline:
            setTitleColor(UIColor.BiWFColors.med_grey, for: .normal)
            backgroundColor = UIColor.BiWFColors.white_grey
            titleLabel?.font = UIFont.bold(ofSize: UIFont.font16)
            borderWidth = 0
        }
    }
}
