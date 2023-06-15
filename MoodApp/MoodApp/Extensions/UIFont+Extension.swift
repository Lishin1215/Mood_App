//
//  UIFont+Extension.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/15.
//

import UIKit


private enum STFontName: String {
    case regular = "Roboto-Regular"
}

extension UIFont {

    static func medium(size: CGFloat) -> UIFont? {
        var descriptor = UIFontDescriptor(name: STFontName.regular.rawValue, size: size)
        descriptor = descriptor.addingAttributes(
            [UIFontDescriptor.AttributeName.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.medium]]
        )
        return UIFont(descriptor: descriptor, size: size)
    }

    static func regular(size: CGFloat) -> UIFont? {
        return STFont(.regular, size: size)
    }

    private static func STFont(_ font: STFontName, size: CGFloat) -> UIFont? {
        return UIFont(name: font.rawValue, size: size)
    }
}
