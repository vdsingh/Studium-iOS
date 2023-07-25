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
    var body: some View {
        ZStack {
            Ellipse()
                .frame(width: 25, height: 25)
                .foregroundStyle(.gray)
            Ellipse()
                .frame(width: 20, height: 20)
                .foregroundStyle(.red)
        }
    }
}
