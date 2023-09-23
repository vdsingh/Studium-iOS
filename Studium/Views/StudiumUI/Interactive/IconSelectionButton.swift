//
//  IconSelectionButton.swift
//  Studium
//
//  Created by Vikram Singh on 9/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

struct IconSelectionButton: View {
    
    @Binding var icon: StudiumIcon
    let navigationController: UINavigationController?
    
    var body: some View {
        Button {
            let iconSelectionViewController = LogoSelectorViewController.instantiate()
            iconSelectionViewController.iconWasSelected = { icon in
                self.icon = icon
            }
            
            if let navigationController = self.navigationController {
                navigationController.pushViewController(iconSelectionViewController, animated: true)
            } else {
                Log.e("No navigation controller was passed to present icon selection form")
            }
        } label: {
            HStack {
                Text("Icon")
                    .foregroundStyle(StudiumColor.primaryLabel.color)
                Spacer()
                SmallIcon(color: StudiumColor.primaryAccent.color,
                         image: self.icon.uiImage)
                MiniIcon(color: StudiumColor.placeholderLabel.color,
                         image: SystemIcon.chevronRight.uiImage)
            }
        }
    }
}
