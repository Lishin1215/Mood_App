//
//  PasswordViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/26.
//

import UIKit

class PasswordViewController: UIViewController {

    private var enter: String = ""
    private var newPassword: String = ""
    private var confirmPassword: String = ""
    
    @IBOutlet var numButtonArray: [UIButton]!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var badgeImageView: [UIImageView]!
    @IBOutlet var fillImageView: [UIImageView]!
    @IBOutlet var deleteButton: UIButton!
    
    @IBOutlet weak var colorImageView: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //hide tabBar
        tabBarController?.tabBar.isHidden = true
        
        // Hide the back button in the navigation bar
        navigationItem.hidesBackButton = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // make tab bar appear again
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if StorageManager.shared.fetchPassword() == nil {
            //沒有密碼 --> 設定密碼
            titleLabel.text = NSLocalizedString("passwordTitleNew", comment: "")
        } else  {
            titleLabel.text = NSLocalizedString("passwordTitleOld", comment: "")
        }
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        subtitleLabel.isHidden = true
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .brown
        subtitleLabel.font = UIFont.systemFont(ofSize: 18)
        
        
        colorImageView.backgroundColor = .orangeBrown
        NSLayoutConstraint.activate([
            colorImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            colorImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            colorImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        ])
        
        // 计算标签之间的水平间距
        let spacing: CGFloat = view.frame.width / 7
        
