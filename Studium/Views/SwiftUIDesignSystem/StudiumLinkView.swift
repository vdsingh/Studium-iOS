//
//  StudiumLinkView.swift
//  Studium
//
//  Created by Vikram Singh on 7/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI
import VikUtilityKit

struct StudiumLinkView: View {
    
    var linkConfig: LinkConfig
    
    var body: some View {
        HStack(alignment: .top) {
            SmallIcon(image: SystemIcon.link.createImage())
            VStack(alignment: .leading) {
                
                Link(destination: URL(string: "https://www.google.com")!) {
                    Text(self.linkConfig.label)
                        .multilineTextAlignment(.leading)
                }
                .foregroundStyle(StudiumColor.link.color)
            }
        }
    }
    
    init(_ linkConfig: LinkConfig) {
        self.linkConfig = linkConfig
    }
}
