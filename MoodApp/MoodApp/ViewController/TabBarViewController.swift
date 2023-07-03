//
//  TabBarViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/15.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tabBar.items?[0].title = NSLocalizedString("tab0", comment: "")
        self.tabBar.items?[1].title = NSLocalizedString("tab1", comment: "")
        self.tabBar.items?[3].title = NSLocalizedString("tab3", comment: "")
        self.tabBar.items?[4].title = NSLocalizedString("tab4", comment: "")
        
        
    }
    

}
