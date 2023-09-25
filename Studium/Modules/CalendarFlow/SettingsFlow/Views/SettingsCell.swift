//
//  SettingsCell.swift
//  Studium
//
//  Created by Vikram Singh on 9/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct SettingsCell: View {
    
    private var icon: UIImage?
    private let iconColor: UIColor
    private var iconRenderingMode: Image.TemplateRenderingMode = .template
    private var text: String
    private var subText: String?
    private var onClick: (SettingsCell) -> Void
    @State var loading: Bool = false
    
    var body: some View {
        Button {
            self.loading = true
            self.onClick(self)
        } label: {
            if self.loading {
                HStack(spacing: Increment.two) {
                    Spacer()
                    Spinner()
                        .frame(height: Increment.six)
                    Spacer()
                }
            } else {
                HStack {
                    if let icon = self.icon {
                        SmallIcon(color: self.iconColor.color,
                                  image: icon,
                                  renderingMode: self.iconRenderingMode)
                    }
                    
                    VStack(alignment: .leading) {
                        StudiumText(self.text)
                        if let subText = self.subText, !subText.trimmed().isEmpty {
                            StudiumSubtext(subText)
                        }
                    }
                }
            }
        }
    }
    
    init(icon: UIImage,
         iconColor: UIColor = StudiumColor.primaryAccent.uiColor,
         text: String,
         subText: String? = nil,
         onClick: @escaping (SettingsCell) -> Void) {
        self.icon = icon
        self.iconColor = iconColor
        self.subText = subText
        self.text = text
        self.onClick = onClick
    }
    
    init(
        icon: any CreatesUIImage,
        iconRenderingMode: Image.TemplateRenderingMode = .template,
        text: String,
        onClick: @escaping (SettingsCell) -> Void
    ) {
        self.init(icon: icon.uiImage, text: text, onClick: onClick)
        self.iconRenderingMode = iconRenderingMode
    }
    
    init(text: String, onClick: @escaping (SettingsCell) -> Void) {
        self.icon = nil
        self.iconColor = StudiumColor.primaryAccent.uiColor
        self.text = text
        self.onClick = onClick
    }
}
