//
//  FormViewModel.swift
//  Studium
//
//  Created by Vikram Singh on 9/30/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

protocol FormViewModel {
    var titleText: String { get }
    var positiveCTAButtonText: String { get }
//    var titleDisplayMode: NavigationBarItem.TitleDisplayMode { get }

    func positiveCTATapped() -> Bool
}
