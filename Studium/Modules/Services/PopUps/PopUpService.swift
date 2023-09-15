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

import SwiftUI

enum ToastPopUpType {
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
    
    var image: UIImage {
        switch self {
        case .success:
            return .strokedCheckmark
        case .failure:
            return .remove
        }
    }
}

class PopUpService {
    
    static let shared = PopUpService()
    
    private init() { }
    
    
    /// Presents a message at the top of the screen to display info to the user
    /// - Parameters:
    ///   - title: Title text displayed
    ///   - description: Description text displayed
    ///   - popUpType: The type of pop up
    func presentToast(title: String, description: String, popUpType: ToastPopUpType) {
        DispatchQueue.main.async {
            var attributes: EKAttributes = .topFloat
            
            attributes.entryBackground = EKAttributes.BackgroundStyle.color(color: popUpType.color)
            
            let titleLabel = EKProperty.LabelContent(text: title, style: EKProperty.LabelStyle(font: .systemFont(ofSize: 18, weight: .semibold), color: EKColor(.white)))
            let descriptionLabel = EKProperty.LabelContent(text: description, style: EKProperty.LabelStyle(font: .systemFont(ofSize: 16, weight: .regular), color: EKColor(.white)))
            let image = EKProperty.ImageContent(image: popUpType.image, size: CGSize(width: 32, height: 32), tint: popUpType.color, contentMode: .scaleAspectFill)
            let simpleMessage = EKSimpleMessage(image: image, title: titleLabel, description: descriptionLabel)
            let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
            let entry = EKNotificationMessageView(with: notificationMessage)
            
            SwiftEntryKit.display(entry: entry, using: attributes)
        }
    }
    
    func presentGenericError() {
        self.presentToast(title: "An Error Occurred", description: "Please try again later.", popUpType: .failure)
    }
    
    func presentDeleteAlert(deleteWasPressed: @escaping () -> Void) {
        DispatchQueue.main.async {
            var attributes: EKAttributes = .centerFloat
            attributes = .centerFloat
            attributes.displayMode = .dark
            attributes.windowLevel = .alerts
            attributes.displayDuration = .infinity
            attributes.hapticFeedbackType = .success
            attributes.screenInteraction = .absorbTouches
            attributes.entryInteraction = .absorbTouches
            attributes.scroll = .disabled
            attributes.screenBackground = .color(color: EKColor(.black.withAlphaComponent(0.8)))
            attributes.entryBackground = .color(color: EKColor(StudiumColor.secondaryBackground.uiColor))
            attributes.entranceAnimation = .init(
                scale: .init(
                    from: 0.9,
                    to: 1,
                    duration: 0.4,
                    spring: .init(damping: 1, initialVelocity: 0)
                ),
                fade: .init(
                    from: 0,
                    to: 1,
                    duration: 0.3
                )
            )
            attributes.exitAnimation = .init(
                fade: .init(
                    from: 1,
                    to: 0,
                    duration: 0.2
                )
            )
            attributes.shadow = .active(
                with: .init(
                    color: .black,
                    opacity: 0.3,
                    radius: 5
                )
            )
            attributes.positionConstraints.maxSize = .init(
                width: .constant(value: UIScreen.main.bounds.minEdge),
                height: .intrinsic
            )
            
            let title = EKProperty.LabelContent(
                text: "Are you sure?",
                style: .init(
                    font: StudiumFont.subTitle.uiFont,
                    color: EKColor(StudiumFont.subTitle.uiColor),
                    alignment: .center,
                    displayMode: .dark
                )
            )
            let text = "This action cannot be undone."
            let description = EKProperty.LabelContent(
                text: text,
                style: .init(
                    font: StudiumFont.body.uiFont,
                    color: EKColor(StudiumFont.body.uiColor),
                    alignment: .center,
                    displayMode: .dark
                )
            )
            let image = EKProperty.ImageContent(
                image: SystemIcon.trashCan.createImage(),
                displayMode: .dark,
                size: CGSize(width: 25, height: 25),
                tint: EKColor(StudiumColor.failure.uiColor),
                contentMode: .scaleAspectFit
            )
            
            let simpleMessage = EKSimpleMessage(
                image: image,
                title: title,
                description: description
            )
            let buttonFont = StudiumFont.body.uiFont

            let laterButtonLabelStyle = EKProperty.LabelStyle(
                font: buttonFont,
                color: EKColor(StudiumFont.body.uiColor),
                displayMode: .dark
            )
            let laterButtonLabel = EKProperty.LabelContent(
                text: "Delete",
                style: laterButtonLabelStyle
            )
            let laterButton = EKProperty.ButtonContent(
                label: laterButtonLabel,
                backgroundColor: EKColor(StudiumColor.failure.uiColor),
                highlightedBackgroundColor: .white,
                displayMode: .dark
            ) {
                deleteWasPressed()
                SwiftEntryKit.dismiss()
            }
            
            let okButtonLabelStyle = EKProperty.LabelStyle(
                font: buttonFont,
                color: EKColor(StudiumFont.body.uiColor),
                displayMode: .dark
            )
            let okButtonLabel = EKProperty.LabelContent(
                text: "Cancel",
                style: okButtonLabelStyle
            )
            let okButton = EKProperty.ButtonContent(
                label: okButtonLabel,
                backgroundColor: .clear,
                highlightedBackgroundColor: .black,
                displayMode: EKAttributes.DisplayMode.dark
            ) {
                    SwiftEntryKit.dismiss()
            }
            // Generate the content
            let buttonsBarContent = EKProperty.ButtonBarContent(
                with: okButton, laterButton,
                separatorColor: EKColor(StudiumFont.placeholder.uiColor),
                displayMode: EKAttributes.DisplayMode.dark,
                expandAnimatedly: true
            )
            let alertMessage = EKAlertMessage(
                simpleMessage: simpleMessage,
                buttonBarContent: buttonsBarContent
            )
            let contentView = EKAlertMessageView(with: alertMessage)
            
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
    
    // Sign up form
    func showForm(
        formType: FormPopUpType,
        dismissCompletion: @escaping ([String]) -> Void
    ) {
        let textFieldsContent = formType.textFieldsContent()
        let contentView = EKFormMessageView(
            with: formType.titleContent,
            textFieldsContent: textFieldsContent,
            buttonContent: formType.buttonContent(dismissCompletion: {
                let textContents = textFieldsContent.map { $0.textContent }
                dismissCompletion(textContents)
            })
        )
        
        var attributes = formType.attributes
        attributes.lifecycleEvents.didAppear = {
            contentView.becomeFirstResponder(with: 0)
        }
        
        SwiftEntryKit.display(entry: contentView, using: attributes, presentInsideKeyWindow: true)
    }
}

extension CGRect {
    var minEdge: CGFloat {
        return min(width, height)
    }
}
