//
//  PasswordViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/26.
//

import UIKit

class PasswordViewController: UIViewController {

    var enter: String = ""
    
    @IBOutlet var numButtonArray: [UIButton]!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var badgeImageView: [UIImageView]!
    @IBOutlet var fillImageView: [UIImageView]!
    @IBOutlet var deleteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "Enter PIN"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        subtitleLabel.isHidden = true
       
    }
    

    //輸入的字串相加
    @IBAction func enterPassword(_ sender: UIButton) {
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
            //檢查密碼是否正確
            checkPassword()
        default:
            reset()
        }
    }
    
    
    func checkPassword () {
        if enter == password {
            //perform segue到homePage

            //reset畫面
            self.reset()
        } else {
            subtitleLabel.text = "PIN does not match"
            subtitleLabel.font = UIFont.systemFont(ofSize: 15)

            //reset畫面
            self.reset()
            subtitleLabel.isHidden = false
            subtitleLabel.text = "PIN does not match"
        }
    }
    
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
    

}
