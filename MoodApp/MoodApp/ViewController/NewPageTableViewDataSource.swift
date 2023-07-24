//
//  NewPageTableViewDataSource.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/7/24.
//

import UIKit

class NewPageTableViewDataSource: NSObject, UITableViewDataSource {
    
    weak var viewController: NewPageViewController?
    
    
// MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPageCell.reuseIdentifier, for: indexPath) as? NewPageCell
            else { fatalError("Could not create Cell") }
        
            cell.moodLabel.text = NSLocalizedString("dailyMood", comment: "")
            
        // button
            let buttonImages = ["image 22", "image 7", "image 25", "image 13", "image 8"] // #imageLiteral(
            
            viewController?.moodButtonArray = [] // 淨空，以防table reload，會重複加入buttonArray
            
            for index in 0 ..< buttonImages.count {
                let button = UIButton()
                button.tag = index
                button.setImage(UIImage(named: buttonImages[index]), for: .normal)
                button.addTarget(viewController, action: #selector(viewController?.moodButtonTapped), for: .touchUpInside)
                cell.addSubview(button)
                
                button.translatesAutoresizingMaskIntoConstraints = false
                
                // 先unwrap再設constraint
                // 呼叫leadingDistanceByIndex，算出leading距離
                if let viewController = viewController {
                    let buttonLeadingConstraint = button.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: viewController.leadingDistanceByIndex(index: index, imageWidth: 38, space: 18))
                        
                    NSLayoutConstraint.activate([
                        button.topAnchor.constraint(equalTo: cell.containerView.topAnchor, constant: 50), button.widthAnchor.constraint(equalToConstant: 38), button.heightAnchor.constraint(equalTo: button.widthAnchor), buttonLeadingConstraint
                    ])
                }
                viewController?.moodButtonArray.append(button)
            }
            
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPageCell.reuseIdentifier, for: indexPath) as? NewPageCell else { fatalError("Could not create Cell") }
            
            cell.moodLabel.text = NSLocalizedString("sleepTimeLabel", comment: "")
        
        // button(sleep circular slider)
            viewController?.sleepButton.backgroundColor = .lightPinkOrange
            viewController?.sleepButton.layer.cornerRadius = 10
            viewController?.sleepButton.addTarget(viewController, action: #selector(viewController?.sleepButtonTapped), for: .touchUpInside)
            cell.addSubview(viewController?.sleepButton ?? UIView())
            
            viewController?.sleepButton.translatesAutoresizingMaskIntoConstraints = false
            
            // 先unwrap再設constraint
            if let viewController = viewController {
                NSLayoutConstraint.activate([
                    viewController.sleepButton.topAnchor.constraint(equalTo: cell.containerView.topAnchor, constant: 50),
                    viewController.sleepButton.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 30),
                    viewController.sleepButton.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -30),
                    viewController.sleepButton.heightAnchor.constraint(equalToConstant: 38)
                ])
            }
            
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPageCell.reuseIdentifier, for: indexPath) as? NewPageCell else { fatalError("Could not create Cell") }
            
            cell.moodLabel.text = NSLocalizedString("writeToday", comment: "")
            
        // textField
            viewController?.textField.backgroundColor = .lightPinkOrange
            viewController?.textField.layer.cornerRadius = 10
            
            // 游標右移
            viewController?.textField.setValue(NSNumber(value:12), forKey: "paddingLeft")
            
            cell.addSubview(viewController?.textField ?? UIView())
            
            viewController?.textField.translatesAutoresizingMaskIntoConstraints = false
            
            // 先unwrap再設constraint
            if let viewController = viewController {
                NSLayoutConstraint.activate([
                    viewController.textField.topAnchor.constraint(equalTo: cell.containerView.topAnchor, constant: 50),
                    viewController.textField.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 30),
                    viewController.textField.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -30),
                    viewController.textField.heightAnchor.constraint(equalToConstant: 38)
                ])
            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPagePhotoCell.reuseIdentifier, for: indexPath) as? NewPagePhotoCell else { fatalError("Could not create Cell") }
            
            cell.titleLabel.text = NSLocalizedString("photoToday", comment: "")
       
        // button(UIImagePicker)
            cell.imageButton.addTarget(viewController, action: #selector(viewController?.imageButtonTapped), for: .touchUpInside)
            
            return cell
        }
    }
}
