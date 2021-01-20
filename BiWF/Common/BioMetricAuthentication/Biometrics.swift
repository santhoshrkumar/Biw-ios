//
//  Biometrics.swift
//

import Foundation
import LocalAuthentication
import UIKit
/*
 Handles biometrics functions
 */
class Biometrics {
    
    static var isPresentedForChangePreferenceAndSettings = false
    
    /// Authentification for the user
    private static func localAuthentication() {
        let laContext = LAContext()
        var error: NSError?
        let biometricsPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        guard let controller = AlertPresenter.topViewController else { return }
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = controller.view.bounds
        controller.view.addSubview(blurVisualEffectView)

        if (laContext.canEvaluatePolicy(biometricsPolicy, error: &error)) {
            if let laError = error {
                let errorMessage = evaluateAuthenticationPolicyMessageForLA(errorCode: laError.code)
                showAlert(forController: controller,
                          withSingleButton: true,
                          errorMessage: errorMessage,
                          toEnable: false,
                          isSuccess: false)
            }
            var localizedReason = Constants.Biometric.faceIdUnlockDevice
            if (laContext.biometryType == LABiometryType.faceID) {
                localizedReason = Constants.Biometric.faceIdUnlocking
            } else if (laContext.biometryType == LABiometryType.touchID) {
                localizedReason = Constants.Biometric.touchIdUnlocking
            } else {
                localizedReason = Constants.Biometric.noBiometricSupport
            }
            laContext.evaluatePolicy(biometricsPolicy, localizedReason: localizedReason, reply: { (isSuccess, error) in
                DispatchQueue.main.async(execute: {
                    blurVisualEffectView.removeFromSuperview()
                    if let laError = error as NSError? {
                        let errorMessage = evaluateAuthenticationPolicyMessageForLA(errorCode: laError.code)
                        showAlert(forController: controller,
                                  withSingleButton: true,
                                  errorMessage: errorMessage,
                                  toEnable: true,
                                  isSuccess: false)
                    } else {
                        if isSuccess {
                            setValueInDefaults(value: isSuccess,
                                               forKey: Constants.Biometric.biometricEnabled)
                            openTabView(forController: controller,
                                        isSuccess: isSuccess,
                                        enabled: true)
                        }
                    }
                })
            })
            
        } else {
            blurVisualEffectView.removeFromSuperview()
            let errorMessage = evaluateAuthenticationPolicyMessageForLA(errorCode: error?.code ?? Int(kLAErrorBiometryNotEnrolled))
            showAlert(forController: controller,
                      withSingleButton: false,
                      errorMessage: errorMessage,
                      toEnable: false,
                      isSuccess: false)
        }
    }
}

extension Biometrics {
    private static func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        var message = ""
        switch errorCode {
        case LAError.authenticationFailed.rawValue:
            message = Constants.Biometric.failedNotValidCredentials
        case LAError.appCancel.rawValue:
            message = Constants.Biometric.authCancelledByApp
        case LAError.invalidContext.rawValue:
            message = Constants.Biometric.invalidContext
        case LAError.notInteractive.rawValue:
            message = Constants.Biometric.notInteractive
        case LAError.passcodeNotSet.rawValue:
            message = Constants.Biometric.passcodeNotSet
        case LAError.systemCancel.rawValue:
            message = Constants.Biometric.authenticationCancelledBySystem
        case LAError.userCancel.rawValue:
            message = Constants.Biometric.userCancelled
        case LAError.userFallback.rawValue:
            message = Constants.Biometric.userChoosedFallback
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        return message
    }
    
    private static func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        switch errorCode {
        case LAError.biometryNotAvailable.rawValue:
            message = Constants.Biometric.deviceNotSupportedBiometric
        case LAError.biometryLockout.rawValue:
            message = Constants.Biometric.userLockedOut
        case LAError.biometryNotEnrolled.rawValue:
            message = Constants.Biometric.notEnrolledBiometric
        default:
            message = Constants.Biometric.unknownError
        }
        return message;
    }
    
    private static func showAlert(forController controller: UIViewController, withSingleButton: Bool, errorMessage: String, toEnable: Bool, isSuccess: Bool) {
        if withSingleButton {
            let okAlert = SingleButtonAlert(
                title: Constants.Biometric.alertTitleError,
                message: errorMessage,
                action: AlertAction(buttonTitle: Constants.PersonalInformation.buttonText,
                                    handler: {
                                        openTabView(forController: controller,
                                                    isSuccess: isSuccess,
                                                    enabled: true)
                                    })
            )
            controller.presentSingleAlert(alert: okAlert)
        } else {
            controller.showAlert(with: Constants.Biometric.alertTitleError,
                                 message: errorMessage,
                                 leftButtonTitle: Constants.Common.cancel.capitalized,
                                 rightButtonTitle: Constants.Biometric.goToSettingsButtonTitle,
                                 rightButtonStyle: .cancel,
                                 leftButtonDidTap: {
                                    setValueInDefaults(value: !toEnable,
                                                       forKey: Constants.Biometric.biometricEnabled)
            }) {
                let url = URL(string: UIApplication.openSettingsURLString)
                if UIApplication.shared.canOpenURL(url!) {
                    openTabView(forController: controller,
                                isSuccess: false,
                                enabled: false)
                    UIApplication.shared.open(url!, options: [:])
                    setValueInDefaults(value: false,
                                       forKey: Constants.Biometric.biometricEnabled)
                }
            }
        }
    }
    
    static func checkBiometricAuthentication() {
        localAuthentication()
    }
    
    static func showWelcomeAlert() -> Bool {
        if !checkIfBiometricEnabledOrSupported() {
            return false
        }
        if (!getValueFromDefaults(forKey: Constants.Biometric.shouldShowWelcomePopup)) && !isBiometricEnabled() {
            setValueInDefaults(value: true,
                               forKey: Constants.Biometric.shouldShowWelcomePopup)
            disableBiometric()
            return true
        }
        return false
    }
    
    private static func openTabView(forController controller: UIViewController, isSuccess: Bool, enabled: Bool) {
        if let navController = controller as? UINavigationController {
            if let tabViewController = navController.children[0] as? TabViewController {
                if let accountViewController = tabViewController.children[0].children[0] as? AccountViewController, isPresentedForChangePreferenceAndSettings {
                    accountViewController.viewModel.changeFaceIDSubject.onNext(isSuccess)
                    accountViewController.viewModel.setSections()
                }
                else {
                    if !isSuccess { tabViewController.viewModel.logoutSubject.onNext(()) }
                }
            }
        }
    }
    
    private static func setValueInDefaults(value: Bool, forKey key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    private static func getValueFromDefaults(forKey key: String) -> Bool {
        let value = UserDefaults.standard.bool(forKey: key)
        return value
    }
    
    static func disableBiometric() {
        setValueInDefaults(value: false,
                           forKey: Constants.Biometric.biometricEnabled)
    }
    
    static func isBiometricEnabled() -> Bool {
        return getValueFromDefaults(forKey: Constants.Biometric.biometricEnabled)
    }
    
    static func enabledBiometricType() -> LABiometryType {
        let laContext = LAContext()
        return laContext.biometryType
    }
    
    static func checkIfBiometricEnabledOrSupported() -> Bool {
        let laContext = LAContext()
        var error: NSError?
        let hasTouchId = laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return hasTouchId
    }
}
