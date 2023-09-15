//
//  StudiumTitle.swift
//  Studium
//
//  Created by Vikram Singh on 7/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct StudiumTitle: View {
    let text: String
    let textColor: Color
    var body: some View {
        Text(text)
            .font(StudiumFont.title.font)
            .foregroundStyle(self.textColor)
    }
    
    init(_ text: String, textColor: Color = StudiumColor.primaryLabel.color) {
        self.text = text
        self.textColor = textColor
    }
}
