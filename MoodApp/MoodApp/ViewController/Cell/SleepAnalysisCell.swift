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
        containerView2.layer.shadowOpacity = 0.5
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
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