        // 遍历数组中的每个标签
        for (index, label) in badgeImageView.enumerated() {
            // 设置标签的约束
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing * CGFloat(index + 2)).isActive = true
        }
        
        
        for (index, label) in fillImageView.enumerated() {
            // 设置标签的约束
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing * CGFloat(index + 2)).isActive = true
        }
    
        for button in numButtonArray {
            button.layer.cornerRadius = 5
            button.clipsToBounds = true // 设置为 true，以确保按钮内容在圆角区域内显示
        }
        
        deleteButton.layer.cornerRadius = 5
        
       
    }
    

    //輸入的字串相加
    @IBAction func enterPassword(_ sender: UIButton) {
        //三種情況
        if StorageManager.shared.fetchPassword() == nil {
            //沒有密碼 --> 設定密碼
            if newPassword.count != 4 { //設新密碼
                if let inputNumber = sender.currentTitle {
                    //字串相加
                    newPassword.append(inputNumber)
                }
                imageShow(currentPassword: newPassword)
                
            } else if newPassword.count == 4 { //進入confirmPassword階段
                if let inputNumber = sender.currentTitle {
                    //字串相加
                    confirmPassword.append(inputNumber)
                }
                imageShow(currentPassword: confirmPassword)
            }
                
        } else { // 一般狀況進入(已設密碼）
            //密碼長度等於4，就不能再進入if
            if enter.count != 4 {
                if let inputNumber = sender.currentTitle {
                    //字串相加
                    enter.append(inputNumber)
                }
                imageShow(currentPassword: enter)
            }
        }
    }
    
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        //三種情況
        if StorageManager.shared.fetchPassword() == nil { //沒有密碼
            if (1...3).contains(newPassword.count) { //設密碼（1-3個數字可以按刪除鍵）
                newPassword.removeLast()
                //改變上方點點狀態
                imageShow(currentPassword: newPassword)
                
            } else if confirmPassword.count != 0 { //confirmPassword階段
                confirmPassword.removeLast()
                //改變上方點點狀態
                imageShow(currentPassword: confirmPassword)
            }
        } else {
            if enter.count != 0 {
                enter.removeLast()
                //改變上方點點狀態
                imageShow(currentPassword: enter)
            }
        }
    }
    
    
   //判斷密碼輸入到第幾個並顯示圖片
    func imageShow(currentPassword: String) {
        switch currentPassword.count {
        case 1:
            fillImageView[0].isHidden = false

            for index in 1...3 {
                fillImageView[index].isHidden = true
            }
        case 2:
            for index in 0...3 {
                if index > 1 {
                    fillImageView[index].isHidden = true
                } else {
                    fillImageView[index].isHidden = false

                }
            }
        case 3:
            for index in 0...2 {
                fillImageView[index].isHidden = false

            }
                fillImageView[3].isHidden = true
        case 4:
            for index in 0...3 {
                fillImageView[index].isHidden = false
            }
            
            
            // 已設密碼
            if StorageManager.shared.fetchPassword() != nil {
                
                //檢查密碼是否正確
                checkPassword()
                
            } else { //未有密碼
                
                if confirmPassword.count == 4 { //去判斷是否等於newPassword
                    confirmNewPassword()
                } else { //要進入confirmPassword的階段
                    reset()
                    titleLabel.text = NSLocalizedString("confirmPassword", comment: "")
                    titleLabel.textAlignment = .center
                    titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
                    
                }
            }
            
        default:
            reset()
        }
    }
    
    
    
    func checkPassword () {
        if enter == StorageManager.shared.fetchPassword() {
            
            //reset畫面
            print("success")
            self.reset()
            //push(切換）到homePage

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as? TabBarViewController {
                tabBarVC.modalPresentationStyle = .fullScreen
                present(tabBarVC, animated: true)

            }
            
        } else {
            subtitleLabel.text = NSLocalizedString("passwordSubTitle", comment: "")
            subtitleLabel.textAlignment = .center
            subtitleLabel.font = UIFont.systemFont(ofSize: 15)
            subtitleLabel.textColor = .brown

            //reset畫面
            self.reset()
            subtitleLabel.isHidden = false
            subtitleLabel.text = NSLocalizedString("passwordSubTitle", comment: "")
            subtitleLabel.textColor = .brown
        }
    }

    
    func confirmNewPassword() {
        if confirmPassword == newPassword {
            
            //設定完成跳alert ("PIN has been set")
            let controller = UIAlertController(title: NSLocalizedString("settingAlert", comment: ""), message: NSLocalizedString("settingMessage", comment: ""), preferredStyle: .alert)
            let action = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { (_) in
                //寫入coreData
                StorageManager.shared.setPassword(newPasscode: self.newPassword)

                // 變回default
                self.newPassword = ""
                self.confirmPassword = ""

                //reset畫面
                self.reset()

                //跳回settingPage (用present的，所以要dismiss)
//                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true)
            }
            
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
            

        } else {
            subtitleLabel.text = NSLocalizedString("passwordSubTitle", comment: "")
            subtitleLabel.textAlignment = .center
            subtitleLabel.font = UIFont.systemFont(ofSize: 15)
            subtitleLabel.textColor = .brown
            
            // 變回default
            newPassword = ""
            confirmPassword = ""
            
            //reset畫面
            self.reset()
            
            //回到newPassword page （因為newPassword有清空，系統會知道現在要input newPassword)
            titleLabel.text = NSLocalizedString("passwordTitleNew", comment: "")
            
            //但還是要有錯誤訊息
            subtitleLabel.isHidden = false
            subtitleLabel.textAlignment = .center
            subtitleLabel.text = NSLocalizedString("passwordSubTitle", comment: "")
            subtitleLabel.textColor = .brown
        }
    }
    
    
    //密碼輸入完畢＆載入時，畫面會重置
    func reset() {
        //有圖案先關掉，放回原本圖案
        for index in 0...3 {
            fillImageView[index].isHidden = true
            badgeImageView[index].isHidden = false
        }
        enter = ""

        subtitleLabel.isHidden = true
    }
    
    
    //第一次設定PIN密碼("Enter your new PIN" / "Confirm your PIN") (左下加上exit鍵）
    //enter -> 打什麼都可以 / confirm -> 要跟enter的一模一樣 （錯的話要 subtitleLabel.text = "PIN does not match")
    //設定完成跳alert ("PIN has been set")

}
