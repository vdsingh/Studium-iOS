//
//  MediumIcon.swift
//  Studium
//
//  Created by Vikram Singh on 7/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

/// 50 x 50 Image
struct MediumIcon: View {
    var image: UIImage
    let color: Color

    var body: some View {
        Image(uiImage: self.image)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(self.color)
            .scaledToFit()
            .frame(width: 50, height: 50)
    }
}
