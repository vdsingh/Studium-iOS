//
//  TextFieldCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
protocol UITextFieldDelegate {
    func textEdited(sender: UITextField)
}
class TextFieldCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    var delegate: UITextFieldDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func finishedEditingText(_ sender: UITextField) {
        
    }
    
    @IBAction func textEdited(_ sender: UITextField) {
        delegate!.textEdited(sender: sender)
    }
}
