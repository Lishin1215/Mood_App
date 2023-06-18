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
    
    //footer
    let footerView = UIView(frame: .zero)
    let addDayButton = UIButton(frame: .zero)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        tableView.register(NewPagePhotoCell.self, forCellReuseIdentifier: NewPagePhotoCell.reuseIdentifier)
        
        //custom navigationBar
        if let navigationBar = navigationController?.navigationBar {
           let appearance = UINavigationBarAppearance()
           appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
           appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // 設定標題文字顏色
           appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // 設定大標題文字顏色
            
           navigationBar.standardAppearance = appearance
           navigationBar.scrollEdgeAppearance = appearance

           navigationItem.largeTitleDisplayMode = .always // 啟用大標題模式
           navigationController?.navigationBar.prefersLargeTitles = true
           
          //Date
            let dateLabel = UILabel()

            if let dateComponents = dateComponents,
                let date = Calendar.current.date(from: dateComponents) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd" // 自定義你想要的日期格式，這裡只包含日期
                let dateString = dateFormatter.string(from: date)
                dateLabel.text = dateString
            } else {
                dateLabel.text = ""
            }
            
            dateLabel.textColor = .black
            dateLabel.font = UIFont.boldSystemFont(ofSize: 40)
            navigationBar.addSubview(dateLabel)
            
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                dateLabel.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 20),
                dateLabel.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 52)
            ])
            
        //Week
            let weekdayLabel = UILabel()
            weekdayLabel.text = "Week"
            
//            if let dateComponents = dateComponents, let weekday = dateComponents.weekday {
//                let calendar = Calendar.current
//                let weekdaySymbols = calendar.weekdaySymbols
//                let weekdayIndex = weekday - calendar.firstWeekday
//
//                if weekdayIndex >= 0 && weekdayIndex < weekdaySymbols.count {
//                    let weekdayText = weekdaySymbols[weekdayIndex]
//                    weekdayLabel.text = weekdayText
//                } else {
//                    weekdayLabel.text = ""
//                }
//            } else {
//                weekdayLabel.text = ""
//            }
            
            weekdayLabel.textColor = .lightGray
            weekdayLabel.font = UIFont.systemFont(ofSize: 14)
            navigationBar.addSubview(weekdayLabel)
            
            weekdayLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                weekdayLabel.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: 24),
                weekdayLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10)
            ])
            
        //Month
            let monthLabel = UILabel()
            monthLabel.text = "Month"
            

            monthLabel.textColor = .lightGray
            monthLabel.font = UIFont.systemFont(ofSize: 14)
            navigationBar.addSubview(monthLabel)
            
            monthLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                monthLabel.topAnchor.constraint(equalTo: weekdayLabel.bottomAnchor, constant: 4),
                monthLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10)
            ])
       }

        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    //設定自定義“返回鍵”
        let systemImage = UIImage(systemName: "chevron.backward")?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(title: nil, image: systemImage, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
    //footer
        footerView.backgroundColor = .white
        //設footer上方的線

        tableView.tableFooterView = footerView
        
        // Add constraints
        footerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 80)
        ])
        //“加入購物車”按鈕
        addDayButton.setTitle("+  Add Day", for: .normal)
        
        addDayButton.setTitleColor(.white, for: .normal)
        addDayButton.layer.cornerRadius = 10
        addDayButton.backgroundColor = .pinkOrange
        addDayButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        addDayButton.titleLabel?.textAlignment = .center
        footerView.addSubview(addDayButton)
        
        addDayButton.addTarget(self, action: #selector(addDayTapped), for: .touchUpInside)

        // Add constraints
        addDayButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addDayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), addDayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addDayButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -16), addDayButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
    }
    
   
    
    @objc func backButtonTapped(_ sender: UIButton) { //兩條路都需執行，“系統會記住”我們點選哪條路過來
        // 按日期到newPage的時候是要pop出來
        navigationController?.popViewController(animated: false)
        // 按tabbar到newPage的時候因為不是segue，直接指定回到tabController的第0頁(homePage)即可
        tabBarController?.selectedIndex = 0
    }
    
    
    @objc func moodButtonTapped(_ sender: UIButton) {
        
        print("hello")
    }
    
    
    @objc func imageButtonTapped(_ sender: UIButton) {
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    
    @objc func addDayTapped(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: false)
        tabBarController?.selectedIndex = 0
    }
    
    
//height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    
    
//MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPageCell.reuseIdentifier, for: indexPath) as? NewPageCell else { fatalError("Could not create Cell") }
        
            cell.moodLabel.text = "How's Your Day"
            
        //button
            let buttonImages = ["image 8", "image 13", "image 25", "image 7", "image 22"] //#imageLiteral(
            for index in 0 ..< buttonImages.count {
                let button = UIButton()
                button.setImage(UIImage(named: buttonImages[index]), for: .normal)
                button.addTarget(self, action: #selector(moodButtonTapped), for: .touchUpInside)
                cell.addSubview(button)
                
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
        
        //datePicker
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .dateAndTime
            cell.addSubview(datePicker)
            
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                datePicker.topAnchor.constraint(equalTo: cell.containerView.topAnchor, constant: 50),
                datePicker.centerXAnchor.constraint(equalTo: cell.containerView.centerXAnchor),
                datePicker.heightAnchor.constraint(equalToConstant: 38)
            ])
            
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPageCell.reuseIdentifier, for: indexPath) as? NewPageCell else { fatalError("Could not create Cell") }
            
            cell.moodLabel.text = "Write About Today"
            
        //textField
            let textField = UITextField()
            textField.backgroundColor = .lightLightGray
            textField.layer.cornerRadius = 10
            cell.addSubview(textField)
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textField.topAnchor.constraint(equalTo: cell.containerView.topAnchor, constant: 50),
                textField.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 30),
                textField.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -30),
                textField.heightAnchor.constraint(equalToConstant: 38)
            ])
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPagePhotoCell.reuseIdentifier, for: indexPath) as? NewPagePhotoCell else { fatalError("Could not create Cell") }
            
            cell.titleLabel.text = "Today's Photo"
       
        //button(UIImagePicker)
            cell.imageButton.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
            
            return cell
        }
    }
       
}

extension NewPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            let indexPath = IndexPath(row: 3, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? NewPagePhotoCell {
                cell.imageButton.setImage(image, for: .normal)
                cell.photoImageView.isHidden = true
            }
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
