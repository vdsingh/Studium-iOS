//
//  StudiumLinkView.swift
//  Studium
//
//  Created by Vikram Singh on 7/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI


struct StudiumLinkView: View {
    
    var linkConfig: LinkConfig
    
    var body: some View {
        HStack(alignment: .top) {
            SmallIcon(image: SystemIcon.link)
            VStack(alignment: .leading) {

                if let url = URL(string: self.linkConfig.link) {
                    //TODO: Fix force unwrap
                    Link(destination: url) {
                        Text(self.linkConfig.label)
                            .multilineTextAlignment(.leading)
                    }
                    .foregroundStyle(StudiumColor.link.color)
                }
            }
        }
    }
    
    init(_ linkConfig: LinkConfig) {
        self.linkConfig = linkConfig
    }
}
