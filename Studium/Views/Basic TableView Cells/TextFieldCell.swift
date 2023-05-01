//
//  TextFieldCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

//TODO: Docstrings
public protocol UITextFieldDelegateExt {
    
    //TODO: Docstrings
    func textEdited(sender: UITextField, textFieldID: FormCellID.TextFieldCell)
}

//TODO: Docstrings
class TextFieldCell: BasicCell {
    
    //TODO: Docstrings
    public var textFieldID: FormCellID.TextFieldCell?

    //TODO: Docstrings
    @IBOutlet weak var textField: UITextField!
    
    //TODO: Docstrings
    public var delegate: UITextFieldDelegateExt!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.returnKeyType = UIReturnKeyType.done
        
        self.backgroundColor = StudiumColor.secondaryBackground.uiColor
        self.textField.textColor = StudiumColor.primaryLabel.uiColor
        
//        self.textField.placeholder
        self.textField.attributedPlaceholder = NSAttributedString(string: "Enter Text", attributes: [NSAttributedString.Key.foregroundColor: StudiumColor.secondaryLabel.uiColor])

    }

    //TODO: Docstrings
    @IBAction func finishedEditingText(_ sender: UITextField) {
        
    }
    
    //TODO: Docstrings
    @IBAction func textEdited(_ sender: UITextField) {
        if let textFieldID = self.textFieldID {
            delegate.textEdited(sender: sender, textFieldID: textFieldID)
        } else {
            print("$ ERROR: textFieldID not supplied.")
        }
    }
}

extension TextFieldCell: FormCellProtocol {
    static var id: String = "TextFieldCell"
}
