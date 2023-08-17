//
//  DaysView.swift
//  Studium
//
//  Created by Vikram Singh on 8/13/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI
import VikUtilityKit

struct DaysView: View {
    @State var selectedDays: Set<Weekday>
    
    var body: some View {
        HStack(alignment: .center) {
            ForEach(Weekday.allKnownCases, id: \.self) { weekday in
                DayView(day: weekday, isSelected: self.selectedDays.contains(weekday))
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct DayView: View {
    let day: Weekday
    let isSelected: Bool
    
    var body: some View {
        if self.isSelected {
            ZStack {
                StudiumColor.primaryAccent.color
                    .clipShape(.rect(cornerRadius: Increment.one))

                Text(self.day.buttonText)
                    .font(StudiumFont.subText.font)
                    .foregroundStyle(StudiumFont.body.color)
                    .padding(2)
            }
        } else {
            Text(self.day.buttonText)
                .font(StudiumFont.subText.font)
                .foregroundStyle(StudiumColor.primaryAccent.color)
            
        }
    }
}
