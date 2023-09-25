//
//  IconSelectorView.swift
//  Studium
//
//  Created by Vikram Singh on 9/23/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

extension UIColor {
    var color: Color {
        Color(uiColor: self)
    }
}

import Foundation
import SwiftUI

struct IconButton: View {
//    @Environment( var dismiss
    let icon: StudiumIcon
    @Binding var selectedIcon: StudiumIcon
    let dismissSheet: () -> Void
    
    let iconColor = StudiumColor.primaryLabelColor(forBackgroundColor: StudiumColor.background.color)
    
    var body: some View {
        Button(action: {
            self.selectedIcon = self.icon
            self.dismissSheet()
        }) {
            Image(uiImage: self.icon.uiImage)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(self.iconColor)
                .scaledToFit()
                .frame(width: Increment.seven, height: Increment.seven)
//                .border(self.selectedIcon == icon ? .green : .clear)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    let searchBarPlaceholder: String
    
    var body: some View {
        HStack {
            MiniIcon(image: SystemIcon.magnifyingGlass.uiImage)
            
            TextField("", text: self.$searchText)
                .placeholder(when: self.searchText.isEmpty, placeholder: {
                    Text(self.searchBarPlaceholder)
                        .foregroundColor(StudiumFont.placeholder.color)
                })
                .frame(height: Increment.five)
        }
    }
}

struct IconSelectorView: View {
    @Environment(\.dismiss) var dismiss
    
    /// The icon that is currently selected
    @Binding var selectedIcon: StudiumIcon
    
    /// Text that is currently searched for
    @State var searchText: String = ""
    
    /// The icons that are currently visible (changes with new search)
    @State var visibleIcons: [StudiumIconGroup] = StudiumIconGroup.allCases
    
    var body: some View {
        List {
            SearchBar(searchText: self.$searchText, searchBarPlaceholder: "Search for an Icon")
            ForEach(self.visibleIcons, id: \.self) { group in
                if !group.iconsForSearch(search: self.searchText).isEmpty {
                    Section(header: Text(group.label)) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: Increment.seven))],
                                  spacing: Increment.two) {
                            ForEach(group.iconsForSearch(search: self.searchText), id: \.self) { icon in
                                IconButton(icon: icon, selectedIcon: self.$selectedIcon) {
                                    self.dismiss()
                                }
                            }
                        }
                                  .padding(.vertical)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Select an Icon")
                        .foregroundStyle(StudiumFormNavigationConstants.navBarForegroundColor)
                        .font(StudiumFont.bodySemibold.font)
                }
            }
        }
    }
}

struct IconSelectorViewPreview: PreviewProvider {
    
    @State static var selectedIcon: StudiumIcon = .atom
    static var previews: some View {
        IconSelectorView(selectedIcon: self.$selectedIcon)
    }
}
