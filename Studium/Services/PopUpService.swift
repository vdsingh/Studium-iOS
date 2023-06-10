//
//  PopUpService.swift
//  Studium
//
//  Created by Vikram Singh on 6/9/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
import SwiftEntryKit
import VikUtilityKit

enum PopUpType {
    case success
    case failure
    
    var color: EKColor {
        switch self {
        case .success:
            return EKColor(StudiumColor.success.uiColor)
        case .failure:
            return EKColor(StudiumColor.failure.uiColor)
        }
    }
}

class PopUpService {
    
    static let shared = PopUpService()
    
    private init() { }
    
    func presentToast(title: String, description: String, image: StudiumIcon, popUpType: PopUpType) {
        var attributes: EKAttributes = .topFloat
        
        attributes.entryBackground = EKAttributes.BackgroundStyle.color(color: popUpType.color)
        
        let titleLabel = EKProperty.LabelContent(text: title, style: EKProperty.LabelStyle(font: .systemFont(ofSize: 18, weight: .semibold), color: EKColor(.white)))
        let descriptionLabel = EKProperty.LabelContent(text: description, style: EKProperty.LabelStyle(font: .systemFont(ofSize: 16, weight: .regular), color: EKColor(.white)))
        let image = EKProperty.ImageContent(image: image.image, size: CGSize(width: 32, height: 32), tint: popUpType.color, contentMode: .scaleAspectFill)
        let simpleMessage = EKSimpleMessage(image: image, title: titleLabel, description: descriptionLabel)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let entry = EKNotificationMessageView(with: notificationMessage)
        
        SwiftEntryKit.display(entry: entry, using: attributes)
    }
}
