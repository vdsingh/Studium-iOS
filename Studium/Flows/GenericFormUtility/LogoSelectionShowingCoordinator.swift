//
//  LogoSelectionShowingCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 6/4/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

//TODO: Docstrings
protocol LogoSelectionShowingCoordinator: StudiumEventFormCoordinator {
    func showLogoSelectionViewController(updateDelegate: LogoSelectionHandler)
}

//TODO: Docstrings
extension LogoSelectionShowingCoordinator {
    
    //TODO: Docstrings
    func showLogoSelectionViewController(updateDelegate: LogoSelectionHandler) {
        let logoSelectionVC = LogoSelectorViewController.instantiate()
        logoSelectionVC.delegate = updateDelegate
        self.formNavigationController?.pushViewController(logoSelectionVC, animated: true)
    }
}
