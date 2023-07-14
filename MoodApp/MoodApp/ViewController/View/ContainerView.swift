//
//  ContainerView.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/7/4.
//

import UIKit

class ContainerView: UIView {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        
        self.translatesAutoresizingMaskIntoConstraints = false

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
