//
//  PasswordViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/26.
//

import UIKit

class PasswordViewController: UIViewController {

    private var enter: String = ""
//    private var newPassword: String = ""
    
    @IBOutlet var numButtonArray: [UIButton]!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var badgeImageView: [UIImageView]!
    @IBOutlet var fillImageView: [UIImageView]!
    @IBOutlet var deleteButton: UIButton!
    
    @IBOutlet weak var colorImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "Enter PIN"
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
        //if（未設密碼）StorageManager.shared.fetchPassword == nil
        // 按完四個字，先存到某個變數裡 newPassword.append(enter)/imageShow()
        if enter.count != 4 {
            if let inputNumber = sender.currentTitle {
                //字串相加
//                newPassword.append(inputNumber)
            }
        }
        imageShow()
        
        // 按完四個字，confirmNewPassword()
        // 第一次不用，第二次才需要
        
        
        //else 一般狀況進入(已設密碼）（跳出app後再進來）
        //密碼長度不等於4
        if enter.count != 4 {
            if let inputNumber = sender.currentTitle {
                //字串相加
                enter.append(inputNumber)
            }
        }
        imageShow()
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        //有東西就可以delete
        if enter.count != 0 {
            enter.removeLast()
        }
        //改變上方點點狀態
        imageShow()
    }
    
    
   //判斷密碼輸入到第幾個並顯示圖片
    func imageShow() {
        switch enter.count {
        case 1:
            fillImageView[0].isHidden = false
            badgeImageView[0].isHidden = true
            for index in 1...3 {
                fillImageView[index].isHidden = true
            }
        case 2:
            for index in 0...3 {
                if index > 1 {
                    fillImageView[index].isHidden = true
                } else {
                    fillImageView[index].isHidden = false
                    badgeImageView[index].isHidden = true
                }
            }
        case 3:
            for index in 0...2 {
                fillImageView[index].isHidden = false
                badgeImageView[index].isHidden = true
            }
                fillImageView[3].isHidden = true
        case 4:
            for index in 0...3 {
                fillImageView[index].isHidden = false
            }
            
            //if (已設密碼）StorageManager.shared.fetchPassword != nil
            //檢查密碼是否正確
//            checkPassword()
            
            //else reset()
            //titleLabel.text = "Confirm your PIN"
        default:
            reset()
        }
    }
    
    
    
//    func checkPassword () {
//        if enter == password {
//            //perform segue到homePage
//
//            //reset畫面
//            self.reset()
//        } else {
//            subtitleLabel.text = "PIN does not match"
//    subtitleLabel.textAlignment = .center
//            subtitleLabel.font = UIFont.systemFont(ofSize: 15)
//
//            //reset畫面
//            self.reset()
//            subtitleLabel.isHidden = false
//            subtitleLabel.text = "PIN does not match"
//        }
//    }
//
    
//    func confirmNewPassword() {
//        if enter == newPassword {
//            //設定完成跳alert ("PIN has been set")
//
//              //寫入coreData
//                StorageManager.shared.setPassword
//
//            //newPassword = "" (變回default)
//
//            //reset畫面
//            self.reset()
//
            //跳回settingPage
//
//
//        } else {
//            subtitleLabel.text = "PIN does not match"
//            subtitleLabel.font = UIFont.systemFont(ofSize: 15)
//
//            //reset畫面
//            self.reset()
//            //但還是要有錯誤訊息
//            subtitleLabel.isHidden = false
//            subtitleLabel.text = "PIN does not match"
//        }
//    }
    
    
    //密碼輸入完畢＆載入時，畫面會重置
    func reset() {
        //有圖案先關掉
        for index in 0...3 {
            fillImageView[index].isHidden = true
        }
        enter = ""
        titleLabel.text = "Enter PIN"
        subtitleLabel.isHidden = true
    }
    
    
    //第一次設定PIN密碼("Enter your new PIN" / "Confirm your PIN") (左下加上exit鍵）
    //enter -> 打什麼都可以 / confirm -> 要跟enter的一模一樣 （錯的話要 subtitleLabel.text = "PIN does not match")
    //設定完成跳alert ("PIN has been set")

}
