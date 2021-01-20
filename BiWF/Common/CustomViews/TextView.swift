//
//  TextView.swift
//  BiWF
//
//  Created by pooja.q.gupta on 24/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit

enum TextViewStyle {
    case normal
}

class TextView: UITextView {
    let padding: CGFloat = 12
    var maxLength: Int?
    
    var style: TextViewStyle = .normal {
        didSet {
            initialSetup()
        }
    }
    
    var placholder: String? {
        didSet {
            setPlacholder()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    func initialSetup() {
        switch style {
        case .normal:
            textColor = (placholder == nil) ? UIColor.BiWFColors.purple : UIColor.BiWFColors.light_grey
            layer.borderColor = UIColor.BiWFColors.light_grey.cgColor
            layer.borderWidth = 1
            cornerRadius = 8
            textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            font = .regular(ofSize: UIFont.font16)
        }
    }
    
    func setPlacholder() {
        if placholder != nil {
            text = placholder
            textColor = UIColor.BiWFColors.light_grey
            selectedTextRange = textRange(from: beginningOfDocument, to: beginningOfDocument)
            delegate = self
        }
    }
}

extension TextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = placholder
            textView.textColor = UIColor.BiWFColors.light_grey
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
        else if textView.textColor == UIColor.BiWFColors.light_grey && !text.isEmpty {
            textView.textColor = UIColor.BiWFColors.dark_grey
            textView.text = text
        }
            
            // Else if the placeholder is showing and user press back then don't edit it.
            // And move the cursor to the beginning of the document
        else  if textView.textColor == UIColor.BiWFColors.light_grey, let char = text.cString(using: String.Encoding.utf8),
            (strcmp(char, "\\b") == -92) {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            return false
        }
            
        else if let counter = maxLength,updatedText.count > counter {
            return false
        }
           
            // For every other case, the text should change with the usual
            // behavior...
        else {
            return true
        }
        
        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textColor == UIColor.BiWFColors.light_grey {
            //Move the cursor to the beginning of the document
            self.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.textColor == UIColor.BiWFColors.light_grey {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
}
