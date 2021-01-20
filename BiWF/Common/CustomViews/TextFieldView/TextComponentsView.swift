//
//  TextFieldView.swift
//  BiWF
//
//  Created by pooja.q.gupta on 27/04/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit

enum ViewState {
    case normal(String)
    case error(String)
    case errorWithOutMessage
    case disable
}

class TextComponentsView: UIStackView {
    
    /// Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    /// Variables/Constants
    var textFieldName: String = "" {
        didSet {
            nameLabel.text = textFieldName
        }
    }
    var state: ViewState = .normal("") {
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
    
    var showDescriptionInNormalState: Bool = false {
        didSet {
           updateUI()
        }
    }
    
    //MARK:- init methods
    
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
        errorLabel.textColor = UIColor.BiWFColors.strawberry
        
        //textField
        textField.textColor = UIColor.BiWFColors.eggplant
        textField.font = .regular(ofSize: UIFont.font16)
        let paddingView = UIView.init(frame: CGRect.init(x: 0,
                                                         y: 0,
                                                         width: (Constants.TextField.leftViewLeftInset - 6),
                                                         height: self.textField.frame.size.height))
        textField.leftView = paddingView
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.leftViewMode = UITextField.ViewMode.always
        textField.layer.masksToBounds = true
    }
    
    /// Updates the UI everytime when it's called
    private func updateUI() {
        switch state {
        case .normal(let description):
            //NameLabel
            nameLabel.font = .regular(ofSize: UIFont.font12)
            nameLabel.textColor = UIColor.BiWFColors.dark_grey
            setNameLabelText()
            
            //errorLabel
            errorLabel.text = showDescriptionInNormalState ? description : ""
            errorLabel.textColor = UIColor.BiWFColors.med_grey
            errorLabel.isHidden = !showDescriptionInNormalState
            
            //textfield
            textField.layer.borderColor = UIColor.BiWFColors.light_grey.cgColor
            textField.isEnabled = true
            
        case .error(let errorMsg):
            //NameLabel
            nameLabel.font = .bold(ofSize: UIFont.font12)
            nameLabel.textColor = UIColor.BiWFColors.strawberry
            nameLabel.text = "\(textFieldName)*"
            
            //errorLabel
            errorLabel.text = errorMsg
            errorLabel.textColor = UIColor.BiWFColors.strawberry
            errorLabel.isHidden = false
            
            //textfield
            textField.layer.borderColor = UIColor.BiWFColors.strawberry.cgColor
            textField.layer.masksToBounds = true
            
        case .errorWithOutMessage:
            //textfield
            textField.layer.borderColor = UIColor.BiWFColors.strawberry.cgColor
            textField.layer.masksToBounds = true
            
        case .disable:
            textField.layer.borderColor = UIColor.BiWFColors.light_grey.cgColor
            textField.layer.masksToBounds = true
            textField.isEnabled = false
        }
    }
    
    /// Sets name for textfield
    private func setNameLabelText() {
        let text = NSMutableAttributedString.init(string: textFieldName,
                                                  attributes: [.foregroundColor: UIColor.BiWFColors.dark_grey])
        
        if isOptional {
            let optionalText = NSMutableAttributedString.init(string: " (\(Constants.TextField.optional))",
                attributes: [.foregroundColor: UIColor.BiWFColors.dark_grey])
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
    
    /// Sets right view on textfield
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
