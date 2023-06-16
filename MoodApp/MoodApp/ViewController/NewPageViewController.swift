//
//  NewPageViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/16.
//

import UIKit

class NewPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   

    
    //傳過來的日期
    var dateComponents: DateComponents?
    
    let tableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //替換自己的返回鍵（黑）
        
        //hide tabBar
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //tabBar appear again
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        //register
        tableView.register(NewPageCell.self, forCellReuseIdentifier: NewPageCell.reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        
        
    }
    
    
//height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    
    
//MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPageCell.reuseIdentifier, for: indexPath) as? NewPageCell else { fatalError("Could not create Cell") }
        
            cell.moodLabel.text = "How's Your Day"
            
            let buttonImages = ["image 8", "image 13", "image 25", "image 7", "image 22"] //#imageLiteral(
            for index in 0 ..< buttonImages.count {
                let button = UIButton()
                button.setImage(UIImage(named: buttonImages[index]), for: .normal)
                button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                cell.containerView.addSubview(button)
                
                // 根據索引決定按鈕的位置
                button.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    button.topAnchor.constraint(equalTo: cell.containerView.topAnchor, constant: 50),
                    button.widthAnchor.constraint(equalToConstant: 38),
                    button.heightAnchor.constraint(equalTo: button.widthAnchor),
                    button.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: CGFloat(40 + (50 * index))),
                ])
    }
            
            
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPageCell.reuseIdentifier, for: indexPath) as? NewPageCell else { fatalError("Could not create Cell") }
            
            cell.moodLabel.text = "Sleep Time"
            
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPageCell.reuseIdentifier, for: indexPath) as? NewPageCell else { fatalError("Could not create Cell") }
            
            cell.moodLabel.text = "Write About Today"
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPageCell.reuseIdentifier, for: indexPath) as? NewPageCell else { fatalError("Could not create Cell") }
            
            return cell
        }
    }
       
}
