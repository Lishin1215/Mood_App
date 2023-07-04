//
//  SleepAnalysisCell.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/20.
//

import UIKit

class SleepAnalysisCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: SleepAnalysisCell.self)
    
    let containerView = UIView()
    let containerView2 = UIView()
    let titleLabel = UILabel()
    let noRecord = UILabel()
    let noRecord2 = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.25
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 70),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            containerView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        //label
        titleLabel.text = NSLocalizedString("Sleep", comment: "")
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 36)
        ])
        
    //containerView2
        containerView2.backgroundColor = .white
        containerView2.layer.cornerRadius = 10
        containerView2.layer.shadowColor = UIColor.black.cgColor
        containerView2.layer.shadowOpacity = 0.25
        containerView2.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView2.layer.shadowRadius = 4
        addSubview(containerView2)
        
        containerView2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView2.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 40),
            containerView2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            containerView2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            containerView2.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        //no record label
//        let noRecord = UILabel()
        noRecord.isHidden = true //default
        noRecord.text = NSLocalizedString("NoRecord", comment: "")
        noRecord.font = UIFont.boldSystemFont(ofSize: 16)
        containerView.addSubview(noRecord)
        
        noRecord.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noRecord.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            noRecord.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        //no record 2
        noRecord2.isHidden = true //default
        noRecord2.text = NSLocalizedString("NoRecord", comment: "")
        noRecord2.font = UIFont.boldSystemFont(ofSize: 16)
        containerView2.addSubview(noRecord2)
        
        noRecord2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noRecord2.centerXAnchor.constraint(equalTo: containerView2.centerXAnchor),
            noRecord2.centerYAnchor.constraint(equalTo: containerView2.centerYAnchor)
        ])
        
        
        //unit label
        let unitLabel = UILabel()
        unitLabel.text = "(hrs)"
        unitLabel.font = UIFont.systemFont(ofSize: 10)
        unitLabel.textColor = .lightGray
        
        containerView2.addSubview(unitLabel)
        
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            unitLabel.topAnchor.constraint(equalTo: containerView2.topAnchor, constant: 34),
            unitLabel.leadingAnchor.constraint(equalTo: containerView2.leadingAnchor, constant: 12)
        ])
        
        
        // label & imageView on top
        let moreLabel = UILabel()
        let lessLabel = UILabel()
        let dot = UIImage(systemName: "circle.fill")
        let greenDot = dot?.tinted(with: .grassGreen)
        let orangeDot = dot?.tinted(with: .orangeBrown)
        let greenDotView = UIImageView(image: greenDot)
        let orangeDotView = UIImageView(image: orangeDot)
        
        moreLabel.text = NSLocalizedString("moreLabel", comment: "")
        moreLabel.font = UIFont.systemFont(ofSize: 12)
        moreLabel.textColor = .lightGray
        
        lessLabel.text = NSLocalizedString("lessLabel", comment: "")
        lessLabel.font = UIFont.systemFont(ofSize: 12)
        lessLabel.textColor = .lightGray
        
        containerView2.addSubview(moreLabel)
        containerView2.addSubview(lessLabel)
        containerView2.addSubview(greenDotView)
        containerView2.addSubview(orangeDotView)
        
        moreLabel.translatesAutoresizingMaskIntoConstraints = false
        lessLabel.translatesAutoresizingMaskIntoConstraints = false
        greenDotView.translatesAutoresizingMaskIntoConstraints = false
        orangeDotView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            greenDotView.topAnchor.constraint(equalTo: containerView2.topAnchor, constant: 21),
            greenDotView.leadingAnchor.constraint(equalTo: containerView2.leadingAnchor, constant: 45),
            greenDotView.heightAnchor.constraint(equalToConstant: 10),
            greenDotView.widthAnchor.constraint(equalTo: greenDotView.heightAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
            moreLabel.topAnchor.constraint(equalTo: containerView2.topAnchor, constant: 18),
            moreLabel.leadingAnchor.constraint(equalTo: greenDotView.trailingAnchor, constant: 6)
        ])
        
        NSLayoutConstraint.activate([
            orangeDotView.topAnchor.constraint(equalTo: containerView2.topAnchor, constant: 21),
            orangeDotView.trailingAnchor.constraint(equalTo: lessLabel.leadingAnchor, constant: -6),
            orangeDotView.heightAnchor.constraint(equalToConstant: 10),
            orangeDotView.widthAnchor.constraint(equalTo: orangeDotView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            lessLabel.topAnchor.constraint(equalTo: containerView2.topAnchor, constant: 18),
            lessLabel.trailingAnchor.constraint(equalTo: containerView2.trailingAnchor, constant: -45)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//改變UIImage顏色
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
