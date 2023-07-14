//
//  MoodFlowCell.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/20.
//

import UIKit

class MoodFlowCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: MoodFlowCell.self)
    
    let containerView = ContainerView()
    var noRecord = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 70),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            containerView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        //label
        let titleLabel = UILabel.createLabel(text: NSLocalizedString("MoodFlow", comment: ""),
                                              font: UIFont.systemFont(ofSize: 14),
                                              textColor: .darkGray,
                                              textAlignment: .center,
                                              in: self,
                                                topAnchorConstant: 36,
                                                centerXAnchorConstant: 0)
        
        // no record label
        self.noRecord = UILabel.createLabel(text: NSLocalizedString("NoRecord", comment: ""),
                                            font: UIFont.boldSystemFont(ofSize: 16),
                                            textColor: .black,
                                            textAlignment: .center,
                                            in: containerView,
                                            centerXAnchorConstant: 0,
                                            centerYAnchorConstant: 0)
        noRecord.isHidden = true // default

        
        // unit label
        let unitLabel = UILabel.createLabel(text: "(points)",
                                            font: UIFont.systemFont(ofSize: 10),
                                            textColor: .lightGray,
                                            textAlignment: .left,
                                            in: containerView,
                                            topAnchorConstant: 12,
                                            leadingAnchorConstant: 10)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
