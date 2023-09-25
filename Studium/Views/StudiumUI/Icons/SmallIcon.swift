//
//  SmallIcon.swift
//  Studium
//
//  Created by Vikram Singh on 7/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI


/// 25 x 25 Image
struct SmallIcon: View {
    
    let color: Color
    var image: UIImage
    var renderingMode: Image.TemplateRenderingMode
    
    var body: some View {
        Image(uiImage: self.image)
            .resizable()
            .renderingMode(self.renderingMode)
            .foregroundStyle(self.color)
            .scaledToFit()
            .frame(width: 25, height: 25)
    }
    
    init(color: Color = StudiumColor.primaryLabel.color,
         image: UIImage,
         renderingMode: Image.TemplateRenderingMode = .template) {
        self.color = color
        self.image = image
        self.renderingMode = renderingMode
    }
    
    init(color: Color = StudiumColor.primaryLabel.color,
         image: CreatesUIImage,
         renderingMode: Image.TemplateRenderingMode = .template) {
        self.color = color
        self.image = image.uiImage
        self.renderingMode = renderingMode
    }
}

/// 20 x 20 Image
struct MiniIcon: View {
    
    let color: Color
    var image: UIImage
    
    var body: some View {
        Image(uiImage: self.image)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(self.color)
            .scaledToFit()
            .frame(width: 20, height: 20)
    }
    
    init(color: Color = StudiumColor.primaryLabel.color, image: UIImage) {
        self.color = color
        self.image = image
    }
}

/// 20 x 20 Image
struct TinyIcon: View {
    
    let color: Color
    var image: UIImage
    
    var body: some View {
        Image(uiImage: self.image)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(self.color)
            .scaledToFit()
            .frame(width: 12, height: 12)
    }
    
    init(color: Color = StudiumColor.primaryLabel.color, image: UIImage) {
        self.color = color
        self.image = image
    }
}
