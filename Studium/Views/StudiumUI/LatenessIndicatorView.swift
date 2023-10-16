//
//  LatenessIndicatorView.swift
//  Studium
//
//  Created by Vikram Singh on 7/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct LatenessIndicatorView: View {
    @State var indicatorColor: Color

    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            Ellipse()
                .frame(width: self.width, height: self.height)
                .foregroundStyle(.gray)
            Ellipse()
                .frame(width: self.width * 2/3, height: self.height * 2/3)
                .foregroundStyle(self.indicatorColor)
        }
    }

    init(_ latenessStatus: LatenessStatus, width: CGFloat = 25, height: CGFloat = 25) {
        self.indicatorColor = latenessStatus.color
        self.width = width
        self.height = height
    }
}
