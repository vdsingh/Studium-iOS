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
    let placeholderText: String
    let charLimit: TextFieldCharLimit
    
    var body: some View {
        HStack {
            TextField(self.placeholderText, text: self.$text)
                .tint(StudiumColor.primaryAccent.color)
            
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
