//
//  FireStoreManager.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/18.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class FireStoreManager {
    
    //singleton
    static let shared = FireStoreManager()
    
    func setData() {
        let db = Firestore.firestore()
        let ref = db.collection("articles").document()
        let id = ref.documentID
        
        let date = Date(timeIntervalSince1970: TimeInterval(NSDate().timeIntervalSince1970))
        
        //date ->日曆點選的那一天
        let articles = Articles(date: date, mood: "A", sleepStart: "B", sleepEnd: "C", text: "D", photo: "E")
        
        do {
            try db.collection("articles").document(id).setData(from: articles)
            
        } catch let error {
            print("Error writing article to FireStore: \(error)")
        }
    }
    
    func updateData() {
        let db = Firestore.firestore()
        let updateRef = db.collection("articles").document("09ahXKQg5JKLzku5WyPn")
        let date = Date(timeIntervalSince1970: TimeInterval(NSDate().timeIntervalSince1970))

        updateRef.updateData([
            "date": date,
            "mood": "1",
            "sleepStart": "2",
            "sleepEnd": "3",
            "text": "4",
            "photo": "5"
            
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func fetchData() {
        let db = Firestore.firestore()
        let collectionRef = db.collection("articles")

        // 使用 collectionRef 讀取集合中的所有文件
        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let documents = querySnapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        print("-------------------------")
                        print(data)
                        // 在此處處理每個文件的資料
                        // 例如，從 data 字典中擷取所需的欄位值
                        if let date = data["date"] as? Timestamp {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let dateString = dateFormatter.string(from: date.dateValue())
                            print("Date: \(dateString)")
                        }
                       
                        if let mood = data["mood"] as? String {
                            print("Mood: \(mood)")
                        }
                        if let photo = data["photo"] as? String {
                            print("Photo: \(photo)")
                        }
                        if let sleepStart = data["sleepStart"] as? String {
                            print("SleepStart: \(sleepStart)")
                        }
                        if let sleepEnd = data["sleepEnd"] as? String {
                            print("SleepEnd: \(sleepEnd)")
                        }
                        
                    }
                }
            }
        }
    }

}
