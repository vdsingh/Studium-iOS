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
    }
}
