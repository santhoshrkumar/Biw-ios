//
//  String+Extensions.swift
//  TemplateApp
//
//  Created by Steve Galbraith on 9/19/19.
//  Copyright © 2019 Digital Products. All rights reserved.
//

import Foundation
import UIKit

internal extension String {

    var firstLowercased: String { return prefix(1).lowercased() + dropFirst() }
    
    var localized: String {
        return Bundle.main.localizedString(forKey: self, value: "Key \(self), not found in bundle", table: nil)
    }

    var attribStringWithUnderline: NSAttributedString {

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.BiWFColors.dark_grey,
            .underlineStyle: NSUnderlineStyle.single.rawValue]

        return NSAttributedString(string: self, attributes: attributes)
    }

    var containsSpecialCharacter: Bool {
       let regex = ".*[^A-Za-z0-9 -].*"
       let testString = NSPredicate(format:"SELF MATCHES %@", regex)
       return testString.evaluate(with: self)
    }

    /// This will convert a string to date
    /// - Parameter format: The date format in which the string is
    func toDate(with format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }

    var attribStringWithNumber: NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self, attributes: [
            .font: UIFont.systemFont(ofSize: 16.0, weight: .regular),
            .foregroundColor: UIColor.BiWFColors.dark_grey
        ])
        return attributedString
    }

    func formattedDateFromString(dateString: String, inFormat inputFormat: String = Constants.DateFormat.YYYYMMddT, withFormat format: String, and timeZone: TimeZone = .current) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            outputFormatter.timeZone = timeZone
            return outputFormatter.string(from: date)
        }
        return nil
    }

    func attributedString(with font: UIFont = .regular(ofSize: UIFont.font16), textColor: UIColor = .black) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self, attributes: [
            .font: font,
            .foregroundColor: textColor
        ])
        return attributedString
    }
    
    func combinedDate(date: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormat.hMMa
        let time = dateFormatter.date(from:String(self))!
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minutes = calendar.component(.minute, from: time)
        let seconds = calendar.component(.second, from: time)
        
        var dateComponent = DateComponents()
        dateComponent.hour = hour
        dateComponent.minute = minutes
        dateComponent.second = seconds
        
        let combinedDate = Calendar.current.date(byAdding: dateComponent, to: date)
        return combinedDate ?? Date()
    }

    func applyPatternOnNumbers(inGeneralFormat: Bool) -> String {
        var pattern = Constants.Common.phonePesonalNumberFormat
        if inGeneralFormat {
            pattern = Constants.Common.phoneNumberFormat
        }
        let replacmentCharacter = Constants.Common.replacmentCharacter
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
    func replace(with text: String, in range: NSRange) -> String? {
        guard range.location + range.length <= self.count else { return nil }
        return (self as NSString).replacingCharacters(in: range, with: text)
    }
    
    /// Method for decoding the HTML/Special characters
   var attributedStringFromHtmlString : NSAttributedString? {
        let htmlDecoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil)
        return htmlDecoded
    }
}
