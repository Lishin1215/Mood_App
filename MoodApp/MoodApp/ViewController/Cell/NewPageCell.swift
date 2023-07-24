//
//  newPageCell.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/16.
//

import UIKit

class NewPageCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: NewPageCell.self)
    
    let containerView = ContainerView()
    let moodLabel = UILabel()
    
    
    // 初始化設置
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //取消選取時的灰色背景
        selectionStyle = .none
        
        addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            containerView.heightAnchor.constraint(equalToConstant: 110)
        ])
        
    //label
        containerView.addSubview(moodLabel)
        moodLabel.font =  UIFont.boldSystemFont(ofSize: 15)
        
        moodLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moodLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            moodLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)])
        
    
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
   
}
    

    
