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
    
    var body: some View {
        Image(uiImage: self.image)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(self.color)
            .scaledToFit()
            .frame(width: 25, height: 25)
    }
    
    init(color: Color = StudiumColor.primaryLabel.color, image: UIImage) {
        self.color = color
        self.image = image
    }
    
    init(color: Color = StudiumColor.primaryLabel.color, image: CreatesUIImage) {
        self.color = color
        self.image = image.uiImage
    }
    
    init(color: Color = StudiumColor.primaryLabel.color, image: SystemIcon) {
        self.color = color
        self.image = image.createImage()
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
