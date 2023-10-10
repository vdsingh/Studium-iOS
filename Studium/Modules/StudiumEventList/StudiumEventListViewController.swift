//
//  HabitsListViewController.swift
//  Studium
//
//  Created by Vikram Singh on 10/5/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI
import RealmSwift

/// Generic ViewController for StudiumEvent Lists. is Searchable.
class StudiumEventListViewController<T: StudiumEvent>: SwiftUIViewController<StudiumEventListView<T>>, UISearchResultsUpdating {
    
    private var searchController = UISearchController(searchResultsController: nil)
    private var viewModel: StudiumEventListViewModel<T>
    
    // MARK: - Lifecycle
    
    /// Initializer
    /// - Parameters:
    ///   - tabItemConfig: Configuration to properly display the view in the tab bar
    ///   - viewModel: ViewModel to describe the events
    init(tabItemConfig: TabItemConfig? = nil,
         viewModel: StudiumEventListViewModel<T>) {
        self.viewModel = viewModel
        super.init()
        if let tabItemConfig {
            self.setTabBarItem(tabItemConfig)
        }
    }
    
    override func loadView() {
        super.loadView()
        self.setupSwiftUI(withView: StudiumEventListView(viewModel: self.viewModel))

        self.setupSearchController()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = StudiumColor.background.uiColor
        
        self.addToolBarButtons(
            left: nil,
            right: UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(self.addButtonPressed)
            )
        )
        
        self.title = "\(T.displayName)s"
    }
    
    // MARK: - Internal Functions
    
    /// Called when the "+" button is tapped
    @objc func addButtonPressed() {
        self.viewModel.isShowingAddForm = true
    }
    
    /// Called when text in search bar is updated
    /// - Parameter searchController: The search controller that was updated
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.trimmed() {
            self.viewModel.searchFor(searchText)
        }
    }
    
    // MARK: - Private Helper Functions
    
    /// Sets up the search bar for the list
    private func setupSearchController() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false

        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    /// Configures the tab bar item view
    /// - Parameter tabItemConfig: The configuration for which to configure the view
    private func setTabBarItem(_ tabItemConfig: TabItemConfig) {
        self.tabBarItem = UITabBarItem(title: tabItemConfig.title,
                                       image: tabItemConfig.images.unselected,
                                       tag: tabItemConfig.orderNumber)
        self.tabBarItem.selectedImage = tabItemConfig.images.selected
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
