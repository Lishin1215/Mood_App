//
//  PopUpCell.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/30.
//

import UIKit

class PopUpCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: PopUpCell.self)
    
    let monthButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        monthButton.layer.cornerRadius = 5
        monthButton.clipsToBounds = true
        monthButton.backgroundColor = .lightGray
        monthButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        monthButton.setTitleColor(.black, for: .normal)
        
        addSubview(monthButton)
        
        monthButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            monthButton.topAnchor.constraint(equalTo: topAnchor),
            monthButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            monthButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            monthButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
