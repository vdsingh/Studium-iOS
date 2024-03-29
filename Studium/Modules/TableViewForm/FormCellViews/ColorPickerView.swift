//
//  ColorPickerCellV2.swift
//
//
//  Created by Vikram Singh on 8/6/23.
//

import Foundation
import SwiftUI

struct ColorButton: View {
    let color: UIColor
    private let strokeColor: Color = StudiumColor.primaryLabel.color
    @Binding var selectedColor: UIColor?
    
    var body: some View {
        Button {
            self.selectedColor = self.color
        } label: {
            Circle()
                .strokeBorder(self.selectedColor == self.color ? self.strokeColor : .clear, lineWidth: Increment.one / 2)
                .background(Circle().fill(self.color.color))
        }
        .frame(height: Increment.eight)
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct ColorPickerView: View {
    
    @Binding var selectedColor: UIColor?
    let colors: [UIColor]
    
    var groupedColors: [[UIColor]] {
        var res: [[UIColor]] = [[]]
        var index = 0
        for color in self.colors {
            res[index].append(color)
            if res[index].count >= 5 {
                res.append([])
                index += 1
            }
        }
        
        return res
    }
    
    var body: some View {
        VStack(spacing: Increment.three) {
            ForEach(self.groupedColors, id: \.self) { uiColorGroup in
                HStack {
                    Spacer()
                    ForEach(uiColorGroup, id: \.self) { uiColor in
                        ColorButton(
                            color: uiColor,
                            selectedColor: self.$selectedColor
                        )

                        Spacer()
                    }
                }
            }
        }
    }
}

class ColorPickerCellV2: UITableViewCell {
    static let id = "ColorPickerCellV2"
    private weak var controller: UIHostingController<ColorPickerView>?
    @State var selectedColor: UIColor?
    
    func host(
        parent: UIViewController,
        colors: [UIColor]
    ) {
        let view = ColorPickerView(
            selectedColor: self.$selectedColor,
            colors: colors
        )
        if let controller = self.controller {
            controller.rootView = view
            controller.view.layoutIfNeeded()
        } else {
            let swiftUICellViewController = UIHostingController(rootView: view)
            self.controller = swiftUICellViewController
            swiftUICellViewController.view.backgroundColor = ColorManager.cellBackgroundColor
            parent.addChild(swiftUICellViewController)
            self.contentView.addSubview(swiftUICellViewController.view)
            swiftUICellViewController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.contentView.leadingAnchor.constraint(equalTo: swiftUICellViewController.view.leadingAnchor),
                self.contentView.trailingAnchor.constraint(equalTo: swiftUICellViewController.view.trailingAnchor),
                self.contentView.topAnchor.constraint(equalTo: swiftUICellViewController.view.topAnchor),
                self.contentView.bottomAnchor.constraint(equalTo: swiftUICellViewController.view.bottomAnchor)
            ])

            swiftUICellViewController.didMove(toParent: parent)
            swiftUICellViewController.view.layoutIfNeeded()
        }
    }
}

struct ColorPickerPreview: PreviewProvider {
    
    @State static var colors = StudiumEventColor.allCasesUIColors
    @State static var selectedColor: UIColor? = StudiumEventColor.allCasesUIColors.first!
    static var previews: some View {
        ColorPickerView(selectedColor: self.$selectedColor, colors: self.colors)
            .background(StudiumColor.background.color)
    }
}
