//
//  AssignmentsWidget.swift
//  AssignmentsWidget
//
//  Created by Vikram Singh on 6/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> AssignmentEntry {
        AssignmentEntry(nextThreeAssignments: Array(AssignmentDataModel.shared.assignments.prefix(3)))
    }

    func getSnapshot(in context: Context, completion: @escaping (AssignmentEntry) -> ()) {
        let entry = AssignmentEntry(nextThreeAssignments: Array(AssignmentDataModel.shared.assignments.prefix(3)))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let nextAssignments = Array(AssignmentDataModel.shared.assignments.prefix(3))
        let nextEntries = [AssignmentEntry(nextThreeAssignments: nextAssignments)]
        
        let timeline = Timeline(entries: nextEntries, policy: .atEnd)
        completion(timeline)
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
    }
}

struct AssignmentEntry: TimelineEntry {
    let date: Date = .now
    let nextThreeAssignments: [AssignmentViewModel]
}

struct AssignmentsWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Assignments")
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            VStack(alignment: .leading, spacing: 6) {
                ForEach(self.entry.nextThreeAssignments) { ass in
                    AssignmentCell(assignmentViewModel: ass)
                }
            }
        }
    }
}

struct AssignmentsWidget: Widget {
    let kind: String = "AssignmentsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AssignmentsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct AssignmentCell: View {
    
    var assignmentViewModel: AssignmentViewModel
    
    var body: some View {
        HStack() {
            Image(systemName: "checkmark.circle.fill")
            VStack(alignment: .leading) {
                Text(self.assignmentViewModel.assignmentName).lineLimit(1).font(.caption)
                Text("CS 345")
                    .lineLimit(1)
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                Divider()
            }
        }
    }
}

//struct AssignmentsWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        AssignmentsWidgetEntryView(entry: SimpleEntry(date: Date()))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
