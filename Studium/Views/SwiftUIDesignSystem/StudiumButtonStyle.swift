//
//  StudiumButtonStyle.swift
//  Studium
//
//  Created by Vikram Singh on 8/1/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct StudiumButtonStyle: ButtonStyle {
    let disabled: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, Increment.one)
            .padding(.horizontal, Increment.two)
            .background(Color(self.disabled ? .gray: StudiumColor.primaryAccent.uiColor))
            .foregroundStyle(.white)
//            .clipShape(.rect(cornerRadius: Increment.one))
    }
}
