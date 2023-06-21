//
//  LookBackViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/21.
//

import UIKit

class LookBackViewController: UIViewController {

    //header
    let headerView = UIView()
    let titleLabel = UILabel()
    
    let dateLabel = UILabel()
    let historyButton = UIButton()
    let containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    //header
        headerView.backgroundColor = .pinkOrange
        view.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.14)
        ])
        
        titleLabel.text = "Memoir"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headerView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -30)
        ])
        
    //date (當月）
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, yyyy"
        let dateString = dateFormatter.string(from: date)
        dateLabel.text = dateString
        
        dateLabel.textColor = .darkGray
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        headerView.addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    //historyButton (看要不要跟dateLabel寫成一個stackView)
        historyButton.setImage(UIImage(named: "Icons_24px_DropDown"), for: .normal)
        historyButton.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
        view.addSubview(historyButton)
        
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            historyButton.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 5),
            historyButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 26)
        ])
        
        
    //container
        containerView.backgroundColor = .lightPinkOrange
        containerView.layer.cornerRadius = 10
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 25),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        
//        checkPhotoAmount()
        
    }
    
    
    func checkPhotoAmount() {
        /* if photoArray.count > 10 {
         scrollView
         keepRecordLabel.isHidden = true
         } else {
         keepRecordLabel
         scrollView.isHidden = true
         */
    }
    
    @objc func historyButtonTapped(_ sender: UIButton) {
        print("oh yeah oh my god!")
    }

   

}
