//
//  StudiumSubtitle.swift
//  Studium
//
//  Created by Vikram Singh on 7/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct StudiumSubtitle: View {
    let text: String
    let textColor: Color

    var body: some View {
        Text(self.text)
            .font(StudiumFont.subTitle.font)
            .foregroundStyle(self.textColor)
    }
    
    init(_ text: String, textColor: Color = StudiumFont.subTitle.color) {
        self.text = text
        self.textColor = textColor
    }
}
