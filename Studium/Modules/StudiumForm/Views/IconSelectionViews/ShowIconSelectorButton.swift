//
//  IconSelectionButton.swift
//  Studium
//
//  Created by Vikram Singh on 9/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct ShowIconSelectorButton: View {
    @Binding var icon: StudiumIcon

    var body: some View {
        NavigationLink(destination: IconSelectorView(selectedIcon: self.$icon)) {
            HStack {
                Text("Icon")
                    .foregroundStyle(StudiumColor.primaryLabel.color)
                Spacer()
                SmallIcon(color: StudiumColor.primaryAccent.color, image: self.icon)
            }
        }
    }
}
