//
//  DocumentPicker.swift
//  Studium
//
//  Created by Vikram Singh on 8/2/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    
    @Binding var fileContent: Data
    
    let documentWasSelected: (URL) -> Void
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(fileContent: self.$fileContent, documentWasSelected: self.documentWasSelected)
    }
    
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<DocumentPicker>
    ) -> UIDocumentPickerViewController {
        //The file types like ".pkcs12" are listed here:
        //https://developer.apple.com/documentation/uniformtypeidentifiers/system_declared_uniform_type_identifiers?changes=latest_minor
        let controller: UIDocumentPickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        print("update")
    }
}

class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    @Binding var fileContent: Data
    let documentWasSelected: (URL) -> Void
    
    init(
        fileContent: Binding<Data>,
        documentWasSelected: @escaping (URL) -> Void
    ) {
        _fileContent = fileContent
        self.documentWasSelected = documentWasSelected
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            return
        }
        
        self.documentWasSelected(url)
//        let fileURL = urls[0]
//        
//        let certData = try! Data(contentsOf: fileURL)
//        
//        print("Picked documents at urls: \(urls.map { $0.lastPathComponent })")
//        
//        if let documentsPathURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first {
//            let certURL = documentsPathURL.appendingPathComponent("certFile.pfx")
//            
//            try? certData.write(to: certURL)
//        }
        
    }
}
