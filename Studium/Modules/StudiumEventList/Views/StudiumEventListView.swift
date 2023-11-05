//
//  StudiumEventListView.swift
//  Studium
//
//  Created by Vikram Singh on 10/1/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI
import RealmSwift

/// Generic ViewModel for StudiumEvent Lists
class StudiumEventListViewModel<T: StudiumEvent>: ObservableObject {

    /// Whether the form for
    @Published var isShowingAddForm = false

    /// The text in the search bar
    @Published private var searchText = ""

    private var eventResults: Results<T>
    private var realmNotificationToken: NotificationToken?

    /// Determines whether or not to allow an event in the list
    private let filter: (T) -> Bool

    /// Separates the array of StudiumEvents into multiple arrays, representing sections
    private let separator: ([T]) -> [StudiumEventListSection<T>]

    // MARK: - Computed

    /// Whether or not to show the image detail view indicating that events are empty
    var showNoHabitsView: Bool {
        return self.eventResults.isEmpty
    }

    /// The events, separated into sections
    var sectionedEvents: [StudiumEventListSection<T>] {
        let filteredEvents = self.eventResults
            .filter(self.filter)
            .filter {
                self.searchText.isEmpty || $0.showsOnSearch(searchText: self.searchText)
            }
        let separatedEvents = self.separator([T](filteredEvents))
        return separatedEvents
    }

    init(filter: @escaping (T) -> Bool,
         separator: @escaping ([T]) -> [StudiumEventListSection<T>]) {
        self.filter = filter
        self.separator = separator
        self.eventResults = DatabaseService.shared.realm.objects(T.self)
        self.realmNotificationToken = self.eventResults.observe { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    func searchFor(_ searchText: String) {
        self.searchText = searchText
    }

    // MARK: View Building

    func createDetailsView(for event: T) -> AnyView {
        guard !event.isInvalidated else {
            return AnyView(EmptyView())
        }

        return event.detailsView()
    }

    func createAddFormView() -> AnyView {
        return T.addFormView()
    }

    func createEmptyListCTACard() -> PositiveCTACardView {
        let viewModel = T.emptyListPositiveCTACardViewModel
        viewModel.setButtonAction {
            self.isShowingAddForm = true
        }

        return PositiveCTACardView(viewModel: viewModel)
    }
}

/// Generic View for a StudiumEvent List
struct StudiumEventListView<T: StudiumEvent>: View {

    @ObservedObject var viewModel: StudiumEventListViewModel<T>

    @State private var searchText: String = ""

    var body: some View {
        AppDelegate.setStudiumListNavigationStyle()
        return NavigationView {
            VStack {
                if self.viewModel.showNoHabitsView {
                    self.viewModel.createEmptyListCTACard()
                } else {
                    self.listView
                }
            }
            .sheet(isPresented: self.$viewModel.isShowingAddForm) {
                self.viewModel.createAddFormView()
            }
        }
    }

    /// View for the list of events itself
    var listView: some View {
        List {
            ForEach(self.viewModel.sectionedEvents, id: \.self) { section in
                if !section.events.isEmpty {
                    Section("\(section.sectionTitle) (\(section.events.count) events)") {
                        ForEach(section.events, id: \.self) { event in
                            if !event.isInvalidated {
                                if let event = event as? RecurringStudiumEvent {
                                    RecurringEventCell(
                                        viewModel: RecurringEventCellViewModel(
                                            recurringEvent: event
                                        )
                                    )
                                } else if let event = event as? NonRecurringStudiumEvent {
                                    NonRecurringEventCell(event: event, checkboxWasTapped: {})
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
