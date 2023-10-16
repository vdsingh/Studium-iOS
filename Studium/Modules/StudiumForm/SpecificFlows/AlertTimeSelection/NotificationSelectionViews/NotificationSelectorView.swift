//
//  NotificationSelectorView.swift
//  Studium
//
//  Created by Vikram Singh on 9/23/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

/// Individual button to let user select a notification option
struct NotificationSelectorButton: View {
    let option: AlertOption
    @Binding var selectedOptions: Set<AlertOption>

    var isSelected: Bool {
        return self.selectedOptions.contains(self.option)
    }

    var body: some View {
        HStack {
            Button {
                if self.isSelected {
                    for option in self.selectedOptions {
                        if option.rawValue == self.option.rawValue {
                            self.selectedOptions.remove(option)
                        }
                    }
//                    self.selectedOptions.remove(<#T##member: AlertOption##AlertOption#>)
//                    self.selectedOptions.removeAll(where: { $0.rawValue == self.option.rawValue })
                } else {
                    self.selectedOptions.insert(self.option)
                }
            } label: {
                StudiumText("\(self.option.userString)")
            }

            Spacer()
            if self.isSelected {
                MiniIcon(image: StudiumIcon.checkmark.uiImage)
            }
        }
    }
}

// Allows us to use Arrays with @AppStorage tags
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

/// The notification selection panel
struct NotificationSelectorView: View {
    @Binding var selectedOptions: Set<AlertOption>
    @State var isDefault = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
//        let navBarAppearance = UINavigationBarAppearance().backButtonAppearance.normal = .
//        navBarAppearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]

        return Form {
            Section(header: Text("Notification Options")) {
                ForEach(AlertOption.allCases, id: \.self) { alertOption in
                    NotificationSelectorButton(option: alertOption,
                                               selectedOptions: self.$selectedOptions)
                }
            }

            Section(header: Text("Default Preferences")) {
                HStack {
                    Toggle(isOn: self.$isDefault) {
                        Text("Use these by default")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    .foregroundStyle(StudiumColor.primaryLabel.color)
                    .onChange(of: self.selectedOptions) { _ in
                        if self.isDefault {
                            UserDefaultsService.defaultNotificationPreferences = self.selectedOptions
                        }
                    }
                    .onChange(of: self.isDefault) { _ in
                        if self.isDefault {
                            UserDefaultsService.defaultNotificationPreferences = self.selectedOptions
                        }
                    }
                }
            }
        }
//        .accentColor(.green)
//        .navigationBarBackButtonHidden()
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) { // Override back button with custom
//                Button {
//                    self.dismiss()
//                } label: {
//                    HStack {
//                        TinyIcon(color: .white, image: SystemIcon.chevronLeft.uiImage)
//                        StudiumText("Back")
//                            .foregroundStyle(.white)
//                    }
//                }
//            }
//        }
    }
}

extension UserDefaultsKeys {
    static let defaultNotificationPrefs = "defaultNotificationPrefs"
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                configuration.label
            }
        })
    }
}

struct NotificationSelectorPreview: PreviewProvider {

    @State static var alertOptions = Set<AlertOption>()
    static var previews: some View {
        NotificationSelectorView(selectedOptions: self.$alertOptions)
    }
}
