//
//  UILabel+Extension.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/7/13.
//

import UIKit


extension UILabel {
    
    static func createLabel(text: String,
                            font: UIFont,
                            textColor: UIColor,
                            textAlignment: NSTextAlignment,
                            in view: UIView,
                            useSafeAreaLayoutGuide: Bool = false,
                            topAnchorConstant: CGFloat,
                            leadingAnchorConstant: CGFloat? = nil,
                            trailingAnchorConstant: CGFloat? = nil,
                            centerXAnchorConstant: CGFloat? = nil,
                            centerYAnchorConstant: CGFloat? = nil)
    -> UILabel {
        
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        //constraints
        var constraints: [NSLayoutConstraint] = []
        
        
        if let leadingAnchorConstant = leadingAnchorConstant {
            
            constraints.append(label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingAnchorConstant))
        }
        
        if let trailingAnchorConstant = trailingAnchorConstant {
            
            constraints.append(label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingAnchorConstant))
        }
        
        if let centerXAnchorConstant = centerXAnchorConstant {
            
            constraints.append(label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: centerXAnchorConstant))
        }
        
        if let centerYAnchorConstant = centerYAnchorConstant {
            
            constraints.append(label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: centerYAnchorConstant))
        } else {
            if useSafeAreaLayoutGuide {
                constraints.append(label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topAnchorConstant))
            } else {
                constraints.append(label.topAnchor.constraint(equalTo: view.topAnchor, constant: topAnchorConstant))
            }
        }
        
        NSLayoutConstraint.activate(constraints)
        
//        NSLayoutConstraint.activate([
//            label.topAnchor.constraint(equalTo: view.topAnchor, constant: topAnchorConstant),
//            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingAnchorConstant),
//            trailingAnchorConstant != nil ? label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingAnchorConstant ?? 0): nil
//        ].compactMap { $0 })
        
        
        
        return label
    }
}

