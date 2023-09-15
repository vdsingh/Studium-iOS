//
//  FileStorer.swift
//  Studium
//
//  Created by Vikram Singh on 8/1/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

// TODO: Docstrings
protocol FileStorer: Object, ObjectKeyIdentifiable {
    var attachedFileURLString: String? { get set }
}

extension FileStorer {
    func attachFileURL(_ fileURL: URL?) {
        self.attachedFileURLString = fileURL?.absoluteString
    }
    
    var attachedFileURL: URL? {
        if let urlString = self.attachedFileURLString {
            return URL(string: urlString)
        }
        
        return nil
    }
}
