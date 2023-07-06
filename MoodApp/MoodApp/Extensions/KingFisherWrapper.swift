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
    
    //用在image變成video的部分
    func addPhoto(with url: URL?, completion: @escaping(Result<UIImage, Error>) -> Void) {
        
        self.kf.setImage(with: url) { result in
            
            switch result {
            case .success(let imageResult):
                completion(.success(imageResult.image))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
