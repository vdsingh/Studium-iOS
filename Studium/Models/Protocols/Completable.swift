//
//  Completable.swift
//  Studium
//
//  Created by Vikram Singh on 2/7/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

/// This protocol is used for any StudiumEvents that can be marked as "Complete" or "Incomplete"
protocol CompletableStudiumEvent: StudiumEvent {
    var complete: Bool { get set }
}
