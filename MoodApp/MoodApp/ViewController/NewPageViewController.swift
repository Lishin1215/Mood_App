//
//  NewPageViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/16.
//

import UIKit
import SwiftUI
import Combine


class NewPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
   
    
    //sleep circular slider
    private var sleepCancellable: AnyCancellable?
    private var wakeUpCancellable: AnyCancellable?
    
    //把值傳出來
    private var sleepTime = ""
    private var wakeUpTime = ""
    private var moodIndex: Int?
    private var selectedImage = UIImage()
    
    //cell裡的物件
    let textField = UITextField()
    let sleepButton = UIButton()
    
    //選擇的日期
    var date: Date?
    //傳過來的日期
    var dateComponents: DateComponents?
    
    let tableView = UITableView()
    
    //footer
    let footerView = UIView(frame: .zero)
    let addDayButton = UIButton(frame: .zero)
    
    //moodButtonArray 
    var moodButtonArray: [UIButton] = []
    
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
        
        textField.delegate = self

        
        
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
        
            //判斷入口
            if let dateComponents = dateComponents{ //按日期
                date = Calendar.current.date(from: dateComponents)
            } else { //按tabBar "+"
                date = Date() //當日
                
                //I. date寫成dateComponent形式，以便後續setData上傳fireStore
                let calendar = Calendar.current
                if let date = date {
                    let DC = calendar.dateComponents([.calendar, .era, .year, .month, .day], from: date)
                    self.dateComponents = DC
                }
            }
            
            //II. 日期(date)寫成String，用來更新label text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd" // 自定義你想要的日期格式，這裡只包含日期
            if let date = date{
                let dateString = dateFormatter.string(from: date)
                dateLabel.text = dateString
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
        addDayButton.backgroundColor = .lightLightGray //default
        addDayButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        addDayButton.titleLabel?.textAlignment = .center
        footerView.addSubview(addDayButton)
        
        addDayButton.isEnabled = false
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

        //先 default
        for moodButton in moodButtonArray{
            moodButton.backgroundColor = .white
        }
        //點選後要變顏色
        let selectedColor = UIColor.lightLightGray
        sender.layer.cornerRadius = 22
        sender.backgroundColor = selectedColor
        //得到選擇的"心情編號“
        self.moodIndex = sender.tag
        //addDayButton啟用（至少要選moodButton，才可加一天）
        addDayButton.isEnabled = true
        addDayButton.backgroundColor = .pinkOrange
    }
    
    @objc func sleepButtonTapped(_ sender: UIButton) {
       
    //delegate
        let delegate = SleepContentViewDelegate()
        //先設定監聽sleepTime/ wakeUpTime，如果"值有被assign value"才會傳值回來
        self.sleepCancellable = delegate.$sleepTime.sink{ sleepTime in
            print(sleepTime)
            self.sleepTime = sleepTime
            
        }
        self.wakeUpCancellable = delegate.$wakeUpTime.sink{ wakeUpTime in
            print(wakeUpTime)
            self.wakeUpTime = wakeUpTime
        }
        
    //closure觸發執行 (把自己收起來）(更新 sleepButton title)
        let onDoneTapped: () -> Void = { [weak self] in
            //dismiss
            self?.dismiss(animated: true, completion: nil)
            //更新button title
            if let sleepTime = self?.sleepTime,
               let wakeUpTime = self?.wakeUpTime {
                self?.sleepButton.setTitle("Sleep: \(sleepTime) ~ Wake: \(wakeUpTime)", for: .normal)
            } else {
                self?.sleepButton.setTitle("Sleep: - Wake: -", for: .normal)
            }
            self?.sleepButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            self?.sleepButton.setTitleColor(.lightBlack, for: .normal)
        }
        
        //swiftUI提供結合UIKit(hostController
        let sleepVC = UIHostingController(rootView: SleepContentView(delegate: delegate, onDoneTapped: onDoneTapped))
        present(sleepVC, animated: true)
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
        
        //判斷“是否有圖片”上傳
        if selectedImage == UIImage() { //無圖片上傳
            var date: Date?
            if let dateComponents = self.dateComponents,
               let convertedDate = Calendar.current.date(from: dateComponents) {
                    date = convertedDate
            } else {
                print ("Cannot convert to date!")
            }
            //if 新的一天
            if let date = date {
                //資料寫入fireStore
                FireStoreManager.shared.setData(
                date: date,
                mood: String(self.moodIndex ?? 0),
                sleepStart: self.sleepTime,
                sleepEnd: self.wakeUpTime,
                text: self.textField.text ?? "",
                photo: "",
                handler: {
                    FireStoreManager.shared.fetchData()
                })
            }
            //else 編輯過去的某一天
    //        FireStoreManager.shared.updateData()
        } else { //有圖片
            //上傳image到fireStorage
            FireBaseStorageManager.shared.uploadPhoto(image: selectedImage) { result in
                switch result {
                    case .success(let url):
                        var date: Date?
                        if let dateComponents = self.dateComponents,
                           let convertedDate = Calendar.current.date(from: dateComponents) {
                                date = convertedDate
                        } else {
                            print ("Cannot convert to date!")
                        }
                        //if 新的一天
                        if let date = date {
                            //資料寫入fireStore
                            FireStoreManager.shared.setData(
                            date: date,
                            mood: String(self.moodIndex ?? 0),
                            sleepStart: self.sleepTime,
                            sleepEnd: self.wakeUpTime,
                            text: self.textField.text ?? "",
                            photo: url.absoluteString, //url轉成String
                            handler: {
                                FireStoreManager.shared.fetchData()
                            })
                        }
                        //else 編輯過去的某一天
                //        FireStoreManager.shared.updateData()
                    case .failure(let error):
                       print(error)
                    }
            }
        }
        
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPageCell.reuseIdentifier, for: indexPath) as? NewPageCell
            else { fatalError("Could not create Cell") }
        
            cell.moodLabel.text = "How's Your Day"
            
        //button
            let buttonImages = ["image 8", "image 13", "image 25", "image 7", "image 22"] //#imageLiteral(
            
            moodButtonArray = [] //淨空，以防table reload，會重複加入buttonArray
            for index in 0 ..< buttonImages.count {
                let button = UIButton()
                button.tag = index
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
                moodButtonArray.append(button)
            }
            
            
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPageCell.reuseIdentifier, for: indexPath) as? NewPageCell else { fatalError("Could not create Cell") }
            
            cell.moodLabel.text = "Sleep Time"
        
        //button(sleep circular slider)
//            let sleepButton = UIButton()
            sleepButton.backgroundColor = .lightLightGray
            sleepButton.layer.cornerRadius = 10
            sleepButton.addTarget(self, action: #selector(sleepButtonTapped), for: .touchUpInside)
            cell.addSubview(sleepButton)
            
            sleepButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                sleepButton.topAnchor.constraint(equalTo: cell.containerView.topAnchor, constant: 50),
                sleepButton.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 30),
                sleepButton.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -30),
                sleepButton.heightAnchor.constraint(equalToConstant: 38)
            ])
            
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewPageCell.reuseIdentifier, for: indexPath) as? NewPageCell else { fatalError("Could not create Cell") }
            
            cell.moodLabel.text = "Write About Today"
            
        //textField
//            let textField = UITextField()
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
            self.selectedImage = image
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
