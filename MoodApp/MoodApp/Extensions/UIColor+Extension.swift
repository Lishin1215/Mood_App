//
//  UIColor+Extension.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/15.
//

import UIKit


extension UIColor {
    // 在这里定义你想要的颜色扩展
    
    static var darkBlack: UIColor {
        return UIColor(red: 0.128, green: 0.145, blue: 0.146, alpha: 1) // 示例：定义一个名为 primaryColor 的颜色
    }
    
    static var lightBlack: UIColor {
        return UIColor(red: 0.321, green: 0.315, blue: 0.315, alpha: 1)
    }
    
    static var lightLightGray: UIColor {
        return UIColor(red: 0.21, green: 0.22, blue: 0.354, alpha: 0.09)
    }
    
    static var orangeBrown: UIColor {
        return UIColor(red: 0.839, green: 0.557, blue: 0.333, alpha: 1)
    }
    
    static var pinkOrange: UIColor {
        return UIColor(red: 0.954, green: 0.684, blue: 0.533, alpha: 1)
    }
    
    static var lightPinkOrange: UIColor {
        return UIColor(red: 0.946, green: 0.579, blue: 0.028, alpha: 0.09)
    }
    
    
    //漸層橘
    static func gradientColor(with colors: [UIColor]) -> UIColor? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)

        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            if let image = gradientImage {
                return UIColor(patternImage: image)
            }
        }

        return nil
    }
    
    
    
    //沒“驚嘆號”寫法
//    static func gradientColor(with colors: [UIColor]) -> UIColor? {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = colors.map { $0.cgColor }
//
//        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
//
//        if let context = UIGraphicsGetCurrentContext() {
//            gradientLayer.render(in: context)
//            let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//
//            if let image = gradientImage {
//                return UIColor(patternImage: image)
//            }
//        }
//
//        return nil
//    }
    
    
//    static func gradientColor(with colors: [UIColor]) -> UIColor {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = colors.map { $0.cgColor }
//
//        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
//        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
//        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return UIColor(patternImage: gradientImage!)
//    }
    
    
}




/*漸層橘使用
 
 let gradientColors = [
     UIColor(red: 0.837, green: 0.556, blue: 0.332, alpha: 1),
     UIColor(red: 0.942, green: 0.539, blue: 0.451, alpha: 0.9)
 ]
 
 let gradientColor = UIColor.gradientColor(with: gradientColors)
 
 */
