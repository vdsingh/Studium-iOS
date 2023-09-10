//
//  ColorPickerCellV2.swift
//
//
//  Created by Vikram Singh on 8/6/23.
//

import Foundation
import SwiftUI

//extension UIColor {
//    
//    //TODO: Docstrings
//    convenience init(hex: String, alpha: CGFloat = 1.0) {
//        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//        var rgbValue: UInt32 = 10066329 //color #999999 if string has wrong format
//        
//        if (cString.hasPrefix("#")) {
//            cString.remove(at: cString.startIndex)
//        }
//        
//        if ((cString.count) == 6) {
//            Scanner(string: cString).scanHexInt32(&rgbValue)
//        }
//        
//        self.init(
//            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//            alpha: alpha
//        )
//    }
//}

struct ColorButton: View {
    let color: UIColor
    
    private let strokeColor: Color = Color(uiColor: ColorManager.primaryTextColor)
    @Binding var selectedColor: UIColor?
    
    let colorWasSelected: (UIColor) -> Void
    
    var body: some View {
        Button {
            self.colorWasSelected(self.color)
        } label: {
            Circle()
                .strokeBorder(self.selectedColor == self.color ? self.strokeColor : .clear, lineWidth: 5)
                .background(Circle().fill(Color(uiColor: self.color)))
        }
        .frame(height: 50)
    }
}

struct ColorPickerCellV2View: View {
    
    @State private var selectedColor: UIColor? = nil
    let colors: [UIColor]
    let colorWasSelected: (Color) -> Void
    
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
        VStack(spacing: 18) {
            ForEach(self.groupedColors, id: \.self) { uiColorGroup in
//            ForEach(StudiumEventColor.groupedColors, id: \.self) { group in
                HStack {
                    Spacer()
                    ForEach(uiColorGroup, id: \.self) { uiColor in
                        ColorButton(
                            color: uiColor,
                            selectedColor: self.$selectedColor,
                            colorWasSelected: { color in
                                self.selectedColor = color
                                self.colorWasSelected(Color(uiColor: color))
                            }
                        )

                        Spacer()
                    }
                }
            }
        }
        .frame(height: 200)
    }
}

class ColorPickerCellV2: UITableViewCell {
    static let id = "ColorPickerCellV2"
    
    private weak var controller: UIHostingController<ColorPickerCellV2View>?
    private let colorWasSelected: (Color) -> Void = { _ in }
    
    func host(
        parent: UIViewController,
        colors: [UIColor],
        colorWasSelected: @escaping (Color) -> Void
    ) {
        let view = ColorPickerCellV2View(
            colors: colors,
            colorWasSelected: colorWasSelected
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
    
    func colorWasSelected(_ color: Color) {
        self.colorWasSelected(color)
    }
}
