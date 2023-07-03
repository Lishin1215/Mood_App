//
//  MoodFlowCell.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/20.
//

import UIKit

class MoodFlowCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: MoodFlowCell.self)
    
    let containerView = UIView()
    let titleLabel = UILabel()
    let noRecord = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 70),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            containerView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        //label
        titleLabel.text = NSLocalizedString("MoodFlow", comment: "")
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 36)
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
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
