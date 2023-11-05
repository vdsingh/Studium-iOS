//
//  TimeLengthPickerView.swift
//  Studium
//
//  Created by Vikram Singh on 9/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct TimeLengthPickerView: View {
    
    init(totalMinutes: Binding<Int>) {
        self._totalMinutes = totalMinutes
        self._selectedHours = State(initialValue: totalMinutes.wrappedValue / 60)
        self._selectedMinutes = State(initialValue: totalMinutes.wrappedValue % 60)
    }
    
    @State private var selectedHours: Int
    @State private var selectedMinutes: Int
    
    @Binding var totalMinutes: Int
    
    let hoursRange: [Int] = Array(0...23)
    let minutesRange: [Int] = Array(0...59)
    
    let pickerHeight = Increment.ten + Increment.six
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(" Length of Habit")
            
            HStack {
                Picker("Hours", selection: self.$selectedHours) {
                    ForEach(self.hoursRange, id: \.self) { hour in
                        Text("\(hour) hours")
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: self.pickerHeight)
                Spacer()
                
                Picker("Minutes", selection: self.$selectedMinutes) {
                    ForEach(self.minutesRange, id: \.self) { minute in
                        Text("\(minute) mins")
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: self.pickerHeight)
            }
        }
        .onChange(of: self.selectedHours) { _ in
            self.updateTotalMinutes()
        }
        .onChange(of: self.selectedMinutes) { _ in
            self.updateTotalMinutes()
        }
    }
    
    private func updateTotalMinutes() {
        self.totalMinutes = self.selectedHours * 60 + self.selectedMinutes
    }
}
