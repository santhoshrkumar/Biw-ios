//
//  QRCodeUtility.swift
//  BiWF
//
//  Created by pooja.q.gupta on 29/07/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit

class QRCodeUtility {
    
    /// Static constants used in generating QR code
    enum Constants {
        static let qrCodeGenerator = "CIQRCodeGenerator"
        static let flashColor = "CIFalseColor"
        static let inputMessage = "inputMessage"
        static let inputCorrectionLevel = "inputCorrectionLevel"
        static let inputCorrectionValue = "H"
        static let inputImage = "inputImage"
        static let inputColor1 = "inputColor1"
        static let inputColor0 = "inputColor0"
        static let transform =  CGAffineTransform(scaleX: 3, y: 3)
        static let defaultBrightness = 0.5
        static let increasedBrightness = 1.0
    }
    
    static let shared: QRCodeUtility = {
        let instance = QRCodeUtility()
        return instance
    }()

    var defaultBrightness: CGFloat?

    /// Increasing the brightness
    func increaseBrightness() {
        self.defaultBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = CGFloat(Constants.increasedBrightness)
    }

    /// Setting the brightness
    func setBrightnessToDefault(){
        UIScreen.main.brightness = self.defaultBrightness ?? CGFloat(Constants.defaultBrightness)
    }

    /// QR code generation
    static func generateQRCodeWithColor(from string: String, with backgroundColor: UIColor = UIColor.BiWFColors.white, and foregroundColor: UIColor = UIColor.BiWFColors.lavender) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: Constants.qrCodeGenerator) {
            guard let colorFilter = CIFilter(name: Constants.flashColor) else { return nil }
            
            filter.setValue(data, forKey: Constants.inputMessage)
            
            filter.setValue(Constants.inputCorrectionValue, forKey: Constants.inputCorrectionLevel)
            colorFilter.setValue(filter.outputImage, forKey: Constants.inputImage)
            colorFilter.setValue(CIColor(color: backgroundColor), forKey: Constants.inputColor1) // set Background white
            colorFilter.setValue(CIColor(color: foregroundColor), forKey: Constants.inputColor0) // set foreground color
            if let _ = colorFilter.outputImage, let output = colorFilter.outputImage?.transformed(by: Constants.transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}
