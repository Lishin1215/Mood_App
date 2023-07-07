//
//  KingFisherWrapper.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/22.
//

import UIKit
import Kingfisher


// 定義一個 UIImageView 的 extension
extension UIImageView {
    
    // 定義一個設置圖片的方法，這裡使用了 Kingfisher 框架來下載圖片並緩存
    func addImage(with url: URL?) {
        // 使用 Kingfisher 提供的方法來下載圖片
        self.kf.setImage(with: url)
    }
    
}


extension UIButton {
    
    // 定義一個設置圖片的方法，這裡使用了 Kingfisher 框架來下載圖片並緩存
    func addImage(with url: URL?) {
        // 使用 Kingfisher 提供的方法來下載圖片
        self.kf.setImage(with: url, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
    }
    
}

extension UIImage {
    
    //photo: [String] -> [UIImage]
    static func createImageArray(from photoArray: [String], completion: @escaping([UIImage]) -> Void) {
         
        var images: [UIImage] = []
        
        let dispatchGroup = DispatchGroup()
        
        for photoURLString in photoArray {
            dispatchGroup.enter()
            
            if let photoURL = URL(string: photoURLString) {
                
                let imageView = UIImageView()
                
                imageView.kf.setImage(with: photoURL) { result in
                    
                    switch result {
                    case .success(let imageResult):
                        images.append(imageResult.image)
                        
                    case .failure(let error):
                        print("Failed to load image: \(error)")
                    }
                    
                    dispatchGroup.leave()
                }
            } else {
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(images)
        }
    }
}
