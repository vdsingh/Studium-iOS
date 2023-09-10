//
//  FormPopUpType.swift
//  Studium
//
//  Created by Vikram Singh on 6/10/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftEntryKit
import UIKit
import VikUtilityKit

enum FormPopUpType {
    case reportAProblem
    
    var attributes: EKAttributes {
        switch self {
        case .reportAProblem:
            var attributes = EKAttributes()
            attributes = .bottomFloat
            attributes.displayMode = .inferred
            attributes.windowLevel = .normal
            attributes.position = .center
            attributes.displayDuration = .infinity
            attributes.entranceAnimation = .init(
                translate: .init(
                    duration: 0.65,
                    spring: .init(damping: 1, initialVelocity: 0)
                )
            )
            attributes.exitAnimation = .init(
                translate: .init(
                    duration: 0.65,
                    spring: .init(damping: 1, initialVelocity: 0)
                )
            )
            attributes.popBehavior = .animated(
                animation: .init(
                    translate: .init(
                        duration: 0.65,
                        spring: .init(damping: 1, initialVelocity: 0)
                    )
                )
            )
            attributes.entryInteraction = .absorbTouches
            attributes.screenInteraction = .dismiss
            attributes.entryBackground = .color(color: EKColor(StudiumColor.secondaryBackground.uiColor))
            attributes.shadow = .active(
                with: .init(
                    color: .black,
                    opacity: 0.3,
                    radius: 3
                )
            )
            attributes.screenBackground = .color(color: EKColor(StudiumColor.background.uiColor.withAlphaComponent(0.5)))
            attributes.scroll = .edgeCrossingDisabled(swipeable: true)
            attributes.statusBar = .light
            attributes.positionConstraints.keyboardRelation = .bind(
                offset: .init(
                    bottom: 0,
                    screenEdgeResistance: 0
                )
            )
            attributes.positionConstraints.maxSize = .init(
                width: .constant(value: UIScreen.main.bounds.width),
                height: .intrinsic
            )
            return attributes
        }
    }
    
    var titleContent: EKProperty.LabelContent {
        switch self {
        case .reportAProblem:
            let titleStyle = EKProperty.LabelStyle(
                font: StudiumFont.subTitle.uiFont,
                color: EKColor(StudiumColor.primaryLabel.uiColor),
                displayMode: EKAttributes.DisplayMode.inferred
            )
            
            return EKProperty.LabelContent(
                text: "Report a Problem",
                style: titleStyle
            )
        }
    }
    
    func buttonContent(dismissCompletion: @escaping () -> Void) -> EKProperty.ButtonContent {
        switch self {
        case .reportAProblem:
            return EKProperty.ButtonContent(
                label: .init(
                    text: "Send",
                    style: .init(font: StudiumFont.bodySemibold.uiFont, color: EKColor(StudiumFont.subTitle.uiColor))
                ),
                backgroundColor: EKColor(StudiumColor.secondaryAccent.uiColor),
                highlightedBackgroundColor: EKColor(StudiumColor.secondaryAccent.darken(by: 10)),
                displayMode: .inferred
            ) {
                SwiftEntryKit.dismiss {
                    dismissCompletion()
                }
            }
        }
    }
    
    func textFieldsContent() -> [EKProperty.TextFieldContent] {
        switch self {
        case .reportAProblem:
            return [
                EKProperty.TextFieldContent(
                    keyboardType: .emailAddress,
                    placeholder: .init(
                        text: "Contact Email (Optional)",
                        style: .init(
                            font: StudiumFont.placeholder.uiFont,
                            color: EKColor(StudiumFont.placeholder.uiColor)
                        )
                    ),
                    tintColor: EKColor(StudiumColor.primaryAccent.uiColor),
                    textStyle: .init(font: StudiumFont.body.uiFont, color: EKColor(StudiumFont.body.uiColor)),
                    leadingImage: SystemIcon.envelope.createImage(withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .default)).withRenderingMode(.alwaysTemplate),
                    bottomBorderColor: EKColor(StudiumColor.secondaryLabel.uiColor)
                ),
                
                EKProperty.TextFieldContent(
                    placeholder: .init(
                        text: "Problem Details",
                        style: .init(
                            font: StudiumFont.placeholder.uiFont,
                            color: EKColor(StudiumColor.placeholderLabel.uiColor)
                        )
                    ),
                    tintColor: EKColor(StudiumColor.primaryAccent.uiColor),
                    textStyle: .init(font: StudiumFont.body.uiFont, color: EKColor(StudiumFont.body.uiColor)),
                    leadingImage: SystemIcon.exclamationmarkCircle.createImage(withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .default)).withRenderingMode(.alwaysTemplate)
                )
            ]
        }
    }
}
