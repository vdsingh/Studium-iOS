//
//  TextFieldCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
public protocol UITextFieldDelegateExt {
    func textEdited(sender: UITextField, textFieldID: FormCellID.TextFieldCell)
}
class TextFieldCell: BasicCell {
    
    public var textFieldID: FormCellID.TextFieldCell?


    @IBOutlet weak var textField: UITextField!
    public var delegate: UITextFieldDelegateExt!
        
//    init(delegate: UITextFieldDelegateExt, style: UITableViewCell.CellStyle = .default) {
//        self.delegate = delegate
//        super.init(style: style, reuseIdentifier: TextFieldCell.id)
//    }
    
//    required init?(coder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
//        super.init(coder: coder)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.returnKeyType = UIReturnKeyType.done
        
        self.backgroundColor = defaultBackgroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func finishedEditingText(_ sender: UITextField) {
        
    }
    
    @IBAction func textEdited(_ sender: UITextField) {
        if let textFieldID = self.textFieldID {
            delegate.textEdited(sender: sender, textFieldID: textFieldID)
        } else {
            print("$ ERROR: textFieldID not supplied.")
        }
//        delegate.textEdited(sender: sender)
    }
}

extension TextFieldCell: FormCellProtocol {
    static var id: String = "TextFieldCell"
}

//extension TextFieldCell: FormCellIdentifiable {
//}
