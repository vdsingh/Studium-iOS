//
//  StudiumEventViewHeader.swift
//  Studium
//
//  Created by Vikram Singh on 8/7/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct StudiumEventViewHeader: View {
    
    let icon: UIImage
    let color: Color
    let primaryTitle: String
    let secondaryTitle: String
    
    var primaryLabelColor: Color {
        Color(uiColor: StudiumColor.primaryLabelColor(forBackgroundColor: UIColor(self.color)))
    }
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                HStack(alignment: .center, spacing: Increment.three) {
                    Image(uiImage: self.icon)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(self.primaryLabelColor)
                        .frame(width: Increment.six)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        StudiumTitle(self.primaryTitle, textColor: self.primaryLabelColor)
                            .lineLimit(1)
                        
                        StudiumSubtitle(self.secondaryTitle, textColor: self.primaryLabelColor)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                }
            }
            .padding(.horizontal, Increment.three)
            .padding(.bottom, Increment.two)
        }
        .background(self.color)
        .frame(maxWidth: .infinity)
    }
}
