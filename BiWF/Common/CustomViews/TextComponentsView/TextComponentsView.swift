//
//  TextComponentsView.swift
//  BiWF
//
//  Created by pooja.q.gupta on 27/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit

enum ViewState {
    case normal
    case error(String)
}

class TextComponentsView: UIStackView {
    
    /// Outlest
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    /// Variables/Constants
    var textFieldName: String = "" {
        didSet {
            nameLabel.text = textFieldName
        }
    }
    var state: ViewState = .normal {
        didSet {
            updateUI()
        }
    }
    
    var leftImageView: UIImage? {
        didSet {
            setLeftView()
        }
    }
    
    var rightImageView: UIImage? {
        didSet {
            setRightView()
        }
    }
    
    var leftButton: UIButton?
    var rightButton: UIButton?
    var isOptional: Bool = false {
        didSet {
            setNameLabelText()
        }
    }
    
    //MARK:- init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    //MARK- UI Setup
    private func initialSetup() {
        loadFromNib()
        updateUI()
        //errorlabel
        errorLabel.font = .regular(ofSize: UIFont.font12)
        errorLabel.textColor = UIColor.BiWFColors.red
        
        //textField
        textField.textColor = UIColor.BiWFColors.blue
        textField.font = .regular(ofSize: UIFont.font16)
        textField.minimumFontSize = UIFont.font14;
        textField.adjustsFontSizeToFitWidth = true
        let paddingView = UIView.init(frame: CGRect.init(x: 0,
                                                         y: 0,
                                                         width: (Constants.TextField.leftViewLeftInset - 6),
                                                         height: self.textField.frame.size.height))
        textField.leftView = paddingView
        textField.leftViewMode = UITextField.ViewMode.always
    }
    
    private func updateUI() {
        switch state {
        case .normal:
            //NameLabel
            nameLabel.font = .regular(ofSize: UIFont.font12)
            nameLabel.textColor = UIColor.BiWFColors.mediumGray
            setNameLabelText()
            
            //errorLabel
            errorLabel.text = ""
            errorLabel.isHidden = true
            
            //textfield
            textField.layer.borderColor = UIColor.BiWFColors.gray.cgColor
            
        case .error(let errorMsg):
            //NameLabel
            nameLabel.font = .bold(ofSize: UIFont.font12)
            nameLabel.textColor = UIColor.BiWFColors.red
            nameLabel.text = "\(textFieldName)*"
            
            //errorLabel
            errorLabel.text = errorMsg
            errorLabel.isHidden = false
            
            //textfield
            textField.layer.borderColor = UIColor.BiWFColors.red.cgColor
        }
    }
    
    private func setNameLabelText() {
        let text = NSMutableAttributedString.init(string: textFieldName, attributes: [.foregroundColor: UIColor.BiWFColors.mediumGray])
        
        if isOptional {
            let optionalText = NSMutableAttributedString.init(string: " (\(Constants.TextField.optional))",
                attributes: [.foregroundColor: UIColor.BiWFColors.gray])
            text.append(optionalText)
        }
        nameLabel.attributedText = text
        
    }
    
    private func setLeftView() {
        if (leftImageView != nil) {
            let paddingView = UIView.init(frame: CGRect.init(x: 0,
                                                             y: 0,
                                                             width: Constants.TextField.leftViewWidth,
                                                             height: self.textField.frame.size.height))
            leftButton = UIButton.init(frame: CGRect.init(x: Constants.TextField.leftViewLeftInset,
                                                          y: Constants.TextField.topInset,
                                                          width: Constants.TextField.buttonWidth,
                                                          height: Constants.TextField.buttonHeight))
            leftButton?.setImage(leftImageView, for: .normal)
            paddingView.addSubview(leftButton!)
            textField.leftView = paddingView
            textField.leftViewMode = UITextField.ViewMode.always
        }
    }
    
    private func setRightView() {
        if (rightImageView != nil) {
            let paddingView = UIView.init(frame: CGRect.init(x: 0,
                                                             y: 0,
                                                             width: Constants.TextField.rightViewWidth,
                                                             height: self.textField.frame.size.height))
            rightButton = UIButton.init(frame: CGRect.init(x: 0,
                                                           y: Constants.TextField.topInset,
                                                           width: Constants.TextField.buttonWidth,
                                                           height: Constants.TextField.buttonHeight))
            rightButton?.setImage(rightImageView, for: .normal)
            paddingView.addSubview(rightButton!)
            textField.rightView = paddingView
            textField.rightViewMode = UITextField.ViewMode.always
        }
    }
}
