//
//  LogoSelectionShowingCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 6/4/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

/// Coordinators that control a flow in which a logo selection VC is used can use this protocol to gain the showLogoSelectionViewController showLogoSelectionViewController
protocol LogoSelectionShowingCoordinator: StudiumEventFormCoordinator {

    // TODO: Docstrings
    func showLogoSelectionViewController(updateDelegate: LogoSelectionHandler)
}

// TODO: Docstrings
extension LogoSelectionShowingCoordinator {

    // TODO: Docstrings
    func showLogoSelectionViewController(updateDelegate: LogoSelectionHandler) {
        let logoSelectionVC = LogoSelectorViewController.instantiate()
        logoSelectionVC.delegate = updateDelegate
        self.formNavigationController?.pushViewController(logoSelectionVC, animated: true)
    }
}
