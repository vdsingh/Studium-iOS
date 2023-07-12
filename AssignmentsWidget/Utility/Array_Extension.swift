//
//  Array_Extension.swift
//  Studium
//
//  Created by Vikram Singh on 6/25/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

// This extension allows us to store Arrays in AppStorage
extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
