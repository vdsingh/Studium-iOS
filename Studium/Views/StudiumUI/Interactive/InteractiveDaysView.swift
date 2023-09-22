//
//  InteractiveDaysView.swift
//  Studium
//
//  Created by Vikram Singh on 9/17/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct InteractiveDaysView: View {
    @State var selectedDays: Set<Weekday> = []
    
    var body: some View {
        HStack(alignment: .center) {
            ForEach(Weekday.allKnownCases, id: \.self) { weekday in
                InteractiveDayView(day: weekday, selectedDays: self.$selectedDays)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct InteractiveDayView: View {
    
    let day: Weekday
    @Binding var selectedDays: Set<Weekday>
    
    let tintColor: Color = StudiumColor.primaryAccent.color
    
    var isSelected: Bool {
        self.selectedDays.contains(self.day)
    }
    
    var body: some View {
        Button {
            if self.isSelected {
                self.selectedDays.remove(self.day)
            } else {
                self.selectedDays.insert(self.day)
            }
        } label: {
            self.dayTextView
        }
        .buttonStyle(BorderlessButtonStyle())
    }
    
    var dayTextView: some View {
        VStack {
            if self.isSelected {
                ZStack {
                    self.tintColor
                        .clipShape(.rect(cornerRadius: Increment.one))
                        .frame(maxHeight: Increment.four)
                    Text(self.day.buttonText)
                        .font(StudiumFont.subText.font)
                        .foregroundStyle(StudiumColor.primaryLabelColor(forBackgroundColor: self.tintColor))
                        .padding(2)
                }
            } else {
                Text(self.day.buttonText)
                    .font(StudiumFont.subText.font)
                    .foregroundStyle(self.tintColor)
            }
        }
    }
}

struct InteractiveDaysPreview: PreviewProvider {
    
    @State static var selectedDays = Set<Weekday>()
    static var previews: some View {
        InteractiveDaysView()
    }
}
