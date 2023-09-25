//
//  StudiumSubtext.swift
//  Studium
//
//  Created by Vikram Singh on 9/23/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI
struct StudiumSubtext: View {
    let text: String
    var body: some View {
        Text(text)
            .font(StudiumFont.subText.font)
            .foregroundStyle(StudiumFont.subText.color)
    }
    
    init(_ text: String) {
        self.text = text
    }
}
