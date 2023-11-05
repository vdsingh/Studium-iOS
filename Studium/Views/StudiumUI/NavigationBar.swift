//
//  NavigationBar.swift
//  Studium
//
//  Created by Vikram Singh on 10/7/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

// extension View {
//    func navigationBar(title: String,
//                       titleIsLarge: Bool,
//                       leading: AnyView?,
//                       trailing: AnyView?,
//                       underTitle: AnyView?)
//    -> some View {
//        self.modifier(CustomNavigationBar(title: title,
//                                          titleIsLarge: titleIsLarge,
//                                          leading: leading,
//                                          trailing: trailing,
//                                          underTitle: underTitle))
//    }
// }

struct NavigationBar: View {

    var title: String
    var titleIsLarge: Bool

    var leading: AnyView?
    var trailing: AnyView?

    var underTitle: AnyView?

    var body: some View {
        if self.titleIsLarge {
//            ToolbarItemGroup(placement: .topBarLeading) {
//            ToolbarItem(placement: .topBarLeading) {
//                VStack {
                    VStack {
                        Spacer()
                        HStack {
                            self.leading
                            Spacer()
                            self.trailing
                        }
                        Spacer()

                        VStack {
                            StudiumTitle(self.title)
                            self.underTitle
                        }
                    }
                    .padding(.horizontal, Increment.three)
                    .frame(maxHeight: 100)
//                }
//            }
        } else {
            VStack(alignment: .center) {
                VStack {
                    Spacer()
                    ZStack(alignment: .center) {
                        HStack(alignment: .bottom) {
                            self.leading
                            Spacer()
                            self.trailing
                        }

                        VStack(alignment: .leading) {
                            Text(self.title)
                                .font(StudiumFont.bodySemibold.font)
                            self.underTitle
                        }
                    }
                }
                .padding(.horizontal, Increment.three)
                .frame(maxHeight: 60)
            }
        }
    }
}
