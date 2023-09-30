//
//  TimePicker.swift
//  Studium
//
//  Created by Vikram Singh on 9/27/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

/// Like DatePicker but only for time (hour and minute)
struct TimePicker: View {
    
    let label: String
    @Binding var time: Time
    
    /// The date selected by the DatePicker (this gets converted to Time on change)
    @State private var selectionDate: Date
    var body: some View {
        DatePicker(self.label, selection: self.$selectionDate, displayedComponents: [.hourAndMinute]).tint(StudiumColor.primaryAccent.color)
            .onChange(of: self.selectionDate) { newValue in
                self.time = self.selectionDate.time
            }
    }
    
    init(label: String, time: Binding<Time>) {
        self.label = label
        self._time = time
        self._selectionDate = State(initialValue: time.wrappedValue.arbitraryDateWithTime)
    }
}
