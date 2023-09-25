//
//  ShowNotificationSelectionButton.swift
//  Studium
//
//  Created by Vikram Singh on 9/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

/// Button that a user taps to show the "notification selection panel"
struct ShowNotificationSelectionButton: View {
    @Binding var selectedOptions: [AlertOption]
    
    var selectedOptionsString: String {
        self.selectedOptions.map { "\($0.rawValue)" }
            .joined(separator: " ")
    }
    
    var body: some View {
        NavigationLink(destination: NotificationSelectorView(selectedOptions: self.$selectedOptions)) {
            HStack {
                MiniIcon(color: StudiumColor.primaryAccent.color, image: StudiumIcon.bell.uiImage)
                Text("Remind Me")
                    .foregroundStyle(StudiumColor.primaryLabel.color)
                Spacer()
                Text("\(self.selectedOptions.count) selected")
                    .font(StudiumFont.body.font)
                    .foregroundStyle(StudiumColor.placeholderLabel.color)
            }
        }
    }
}
