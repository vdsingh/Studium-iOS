//
//  Searchable.swift
//  Studium
//
//  Created by Vikram Singh on 8/17/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

protocol Searchable {
    func eventIsVisible(fromSearch searchText: String) -> Bool
}
