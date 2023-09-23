//
//  NotificationSelectionButton.swift
//  Studium
//
//  Created by Vikram Singh on 9/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct NotificationSelectionButton: View {
    var body: some View {
        Button {
            
        } label: {
            HStack {
                Text("Remind Me")
                    .foregroundStyle(StudiumColor.primaryLabel.color)
                Spacer()
                MiniIcon(color: StudiumColor.placeholderLabel.color,
                         image: SystemIcon.chevronRight.uiImage)
            }
        }
    }
}
