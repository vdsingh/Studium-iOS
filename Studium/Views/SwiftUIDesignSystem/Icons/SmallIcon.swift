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
    var image: UIImage
    var body: some View {
        Image(uiImage: self.image)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.white)
            .scaledToFit()
            .frame(width: 25, height: 25)
    }
}
