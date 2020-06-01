//
//  Event.swift
//  Studium
//
//  Created by Vikram Singh on 5/26/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation


protocol StudiumEvent {
    var name: String { get }
    var startTime: Date { get }
}
