//
//  PasscodeViewController+PasscodeSetup.swift
//  BiWF
//
//  Created by Aditi.A.Gandhi on 22/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import AudioToolbox
import UIKit

extension PasscodeViewController {
    
    func updatePasscodeView(forNumber number: Int) {
        if number == Constants.Passcode.totalNumberCount {
            viewModel.input.cancelButtonObserver.onNext(())
        } else if number == Constants.Passcode.clearCellIndex {
            clearPointViews()
        } else {
            addEntry(ofNumber: String(number))
            fillPoints()
            validatePasscode()
        }
    }
    
    func fillPoints() {
       let pointImageView = pointsView.viewWithTag(input.count) as? UIImageView
       pointImageView?.image = UIImage(named: Constants.Passcode.ovalFilledImage)
    }
    
    func validatePasscode() {
        if input.count == Constants.Passcode.maximumPasscodeValue {
            if input == PasscodeViewController.passCode {
                Biometrics.checkBiometricAuthentication(forController: self)
            } else if PasscodeViewController.passCode.isEmpty {
                PasscodeViewController.setPasscode(passcode: input)
                Biometrics.checkBiometricAuthentication(forController: self)
            } else {
                animatePointsView()
                clearPointViews()
            }
        }
    }

    func animatePointsView() {
        let animation = CABasicAnimation(keyPath: Constants.Passcode.keyPathPosition)
        animation.duration = Constants.Passcode.animationDuration
        animation.repeatCount = Float(Constants.Passcode.maximumPasscodeValue)
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: pointsView!.center.x - CGFloat(Constants.Passcode.animationOffset), y: pointsView!.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: pointsView!.center.x + CGFloat(Constants.Passcode.animationOffset), y: pointsView!.center.y))
        animation.delegate = self
        pointsView?.layer.add(animation, forKey: Constants.Passcode.keyPathPosition)
    }
    
    func clearPointViews() {
        let imageViews = pointsView.flatMap {$0.subviews} as? [UIImageView] ?? [UIImageView]()
        imageViews.forEach { $0.image = UIImage(named: Constants.Passcode.ovalEmptyImage) }
        input = ""
    }
    
    func addEntry(ofNumber number: String) {
        let tappedNumber = ((Int(number) ?? 0) > Constants.Passcode.totalNumberCount) ? "0" : number
        guard input.count <= Constants.Passcode.maximumPasscodeValue else {
            return
        }
        input += tappedNumber
    }
    
    static func setPasscode(passcode: String) {
        KeychainAccess.setValue(forIdentifier: Constants.Passcode.passcodeIdentifier,
                                value: passcode)
    }
    
    static func getPasscode() -> String {
        guard let savedPasscode = (KeychainAccess.getValue(forIdentifier: Constants.Passcode.passcodeIdentifier)) else { return "" }
        return savedPasscode
    }
    
    static func deletePasscode() {
        KeychainAccess.setValue(forIdentifier: Constants.Passcode.passcodeIdentifier,
                                value: "");
    }
}
