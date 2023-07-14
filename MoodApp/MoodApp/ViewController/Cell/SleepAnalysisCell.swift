//
//  SleepAnalysisCell.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/20.
//

import UIKit

class SleepAnalysisCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: SleepAnalysisCell.self)
    

    let containerView = ContainerView()
    let containerView2 = ContainerView()
    var noRecord = UILabel()
    var noRecord2 = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        

        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 70),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            containerView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
    // titleLabel
        let titleLabel = UILabel.createLabel(text: NSLocalizedString("Sleep", comment: ""),
                                             font: UIFont.systemFont(ofSize: 14),
                                             textColor: .darkGray,
                                             textAlignment: .center,
                                             in: self,
                                             topAnchorConstant: 36,
                                            centerXAnchorConstant: 0)
        
        
        addSubview(containerView2)
        containerView2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView2.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 40),
            containerView2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            containerView2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            containerView2.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        
    // no record label
        func createNoRecordLabel(in view: UIView) -> UILabel {
            
            let label = UILabel()
            label.isHidden = true // default隱藏
            label.text = NSLocalizedString("NoRecord", comment: "")
            label.font = UIFont.boldSystemFont(ofSize: 16)
            view.addSubview(label)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            
            return label
        }
        
        
        self.noRecord = createNoRecordLabel(in: containerView)
        self.noRecord2 = createNoRecordLabel(in: containerView2)
        
        
    // unit label
        let unitLabel = UILabel.createLabel(text: "(hrs)",
                                            font: UIFont.systemFont(ofSize: 10),
                                            textColor: .lightGray,
                                            textAlignment: .left,
                                            in: containerView2,
                                            topAnchorConstant: 34,
                                            leadingAnchorConstant: 12)
        
        
    // label & imageView on top
        let dot = UIImage(systemName: "circle.fill")
        let greenDot = dot?.tinted(with: .grassGreen)
        let orangeDot = dot?.tinted(with: .orangeBrown)
        
        
        let greenDotView = UIImageView(image: greenDot)
        containerView2.addSubview(greenDotView)
        greenDotView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            greenDotView.topAnchor.constraint(equalTo: containerView2.topAnchor, constant: 21),
            greenDotView.leadingAnchor.constraint(equalTo: containerView2.leadingAnchor, constant: 45),
            greenDotView.heightAnchor.constraint(equalToConstant: 10),
            greenDotView.widthAnchor.constraint(equalTo: greenDotView.heightAnchor)
            
        ])
        
        
        let lessLabel = UILabel.createLabel(text: NSLocalizedString("lessLabel", comment: ""),
                                            font: UIFont.systemFont(ofSize: 12),
                                            textColor: .lightGray,
                                            textAlignment: .left,
                                            in: containerView2,
                                            topAnchorConstant: 18,
                                            trailingAnchorConstant: -45)
        
        
        let orangeDotView = UIImageView(image: orangeDot)
        containerView2.addSubview(orangeDotView)
        orangeDotView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            orangeDotView.topAnchor.constraint(equalTo: containerView2.topAnchor, constant: 21),
            orangeDotView.trailingAnchor.constraint(equalTo: lessLabel.leadingAnchor, constant: -6),
            orangeDotView.heightAnchor.constraint(equalToConstant: 10),
            orangeDotView.widthAnchor.constraint(equalTo: orangeDotView.heightAnchor)
        ])
        
        
        let moreLabel = UILabel.createLabel(text: NSLocalizedString("moreLabel", comment: ""),
                                            font: UIFont.systemFont(ofSize: 12),
                                            textColor: .lightGray,
                                            textAlignment: .left,
                                            in: containerView2,
                                            topAnchorConstant: 18)
        
        NSLayoutConstraint.activate([
            moreLabel.leadingAnchor.constraint(equalTo: greenDotView.trailingAnchor, constant: 6)
        ])
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 改變UIImage顏色
extension UIImage {
    func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        color.setFill()
        
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)
        context.fill(rect)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage
    }
}
