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
    var body: some View {
        Text(text)
            .font(StudiumFont.title.font)
            .foregroundStyle(StudiumColor.primaryLabel.color)
    }
    
    init(_ text: String) {
        self.text = text
    }
}
