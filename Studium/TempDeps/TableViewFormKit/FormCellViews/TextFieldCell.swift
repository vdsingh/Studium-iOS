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

import SwiftUI

struct TextFieldCellV2View: View {
    @State var text: String
    
    let placeholderText: String
    let charLimit: Int?
    let textWasEdited: (String) -> Void
    var body: some View {
        ZStack {
            TextField(self.placeholderText, text: self.$text)
                .onChange(of: self.text) { _ in
                    self.textWasEdited(self.text)
                    if let charLimit = self.charLimit {
                        self.text = String(self.text.prefix(charLimit))
                    }
                }
            if let charLimit = self.charLimit {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Spacer()
                        Spacer()
                        Text("\(self.text.count)/\(charLimit)")
                            .font(.system(size: Increment.two))
                            .foregroundStyle(self.text.count >= charLimit ? .red : StudiumColor.placeholderLabel.color)
                        Spacer()
                    }
                }
            }
        }.padding(.horizontal, Increment.four)
    }
}

class TextFieldCellV2: BasicCell {
    static let id = "TextFieldCellV2"
    
    private weak var controller: UIHostingController<TextFieldCellV2View>?
//    private let colorWasSelected: (Color) -> Void = { _ in }
    
//    cell.host(parent: self, initialText: text, charLimit: charLimit, textfieldWasEdited: textfieldWasEdited)

    func host(
        parent: UIViewController,
        initialText: String?,
        charLimit: Int?,
        placeholder: String,
        textfieldWasEdited: @escaping (String) -> Void
    ) {
        let view = TextFieldCellV2View(text: initialText ?? "", placeholderText: placeholder, charLimit: charLimit, textWasEdited: textfieldWasEdited)
        if let controller = self.controller {
            controller.rootView = view
            controller.view.layoutIfNeeded()
        } else {
            let swiftUICellViewController = UIHostingController(rootView: view)
            self.controller = swiftUICellViewController
            swiftUICellViewController.view.backgroundColor = ColorManager.cellBackgroundColor
            parent.addChild(swiftUICellViewController)
            self.contentView.addSubview(swiftUICellViewController.view)
            swiftUICellViewController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.contentView.leadingAnchor.constraint(equalTo: swiftUICellViewController.view.leadingAnchor),
                self.contentView.trailingAnchor.constraint(equalTo: swiftUICellViewController.view.trailingAnchor),
                self.contentView.topAnchor.constraint(equalTo: swiftUICellViewController.view.topAnchor),
                self.contentView.bottomAnchor.constraint(equalTo: swiftUICellViewController.view.bottomAnchor)
            ])

            swiftUICellViewController.didMove(toParent: parent)
            swiftUICellViewController.view.layoutIfNeeded()
        }
    }
}
