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
    
    //button
    let imageButton = UIButton()
    let photoImage = UIImage(systemName: "photo")?.withRenderingMode(.alwaysOriginal)
    lazy var photoImageView = UIImageView(image: photoImage)
    
    
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
            containerView.heightAnchor.constraint(equalToConstant: 230)])
        
    //label
        containerView.addSubview(titleLabel)
        titleLabel.font =  UIFont.boldSystemFont(ofSize: 15)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)])
        
    //button
        imageButton.backgroundColor = .lightLightGray
        imageButton.layer.cornerRadius = 10
        contentView.addSubview(imageButton) //要點擊，所以要加在contentView上
        imageButton.addSubview(photoImageView)
        
        
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50),
            imageButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            imageButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            imageButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.centerXAnchor.constraint(equalTo: imageButton.centerXAnchor),
            photoImageView.centerYAnchor.constraint(equalTo: imageButton.centerYAnchor)
        ])
        

        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
