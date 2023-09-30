//
//  RecurringEventCell.swift
//  Studium
//
//  Created by Vikram Singh on 9/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftUI

struct RecurringEventCell: View {
    @ObservedRealmObject var recurringEvent: RecurringStudiumEvent
    var body: some View {
        if !self.recurringEvent.isInvalidated {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    ZStack(alignment: .center) {
                        MediumIcon(image: SystemIcon.circle.uiImage, color: self.recurringEvent.color.color)
                        SmallIcon(image: self.recurringEvent.icon.uiImage)
                    }
                    
                    VStack(alignment: .leading, spacing: Increment.one) {
                        StudiumSubtitle(self.recurringEvent.name)
                        if !self.recurringEvent.location.trimmed().isEmpty {
                            HStack {
                                TinyIcon(image: SystemIcon.map.uiImage)
                                StudiumText(self.recurringEvent.location)
                            }
                        }
                    }
                    
                    Spacer()
                    StudiumEventViewDivider()

                    VStack(alignment: .trailing) {

                        HStack {
                            TinyIcon(color: StudiumColor.placeholderLabel.color, image: SystemIcon.clock.uiImage)
                            StudiumSubtext("in 3 hours")
                        }
                        Text(self.recurringEvent.startDate.format(with: DateFormat.standardTime))
                            .font(.system(size: 15))
                        Text(self.recurringEvent.endDate.format(with: DateFormat.standardTime))
                                .font(.system(size: 15))
                    }
                }
                
                WeekdaysSelectedView(selectedDays: self.recurringEvent.days, tintColor: self.recurringEvent.color.color)
            }
            .padding(Increment.four)
            .border(self.recurringEvent.color.color, width: Increment.one)
            .frame(maxHeight: 80)
        }
    }
}

class RecurringEventTableViewCell: DeletableEventCell {
    static let id = "RecurringEventTableViewCell"
    private weak var controller: UIHostingController<RecurringEventCell>?

    func host(parent: UIViewController,
              event: RecurringStudiumEvent) {
        self.event = event
        
        let view = RecurringEventCell(recurringEvent: event)
        if let controller = self.controller {
            controller.rootView = view
            controller.view.layoutIfNeeded()
        } else {
            let swiftUICellViewController = UIHostingController(rootView: view)
            self.controller = swiftUICellViewController
            swiftUICellViewController.view.backgroundColor = ColorManager.cellBackgroundColor
            parent.addChild(swiftUICellViewController)
            self.contentView.addSubview(swiftUICellViewController.view)
            swiftUICellViewController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.contentView.leadingAnchor.constraint(equalTo: swiftUICellViewController.view.leadingAnchor),
                self.contentView.trailingAnchor.constraint(equalTo: swiftUICellViewController.view.trailingAnchor),
                self.contentView.topAnchor.constraint(equalTo: swiftUICellViewController.view.topAnchor),
                self.contentView.bottomAnchor.constraint(equalTo: swiftUICellViewController.view.bottomAnchor)
            ])

            swiftUICellViewController.didMove(toParent: parent)
            swiftUICellViewController.view.layoutIfNeeded()
        }
    }
}

struct RecurringEventCellPreview: PreviewProvider {
    static var previews: some View {
        RecurringEventCell(recurringEvent: Course.mock())
        
    }
}

//class ColorPickerCellV2: UITableViewCell {
//    static let id = "ColorPickerCellV2"
//    @State var selectedColor: UIColor?
//}


//
//  CourseCell.swift
//  Studium
//
//  Created by Vikram Singh on 5/14/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//
//
//import UIKit
//import RealmSwift
//import SwipeCellKit
//import ChameleonFramework
//
////TODO: Docstrings
//class DEPRECATEDRecurringEventCell: DeletableEventCell {
//
//    static let id = "DEPRECATEDRecurringEventCell"
//
//    @IBOutlet weak var background: UIImageView!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var locationLabel: UILabel!
//    @IBOutlet weak var timeLabel: UILabel!
//    @IBOutlet weak var iconImage: UIImageView!
//    @IBOutlet weak var iconCircle: UIImageView!
//    @IBOutlet var dayLabels: [UILabel]!
//    @IBOutlet var dayBoxes: [UIImageView]!
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.background.layer.cornerRadius = 15
//        self.background.backgroundColor = StudiumColor.secondaryBackground.uiColor
//    }
//
//    //TODO: Docstrings
//    func loadData(
//        courseName: String,
//        location: String,
//        startTime: Date,
//        endTime: Date,
//        days: Set<Weekday>,
//        color: UIColor,
//        recurringEvent: RecurringStudiumEvent,
//        icon: StudiumIcon
//    ) {
//        Log.d("Loading data for event: \(recurringEvent)")
//        self.event = recurringEvent //just edited
//        self.iconImage.image = icon.uiImage
//        self.iconImage.tintColor = color
//        self.iconCircle.tintColor = color
//        self.background.layer.borderColor = color.cgColor
//        
//        self.nameLabel.text = courseName
//        self.nameLabel.textColor = StudiumColor.primaryLabel.uiColor
//        
//        self.locationLabel.text = recurringEvent.location
//        self.locationLabel.textColor = StudiumColor.placeholderLabel.uiColor
//
//        var timeText = startTime.format(with: DateFormat.standardTime)
//        timeText.append(" - \(endTime.format(with: DateFormat.standardTime))")
//        self.timeLabel.text = timeText
//        self.timeLabel.textColor = StudiumColor.primaryLabel.uiColor
//        
//        for dayBox in self.dayBoxes {
//            dayBox.layer.borderWidth = 2
//            dayBox.layer.borderColor = color.cgColor
//            dayBox.layer.cornerRadius = 5
//        }
//        
//        // Reset all of the day labels and day boxes
//        for i in 0..<self.dayLabels.count {
//            self.dayLabels[i].textColor = StudiumColor.primaryLabel.uiColor
//            self.dayBoxes[i].backgroundColor = .none
//        }
//        
//        // highlight the day labels and day boxes for the selected days.
//        for dayVal in days {
//            let index = dayVal.rawValue - 1
//            self.dayBoxes[index].backgroundColor = color
//            self.dayLabels[index].textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
//        }
//    }
//}
