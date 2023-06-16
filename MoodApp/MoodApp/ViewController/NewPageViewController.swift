//
//  NewPageViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/16.
//

import UIKit

class NewPageViewController: UIViewController {

    //傳過來的日期
    var dateComponents: DateComponents?
    
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

        
        
    }
    

    
}
