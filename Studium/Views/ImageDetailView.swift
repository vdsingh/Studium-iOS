//
//  ImageDetailView.swift
//  Studium
//
//  Created by Vikram Singh on 7/12/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

class ImageDetailViewModel: ObservableObject {
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

struct ImageDetailView: View {
    
    @ObservedObject var viewModel: ImageDetailViewModel
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: Increment.two) {
                if let image = self.viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(image.size, contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width * 3/4)
//                        .

                }
                
                VStack(spacing: Increment.one) {
                    Text(self.viewModel.title)
                        .font(StudiumFont.subTitle.font)
                        .foregroundStyle(StudiumFont.subTitle.color)
                    
                    if let subtitle = self.viewModel.subtitle {
                        Text(subtitle)
                            .font(StudiumFont.body.font)
                            .foregroundStyle(StudiumFont.placeholder.color)
                    }
                }
                
                Button {
                    self.viewModel.buttonAction()
                } label: {
                    Text(self.viewModel.buttonText)
                        .font(StudiumFont.bodySemibold.font)
                        .frame(width: 300, height: 50)
                }
                .background(Color(uiColor: StudiumColor.secondaryAccent.uiColor))
                .foregroundColor(Color(uiColor: StudiumColor.primaryLabel.uiColor))
                .clipShape(.rect(cornerRadius: 10))
                
            }
//            .scaledToFit()
            .padding(20)
        }
        .background(Color(uiColor: StudiumColor.secondaryBackground.uiColor))
        .clipShape(.rect(cornerRadius: 20))
        .opacity(self.viewModel.isHidden ? 0 : 1)
        
        Spacer()
    }
}
