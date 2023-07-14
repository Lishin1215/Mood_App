//
//  UIViewController+Extension.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/7/14.
//

import UIKit

extension UIViewController {
    
    
    func showAlert(title: String, message: String?, completion: (() -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { _ in
            
            //關閉alert的執行動作
            completion?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
