//
//  SettingsViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/21.
//

import UIKit
//import AuthenticationServices // Sign in with Apple 的主體框架
//import CryptoKit // 用來產生隨機字串 (Nonce) 的
import FirebaseAuth // 用來與 Firebase Auth 進行串接用的

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    //傳過來的值(“刪除帳號”要用到）
    var authCode: String = ""
    
    //delegate
    let loginVC = LoginPageViewController()
    
    //header
    let headerView = UIView()
    let titleLabel = UILabel()
    
    //reminder
    let remindSwitchButton = UISwitch()
    private var selectedTime: Date?
    
    //cell裡的物件
    let passwordSwitchButton = UISwitch()
    let datePicker = UIDatePicker()
    let languageButton = UIButton()
    let deleteButton = UIButton()
    
    
    let tableView = UITableView()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate
        loginVC.delegate = self

        tableView.dataSource = self
        tableView.delegate = self
        
    //register
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseIdentifier)

        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        headerView.backgroundColor = .pinkOrange
        view.addSubview(headerView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    //header
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.14)
        ])
        
        titleLabel.text = "Settings"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headerView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -30)
        ])
        
    }
    
    
    @objc func passwordCondition(_ sender: UISwitch) {
        if sender.isOn {
            
            //default清空原密碼
            StorageManager.shared.deletePassword()
            //push到password VC
            if let passwordVC = storyboard?.instantiateViewController(withIdentifier: "PasswordVC") as? PasswordViewController {
                //沒有navigation controller -> 不能push
                passwordVC.modalPresentationStyle = .fullScreen
                self.present(passwordVC, animated: true, completion: nil)
            }
        } else {
            
            //delete Password，進入app時，“不會”跳出passwordVC
            StorageManager.shared.deletePassword()
        }
    }
    
    @objc func remindCondition(_ sender: UISwitch) {
        if sender.isOn {
            //default（先清空，再設定）
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["notification"])
            //開啟datePicker
            datePicker.isHidden = false
            
            //設定通知內容
            let content = UNMutableNotificationContent()
            content.title = "MoodApp"
            content.body = "Don't forget to record your day ☺️"
            content.badge = 1
            content.sound = UNNotificationSound.default
            
            //設定通知時間 (把date轉成DateComponents)
            print(self.selectedTime)
            let calendar = Calendar.current
            let selectedDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: selectedTime ?? Date())
            print(selectedDateComponents)
            //設定通知引信
            let trigger = UNCalendarNotificationTrigger(dateMatching: selectedDateComponents, repeats: false)
            //設定通知要求
            let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
            //向裝置發送要求
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                if let error = error {
                    print("發送通知失敗： \(error)")
                } else {
                    print("成功建立通知")
                }
            })
            
        } else {
            print("Close Reminder")
            //關閉通知
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["notification"])
            //關datePicker
            datePicker.isHidden = true
            //select time 清空
            self.selectedTime = nil
        }

    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedTime = sender.date
        print("datePick!")
        // 在這裡處理選擇的時間
        // 可以進行相關邏輯處理或將選擇的時間儲存起來
        self.selectedTime = selectedTime
        
        // datePicker一改變，且在switchButton是打開的狀況，就要“再發一次通知”
        if remindSwitchButton.isOn{
            remindCondition(remindSwitchButton)
        }else{
            print("not on yet")
        }
    }
    
    @objc func languageButtonTapped(_ sender: UIButton) {
        print("I want Mandarin!")
        //被點擊感
        languageButton.alpha = languageButton.isHighlighted ? 0.5 : 1
        //present 一個view (可以選中英文）
        
        //點擊感消失
        
    }
    
    @objc func deleteAccountTapped(_ sender: UIButton) {
        print("要確定齁")
        
        //跳alert --> confirm
        let controller = UIAlertController(title: "Delete Account", message: "Are you sure to delete account?\nThis will permanentely erase your account.", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteUser()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        controller.addAction(deleteAction)
        controller.addAction(cancelAction)
        present(controller, animated: true)
    }
    
    
    func deleteUser() {// ***先revoke憑證再delete帳號
        
        //I. delete fireStore (其實應該沒有先後順序問題）
        FireStoreManager.shared.deleteData {
            
            // II. 在刪除前要先撤銷apple的憑證，這個憑證可以從LoginPageViewController.swift的didCompleteWithAuthorization() function拿到（authCodeString）
            // 到時候可能會需要一個變數存起來
            Auth.auth().revokeToken(withAuthorizationCode: self.authCode)


            // III. 在revoke撤銷憑證好才能delete帳號
            if let user = Auth.auth().currentUser{
                user.delete { error in
                  if let error = error {
                      print("error: didn't delete user")
                    // An error happened.
                  } else {
                    // Account deleted.
                      print("delete succesfully")
                  }
                }
            }


            //IV. 跳回login Page
            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginPageViewController {
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
            }
        }
        
        
       
    }
    

    
    
//height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 135
        } else if indexPath.row == 2 {
            return 150
        } else {
            return 115
        }
    }

    
//MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifier, for: indexPath) as? SettingsCell
            else {fatalError("Could not create Cell")}
            
        //generalLabel
            let generalLabel = UILabel()
            generalLabel.text = "General"
            generalLabel.textColor = .darkGray
            generalLabel.font = UIFont.systemFont(ofSize: 15)
            cell.addSubview(generalLabel)
            
            generalLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                generalLabel.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 30),
                generalLabel.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 30)
            ])
        
            //調整containerView topAnchor
            cell.setContainerViewTopAnchor(60)

            cell.contentLabel.text = "Passcode"
            NSLayoutConstraint.activate([
                cell.contentLabel.centerYAnchor.constraint(equalTo: cell.containerView.centerYAnchor)
            ])
            
        //右側按鈕(switch)
//            let passwordSwitchButton = UISwitch()
//            passwordSwitchButton.isOn = false
            cell.addSubview(passwordSwitchButton)
            passwordSwitchButton.addTarget(self, action: #selector(passwordCondition), for: .valueChanged)
            
            passwordSwitchButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                passwordSwitchButton.centerYAnchor.constraint(equalTo: cell.containerView.centerYAnchor),
                passwordSwitchButton.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -30)
            ])
            
            // 先去判斷現在是否有設password （有 -> 打開 /沒有 -> 關）
            if StorageManager.shared.fetchPassword() != nil {
                passwordSwitchButton.isOn = true
            } else {
                passwordSwitchButton.isOn = false
            }
            
            
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifier, for: indexPath) as?
                    SettingsCell
            else {fatalError("Could not create Cell")}
            
            cell.setContainerViewTopAnchor(30)
            
            cell.contentLabel.text = "Backup and Restore"
            NSLayoutConstraint.activate([
                cell.contentLabel.centerYAnchor.constraint(equalTo: cell.containerView.centerYAnchor)
            ])
            
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifier, for: indexPath) as?
                    SettingsCell
            else {fatalError("Could not create Cell")}
            
            //custom containerView height
            cell.setContainerViewHeight(120)
            cell.setContainerViewTopAnchor(30)
            
            cell.contentLabel.text = "Reminder Time"
            
            //custom contentLabel height
            NSLayoutConstraint.activate([
                cell.contentLabel.topAnchor.constraint(equalTo: cell.containerView.topAnchor, constant: 35)
            ])
            
            //右側按鈕(switch)
//            let remindSwitchButton = UISwitch()
            remindSwitchButton.isOn = false
            cell.addSubview(remindSwitchButton)
            remindSwitchButton.addTarget(self, action: #selector(remindCondition), for: .valueChanged)
            
            remindSwitchButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                remindSwitchButton.centerYAnchor.constraint(equalTo: cell.containerView.centerYAnchor),
                remindSwitchButton.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -30)
            ])
            
        //下方button(datePicker?)
//            let datePicker = UIDatePicker()
            datePicker.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            datePicker.datePickerMode = .time
            datePicker.isHidden = true //default關
            //最大時間
            let calendar = Calendar.current
            let maxTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: Date())// 最大時間為當天的 23:59:59
            datePicker.maximumDate = maxTime
            view.addSubview(datePicker)
            
            datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
            
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                datePicker.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 50),
                datePicker.bottomAnchor.constraint(equalTo: cell.containerView.bottomAnchor, constant: -30)
            ])
            
//            if self.selectedTime != nil { //有選擇時間且沒關閉
//                remindSwitchButton.isOn = true
//                datePicker.isHidden = false
//            } else {
//                remindSwitchButton.isOn = false
//                datePicker.isHidden = true
//            }
            
//            if remindSwitchButton.isOn == true {
//                remindSwitchButton.isOn = true
//                datePicker.isHidden = false
//            } else {
//                remindSwitchButton.isOn = false
//                datePicker.isHidden = true
//            }
            
            return cell
        } else if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifier, for: indexPath) as?
                    SettingsCell
            else {fatalError("Could not create Cell")}
            
            cell.setContainerViewTopAnchor(30)
            
            cell.contentLabel.text = "Language"
            NSLayoutConstraint.activate([
                cell.contentLabel.centerYAnchor.constraint(equalTo: cell.containerView.centerYAnchor)
            ])
            
            //右側點選語言(button)
//            let languageButton = UIButton()
            languageButton.setTitle("English", for: .normal)
            languageButton.setTitleColor(UIColor.pinkOrange, for: .normal)
            languageButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            cell.addSubview(languageButton)
            
            languageButton.addTarget(self, action: #selector(languageButtonTapped), for: .touchUpInside)
            
            languageButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                languageButton.centerYAnchor.constraint(equalTo: cell.containerView.centerYAnchor),
                languageButton.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -30)
            ])
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseIdentifier, for: indexPath) as? SettingsCell
            else { fatalError("Could not create Cell")}
            
            cell.setContainerViewTopAnchor(30)
            
            cell.contentLabel.isHidden = true
            
            //button
//            let deleteButton = UIButton()
            deleteButton.setTitle("Delete Account", for: .normal)
            deleteButton.setTitleColor(.systemRed, for: .normal)
            deleteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            cell.addSubview(deleteButton)
            
            deleteButton.addTarget(self, action: #selector(deleteAccountTapped), for: .touchUpInside)
            
            
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                deleteButton.centerXAnchor.constraint(equalTo: cell.containerView.centerXAnchor),
                deleteButton.centerYAnchor.constraint(equalTo: cell.containerView.centerYAnchor)
            ])
            
            return cell
        }
    }
    
}

extension SettingsViewController: LoginVCDelegate {
    func didReceiveAuthCode(authCode: String) {
        
        print("Successfully pass authCode from loginVC")
        
        self.authCode = authCode
    }
}
