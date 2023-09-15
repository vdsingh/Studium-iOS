//
//  StudiumTextfieldStyle.swift
//  Studium
//
//  Created by Vikram Singh on 8/1/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct StudiumTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Increment.two)
            .background(StudiumColor.tertiaryBackground.color)
            .cornerRadius(Increment.one)
    }
}

extension View {
    func customTextFieldStyle() -> some View {
        self.modifier(StudiumTextFieldStyle())
    }
}
