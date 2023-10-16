//
//  LogoSelectorCollectionViewController.swift
//  Studium
//
//  Created by Vikram Singh on 8/12/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import SwiftUI

// TODO: Docstrings
protocol LogoSelectionHandler {

    func logoWasUpdated(icon: StudiumIcon)
}

// TODO: Docstrings
class LogoSelectorViewController: UIViewController, Storyboarded {

    // TODO: Docstrings
    var delegate: LogoSelectionHandler?

    var iconWasSelected: ((StudiumIcon) -> Void)?

    // TODO: Docstrings
    var color: UIColor = StudiumColor.background.uiColor

    // TODO: Docstrings
    @IBOutlet weak var collectionView: UICollectionView!

    // TODO: Docstrings
    var iconGroups: [StudiumIconGroup] = StudiumIconGroup.allCases

    var filteredIcons: [StudiumIcon] = StudiumIcon.allCases

    var searchController: UISearchController!

    override func loadView() {
        super.loadView()
        self.collectionView.register(LogoCollectionViewCell.self, forCellWithReuseIdentifier: LogoCollectionViewCell.id)
        self.collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.id)

        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = StudiumColor.background.uiColor
        self.collectionView.backgroundColor = StudiumColor.background.uiColor
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
}

// TODO: Docstrings
extension LogoSelectorViewController: UICollectionViewDelegate {

    // TODO: Docstrings
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let icon = self.searchController.isActive ? self.filteredIcons[indexPath.row] : self.iconGroups[indexPath.section].icons[indexPath.row]
        self.delegate?.logoWasUpdated(icon: icon)
        if let iconWasSelected = self.iconWasSelected {
            iconWasSelected(icon)
        }

        self.navigationController?.popViewController(animated: true)
    }
}

// TODO: Docstrings
extension LogoSelectorViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        // If searching, don't group icons
        if self.searchController.isActive {
            return 1
        }

        return self.iconGroups.count
    }

    // TODO: Docstrings
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.searchController.isActive {
            // Return the count of filtered icons
            return self.filteredIcons.count
        } else {
            // Return the count of icons in the section
            return self.iconGroups[section].icons.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if self.searchController.isActive {
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.id, for: indexPath) as? SectionHeader {
                sectionHeader.setup(headerText: "")
                return sectionHeader
            }
        } else {
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.id, for: indexPath) as? SectionHeader {
                let iconGroupLabel = self.iconGroups[indexPath.section].label
                sectionHeader.setup(headerText: iconGroupLabel)
                return sectionHeader
            }
        }

        return UICollectionReusableView()
    }

    // TODO: Docstrings
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.searchController.isActive, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LogoCollectionViewCell.id, for: indexPath) as? LogoCollectionViewCell {
                cell.setup()
                let image = self.filteredIcons[indexPath.row].uiImage
                cell.setImage(image: image, tintColor: StudiumColor.primaryAccent.uiColor)
                return cell
        } else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LogoCollectionViewCell.id, for: indexPath) as? LogoCollectionViewCell {
            cell.setup()
            let image = self.iconGroups[indexPath.section].icons[indexPath.row].uiImage
            cell.setImage(image: image, tintColor: StudiumColor.primaryAccent.uiColor)
            return cell
        }

        // FIXME: Log error
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }

    func filterIcons(for searchText: String) {
        StudiumIcon.icons(fromSearchText: searchText, qos: .userInitiated) { icons in
            DispatchQueue.main.async {
                self.filteredIcons = icons
                self.collectionView.reloadData()
            }
        }
    }
}

// TODO: Docstrings
extension LogoSelectorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Increment.seven, height: Increment.seven)
    }
}

extension LogoSelectorViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            self.filterIcons(for: searchText)
        }
    }
}

// struct LogoSelectorViewPreview: PreviewProvider {
//    static let logoSelectorViewController = LogoSelectorViewController.instantiate()
//    static var previews: some View {
//        logoSelectorViewController.view
//    }
// }
