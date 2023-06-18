//
//  FireBaseStorageManager.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/18.
//

import UIKit
import FirebaseStorage

class FireBaseStorageManager {
    
    static let shared = FireBaseStorageManager()
    
    func uploadPhoto(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
            
            let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
            if let data = image.jpegData(compressionQuality: 0.9) {
                
                fileReference.putData(data, metadata: nil) { result in
                    switch result {
                    case .success:
                         fileReference.downloadURL(completion: completion)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
    }
}
