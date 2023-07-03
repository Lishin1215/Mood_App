//
//  SettingsCell.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/21.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: SettingsCell.self)
    
    let containerView = UIView()
    let contentLabel = UILabel()
    
    var containerViewHeightConstraint: NSLayoutConstraint?
    
    
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
//            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 30), //row自定義
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
//            containerView.heightAnchor.constraint(equalToConstant: 70)
        ])
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 70)
               containerViewHeightConstraint?.isActive = true
        
        //contentLabel
        containerView.addSubview(contentLabel)
        contentLabel.font = UIFont.boldSystemFont(ofSize: 15)
        contentLabel.textColor = .darkGray
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            contentLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor), //自定義
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// 設置 containerView 的高度
    func setContainerViewHeight(_ height: CGFloat) {
        containerViewHeightConstraint?.constant = height
    }
    
    func setContainerViewTopAnchor(_ constant:CGFloat) {
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: constant).isActive = true
    }
}
