//
//  PlusNavigationButton.swift
//  Studium
//
//  Created by Vikram Singh on 9/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct PlusNavigationButton: View {
    let onClick: () -> Void
    var body: some View {
        Button() {
            self.onClick()
        } label: {
            MiniIcon(color: StudiumFormNavigationConstants.navBarForegroundColor, image: SystemIcon.plus.createImage())
        }
    }
}
