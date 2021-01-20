//
//  RootNavigationController.swift
//  BiWF
//
//  Created by shriram.narayan.bhat on 24/11/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {
    override open var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
