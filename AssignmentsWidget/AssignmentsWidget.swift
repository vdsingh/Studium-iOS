//
//  AssignmentsWidget.swift
//  AssignmentsWidget
//
//  Created by Vikram Singh on 6/25/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    let dataService = AssignmentsWidgetDataService.shared
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), assignments: self.dataService.getAssignments())
//        SimpleEntry(date: Date(), assignments: self.dataService.getAssignments())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), assignments: self.dataService.getAssignments())
//        let entry = SimpleEntry(date: Date(), streak: self.dataService.progress())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, streak: self.dataService.progress())
            let entry = SimpleEntry(date: entryDate, assignments: self.dataService.getAssignments())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let assignments: [AssignmentWidgetModel]
}

struct AssignmentsWidgetEntryView : View {
    
    var entry: Provider.Entry
    
    var assignmentWidgetModels: [AssignmentWidgetModel] {
        self.entry.assignments
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if assignmentWidgetModels.isEmpty {
                Text("All Assignments Completed 🎉")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(0)
            } else {
                VStack(alignment: .leading) {
                    Text("Incomplete Assignments:")
                        .font(.system(size: 20, weight: .bold))
                    ForEach(self.assignmentWidgetModels, id: \.self) { assignment in
                        AssignmentCellView(assignmentModel: assignment)
                    }
                    Spacer()
                }
            }
        }
        .containerBackground(.background, for: .widget)
    }
}

struct AssignmentCellView: View {
    
    @State var assignmentModel: AssignmentWidgetModel
    
    var body: some View {
        Button(intent: MarkAssignmentCompleteIntent(assignmentID: self.assignmentModel.id)) {
            HStack {
                Image(systemName: self.assignmentModel.isComplete ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(5)
                    .foregroundStyle(Color(UIColor(hex: self.assignmentModel.colorHex)))
                
                VStack(alignment: .leading) {
                    Text(self.assignmentModel.name)
                        .strikethrough(self.assignmentModel.isComplete, pattern: .solid, color: .primary)
                        .font(.body)
                    HStack {
                        Text(self.assignmentModel.course)
                        Spacer()
                        Text(self.assignmentModel.dueDate, style: .date)
                    }
                    .font(.caption)
                }
                
                Spacer()
            }
        }
        .buttonStyle(.plain)
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

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
#Preview(as: .systemSmall) {
    AssignmentsWidget()
} timeline: {
    SimpleEntry(date: Date(), assignments: [])
//    SimpleEntry(date: .now, assignments: [])
}
