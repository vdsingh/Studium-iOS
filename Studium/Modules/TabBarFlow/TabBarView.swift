//
//  TabBarView.swift
//  Studium
//
//  Created by Vikram Singh on 10/1/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI
//
// struct TabItemView: View {
//    var unselectedImage: UIImage
//    var selectedImage: UIImage
//    var tabName: String
//    
//    var isSelected: Bool
//    
//    var body: some View {
//        VStack {
//            Image(uiImage: self.unselectedImage)
//                .font(.system(size: 30))
//            Text(self.tabName)
//        }
//    }
// }
//
// struct TabBarView: View {
//    @State private var selectedTab = 0
//    
//    var habitsViewModel: StudiumEventListViewModel
//    var coursesViewModel: StudiumEventListViewModel
//    var toDoViewModel: StudiumEventListViewModel
////    var coursesViewModel: StudiumEventListViewModel
//
//
//    var body: some View {
//        TabView(selection: self.$selectedTab) {
////            StudiumEventListView(viewModel: self.habitsViewModel)
////                .onTapGesture {
////                    self.selectedTab = 0
////                }
////                .tabItem {
////                    Label(
////                        title: { Text("Calendar") },
////                        icon: {
////                            Image(uiImage: self.selectedTab == 0 ? SystemIcon.clockFill.uiImage : SystemIcon.clock.uiImage
////                            )
////                        }
////                    )
////                }
////                .tag(0)
//            
//            StudiumEventListView(viewModel: self.habitsViewModel)
//                .onTapGesture {
//                    self.selectedTab = 1
//                }
//                .tabItem {
//                    Label(
//                        title: { Text("Habits") },
//                        icon: {
//                            Image(uiImage: self.selectedTab == 1 ? SystemIcon.heartFill.uiImage : SystemIcon.heart.uiImage
//                            )
//                        }
//                    )
//                }
//                .tag(1)
//            
//            StudiumEventListView(viewModel: self.coursesViewModel)
//                .onTapGesture {
//                    self.selectedTab = 2
//                }
//                .tabItem {
//                    Label(
//                        title: { Text("Courses") },
//                        icon: {
//                            Image(uiImage: self.selectedTab == 2 ? SystemIcon.bookFill.uiImage : SystemIcon.book.uiImage
//                            )
//                        }
//                    )
//                }
//                .tag(2)
//            
//            StudiumEventListView(viewModel: self.toDoViewModel)
//                .onTapGesture {
//                    self.selectedTab = 3
//                }
//                .tabItem {
//                    Label(
//                        title: { Text("To Do") },
//                        icon: {
//                            Image(uiImage: self.selectedTab == 3 ? SystemIcon.listClipboardFill.uiImage : SystemIcon.listClipboard.uiImage
//                            )
//                        }
//                    )
//                }
//                .tag(3)
//        }
//        .tint(StudiumColor.primaryAccent.color)
//    }
// }
//
// struct TabBarViewPreview: PreviewProvider {
//    static var previews: some View {
//        TabBarView(
//            habitsViewModel: StudiumEventListViewModel(studiumEventTypes: [.habit]),
//            coursesViewModel: StudiumEventListViewModel(studiumEventTypes: [.course]),
//            toDoViewModel: StudiumEventListViewModel(studiumEventTypes: [.otherEvent, .assignment])
//        )
//    }
// }

// import Foundation
// import UIKit
//
//// TODO: Docstrings
// enum TabItemConfig: Int {
//    case calendarFlow = 0
//    case habitsFlow = 1
//    case coursesFlow = 2
//    case toDoFlow = 3
//    case treeFlow = 4
//    
//    // TODO: Docstrings
//    var title: String {
//        switch self {
//        case .calendarFlow:
//            return "Calendar"
//        case .habitsFlow:
//            return "Habits"
//        case .coursesFlow:
//            return "Courses"
//        case .toDoFlow:
//            return "To Do"
//        case .treeFlow:
//            return "Tree"
//        }
//    }
//    
//    // TODO: Docstrings
//    var images: (unselected: UIImage, selected: UIImage) {
//        switch self {
//        case .calendarFlow:
//            return (SystemIcon.clock.createImage(), SystemIcon.clockFill.createImage())
//        case .habitsFlow:
//            return (SystemIcon.heart.createImage(), SystemIcon.heartFill.createImage())
//        case .coursesFlow:
//            return (SystemIcon.book.createImage(), SystemIcon.bookFill.createImage())
//        case .toDoFlow:
//            if #available(iOS 16.0, *) {
//                return (SystemIcon.listClipboard.createImage(), SystemIcon.listClipboardFill.createImage())
//            } else {
//                return (StudiumIcon.clipboardRegular.createTabBarIcon(), StudiumIcon.clipboardSolid.createTabBarIcon())
//            }
//        case .treeFlow:
//            return (SystemIcon.tree.createImage(), SystemIcon.treeFill.createImage())
//        }
//    }
//    
//    // TODO: Docstrings
//    var orderNumber: Int {
//        return self.rawValue
//    }
// }
