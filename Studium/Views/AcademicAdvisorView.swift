//
//  AcademicAdvisorView.swift
//  Studium
//
//  Created by Vikram Singh on 7/20/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

class AcademicAdvisorViewModel: ObservableObject {
    @Published var isHidden: Bool = false
    
    let image: UIImage?
    let title: String
    let subtitle: String?
    var textAlignment: TextAlignment = .center
    let buttonText: String
    let buttonAction: () -> Void
    
    init(image: UIImage?, title: String, subtitle: String?, buttonText: String, buttonAction: @escaping () -> Void) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.buttonText = buttonText
        self.buttonAction = buttonAction
    }
    
    func setTextAlignment(_ alignment: TextAlignment) {
        self.textAlignment = alignment
    }
}

struct AcademicAdvisorView: View {
    
    @ObservedObject var viewModel: AcademicAdvisorViewModel
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                if let image = self.viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 350, height: 275)
                }
                
                Text(self.viewModel.title)
                    .font(StudiumFont.title.font)
                    .foregroundStyle(Color(StudiumFont.title.color))
                
                if let subtitle = self.viewModel.subtitle {
                    Text(subtitle)
                        .font(StudiumFont.subTitle.font)
                        .foregroundStyle(Color(StudiumFont.placeholder.color))
                }
                
                Button {
                    self.viewModel.buttonAction()
                } label: {
                    Text(self.viewModel.buttonText)
                        .font(StudiumFont.subTitle.font)
                        .frame(width: 300, height: 50)
                }
                .background(Color(uiColor: StudiumColor.secondaryAccent.uiColor))
                .foregroundColor(Color(uiColor: StudiumColor.primaryLabel.uiColor))
                .clipShape(.rect(cornerRadius: 10))
            }
            .scaledToFill()
            .padding(20)
        }
        .background(Color(uiColor: StudiumColor.secondaryBackground.uiColor))
        .clipShape(.rect(cornerRadius: 20))
        .opacity(self.viewModel.isHidden ? 0 : 1)
        
        Spacer()
    }
}
