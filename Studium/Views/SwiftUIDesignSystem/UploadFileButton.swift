//
//  UploadFileButton.swift
//  Studium
//
//  Created by Vikram Singh on 7/28/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI
import RealmSwift
import UniformTypeIdentifiers
import PDFKit
import VikUtilityKit

struct PDFViewer: View {
    let pdfURL: URL
    var body: some View {
        PDFKitView(pdfURL: self.pdfURL)
    }
}

struct PDFKitView: UIViewRepresentable {
    let pdfURL: URL
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        if let pdfDocument = PDFDocument(url: self.pdfURL) {
            pdfView.document = pdfDocument
        }
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        
        // Update the view if needed (if your URL changes dynamically).
        if let pdfDocument = PDFDocument(url: self.pdfURL) {
            uiView.document = pdfDocument
        }
    }
}

struct UploadFileButton<Storer>: View where Storer: FileStorer {
    @ObservedRealmObject var fileStorer: Storer
    @Binding var isImporting: Bool
    
    let urlWasPressed: (URL) -> Void
    
//    let storageService = FirebaseStorageService.shared
    let studiumEventService = StudiumEventService.shared
    
    @State var fileContent: Data = Data()

    var body: some View {
        if let url = self.fileStorer.attachedFileURL {
            HStack {
                Button {
                    self.urlWasPressed(url)
                    Log.d("pdf URL was pressed: \(url)")
                } label:  {
                    Text(url.lastPathComponent)
                }
                
                // Button to remove the file
                Button {
                    self.studiumEventService.attachFile(to: self.fileStorer, fileURL: nil)
                } label: {
                    MiniIcon(color: StudiumColor.failure.color, image: SystemIcon.minusCircle.createImage())
                }
            }

        } else {
            Button {
                self.isImporting = true
            } label:  {
                StudiumText("Attach a File")
            }
            .buttonStyle(StudiumButtonStyle(disabled: false))
            .sheet(isPresented: self.$isImporting) {
                DocumentPicker(
                    fileContent: self.$fileContent,
                    documentWasSelected: { url in
                        self.studiumEventService.attachFile(to: self.fileStorer, fileURL: url)
                    }
                )
            }
//            .fileImporter(
//                isPresented: self.$isImporting,
//                allowedContentTypes: [.pdf, .image],
//                allowsMultipleSelection: false,
//                onCompletion: { result in
//                    
//                    switch result {
//                    case .success(let file):
//                        guard let file = file.first else {
//                            //TODO: Error handle
//                            return
//                        }
//                        let gotAccess = file.startAccessingSecurityScopedResource()
//                        if !gotAccess { return }
//                        // Handle the selected PDF file URL
//                        // For example, you can save it to your app's storage or process it further
//                        Log.d("Selected PDF URL: \(file)")
//                        self.studiumEventService.attachFile(to: fileStorer, fileURL: file)
//                        
//                    case .failure(let error):
//                        // Handle the error, if needed
//                        Log.e(error, additionalDetails: "Error picking the PDF document")
//                    }
//                }
//            )
        }
    }
}
