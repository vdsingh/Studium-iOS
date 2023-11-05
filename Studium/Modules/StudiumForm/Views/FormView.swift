//
//  FormView.swift
//  Studium
//
//  Created by Vikram Singh on 9/30/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct FormHiddenBackground: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content.onAppear {
                UITableView.appearance().backgroundColor = .clear
            }
            .onDisappear {
                UITableView.appearance().backgroundColor = .systemGroupedBackground
            }
        }
    }
}

struct FormContainer<Content: View>: View {

    @Environment(\.dismiss) var dismiss

    let formViewModel: FormViewModel
    let content: Content

    init(formViewModel: FormViewModel, @ViewBuilder content: () -> Content) {
        self.formViewModel = formViewModel
        self.content = content()
    }
//    
//    var text: Text {
//        Text("HELLO").foregroundColor(.green)
//            
//    }

    var body: some View {
        NavigationView {
            self.content
                .modifier(FormHiddenBackground())
                .background(StudiumColor.secondaryBackground.color)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(self.formViewModel.titleText)
                            .foregroundColor(StudiumFormNavigationConstants.navBarForegroundColor)
                            .font(StudiumFont.bodySemibold.font)
                    }

                    ToolbarItemGroup(placement: .topBarLeading) {
                        VStack {
                            Button("Cancel") {
                                self.dismiss()
                            }
                        }
                    }

                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button(self.formViewModel.positiveCTAButtonText) {
                            if self.formViewModel.positiveCTATapped() {
                                self.dismiss()
                            }
                        }
                    }
                }
        }.accentColor(StudiumFormNavigationConstants.navBarForegroundColor)
    }
}
