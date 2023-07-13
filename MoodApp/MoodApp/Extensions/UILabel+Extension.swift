//
//  UILabel+Extension.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/7/13.
//

import UIKit


extension UILabel {
    
    static func createLabel(text: String, font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment, in view: UIView, topAnchorConstant: CGFloat, leadingAnchorConstant: CGFloat, trailingAnchorConstant: CGFloat? = nil) -> UILabel {
        
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: topAnchorConstant),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingAnchorConstant),
            trailingAnchorConstant != nil ? label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingAnchorConstant ?? 0): nil
        ].compactMap { $0 })
        
        
        
        return label
    }
}

