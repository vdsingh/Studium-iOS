//
//  StudiumTextFIeld.swift
//  Studium
//
//  Created by Vikram Singh on 9/16/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct StudiumTextField: View {
    @Binding var text: String
    @FocusState var focused: Bool
    let placeholderText: String
    let charLimit: TextFieldCharLimit
    
    var body: some View {
        HStack {
            TextField(self.placeholderText, text: self.$text)
                .onChange(of: self.text) { _ in
                    self.text = String(self.text.prefix(self.charLimit.rawValue))
                }
            
            HStack {
                Divider()
                    .background(StudiumColor.secondaryLabel.color)
                HStack {
                    Spacer()
                    Text("\(self.text.count)/\(self.charLimit.rawValue)")
                        .font(.system(size: Increment.two))
                        .foregroundStyle(StudiumColor.secondaryLabel.color)
                }
            }
            .frame(maxWidth: Increment.nine)
        }
        .listRowSeparator(.visible)
    }
}
