//
//  CALayer+Extensions.swift
//  BiWF
//
//  Created by Amruta Mali on 28/09/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit

extension CALayer {

    func addBorder(edges: [UIRectEdge], color: UIColor, thickness: CGFloat) {
        for edge in edges {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect(x: 0, y: self.frame.height-thickness, width: UIScreen.main.bounds.width-thickness, height: thickness)
                break
            case UIRectEdge.left:
                border.frame = CGRect(x: thickness, y: 0, width: thickness+0.5, height: self.frame.height)
                
                break
            case UIRectEdge.right:
                border.frame = CGRect(x: self.frame.width-thickness-1 , y: 0, width: thickness+0.5, height: self.frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
