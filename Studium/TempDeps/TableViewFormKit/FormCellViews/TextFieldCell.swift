//
//  TextFieldCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit


//TODO: Docstrings
public class TextFieldCell: BasicCell {
    
    //TODO: Docstrings
//    public var textfieldID: FormCellID.TextFieldCellID?

    //TODO: Docstrings
    @IBOutlet weak public var textField: UITextField!
    
    @IBOutlet weak var charLimitLabel: UILabel!
    
    var charLimit: Int? {
        didSet {
            self.updateCharLimitLabel(textField: self.textField)
        }
    }
    
    //TODO: Docstrings
//    public var delegate: UITextFieldDelegateExtension!
    
    //TODO: Docstring
    public var textFieldWasEdited: ((String) -> Void)?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.textField.returnKeyType = UIReturnKeyType.done
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: ColorManager.placeholderTextColor // Set your desired color here
        ]
        
        self.textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: attributes)
        self.textField.textColor = ColorManager.primaryTextColor
        
        self.charLimitLabel.isHidden = true
        self.charLimitLabel.font = .systemFont(ofSize: 10)
        self.charLimitLabel.textColor = ColorManager.placeholderTextColor
    }

    //TODO: Docstrings
    @IBAction func finishedEditingText(_ sender: UITextField) {
        
    }
    
    //TODO: Docstrings
    @IBAction func textEdited(_ sender: UITextField) {
//        if let textFieldID = self.textFieldID {
//            self.delegate.textEdited(sender: sender, textFieldID: textFieldID)
        if let text = sender.text {
            if let textFieldWasEdited = self.textFieldWasEdited {
                textFieldWasEdited(text)
            }
            self.updateCharLimitLabel(textField: sender)
        }
//        }
        
//        else {
//            print("$ ERROR: textFieldID not supplied.")
//        }
    }
    
    private func updateCharLimitLabel(textField: UITextField) {
        if let charLimit = self.charLimit {
            self.charLimitLabel.isHidden = false
            let numChars = (textField.text ?? "").count
            self.charLimitLabel.text = "\(numChars)/\(charLimit)"
            if numChars > charLimit {
                self.charLimitLabel.textColor = ColorManager.failure
            } else {
                self.charLimitLabel.textColor = ColorManager.placeholderTextColor
            }
        } else {
            self.charLimitLabel.isHidden = true
        }
    }
    
    func setCharLimit(_ charLimit: Int?) {
        self.charLimit = charLimit
    }
}

extension TextFieldCell: FormCellProtocol {
    public static var id: String = "TextFieldCell"
}
