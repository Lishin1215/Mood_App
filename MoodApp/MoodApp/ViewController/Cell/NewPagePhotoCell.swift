//
//  newPagePhotoCell.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/16.
//

import UIKit

class NewPagePhotoCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: NewPagePhotoCell.self)
    
    let containerView = UITableViewCell()
    let titleLabel = UILabel()
    
    // 初始化設置
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //取消選取時的灰色背景
        selectionStyle = .none
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            containerView.heightAnchor.constraint(equalToConstant: 200)])
        
    //label
        containerView.addSubview(titleLabel)
        titleLabel.font =  UIFont.boldSystemFont(ofSize: 15)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)])
        

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
