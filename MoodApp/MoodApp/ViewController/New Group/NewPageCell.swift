//
//  newPageCell.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/16.
//

import UIKit

class NewPageCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: NewPageCell.self)
    
    let containerView = UIView()
    let moodLabel = UILabel()
    
//    let moodButtonOne = UIButton()
//    let moodButtonTwo = UIButton()
//    let moodButtonThree = UIButton()
//    let moodButtonFour = UIButton()
//    let moodButtonFive = UIButton()
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
    
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
            containerView.heightAnchor.constraint(equalToConstant: 110)])
        
    //label
        containerView.addSubview(moodLabel)
        moodLabel.font =  UIFont.boldSystemFont(ofSize: 15)
        moodLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moodLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            moodLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)])
        
    //button
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
   
}
    

    
