//
//  FireStoreManager.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/18.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

protocol FireStoreManagerDelegate: AnyObject {

    func manager(_ manager: FireStoreManager, didGet articles: [[String: Any]])
}


class FireStoreManager {
    
    //singleton
    static let shared = FireStoreManager()
    
    //delegate
    var delegate: FireStoreManagerDelegate?
    
    
    //確定資料有上傳，才會觸發 handler closure
    func setData(date: Date, mood: String, sleepStart: String, sleepEnd: String, text: String, photo: String, handler: @escaping () -> Void) {
        let db = Firestore.firestore()
        let ref = db.collection("users").document("123").collection("articles")  //id會隨user改變
//        let id = ref.documentID
        
//        let date = Date(timeIntervalSince1970: TimeInterval(NSDate().timeIntervalSince1970))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        //date ->日曆點選的那一天
        let articles = Articles(date: date, mood: mood, sleepStart: sleepStart, sleepEnd: sleepEnd, text: text, photo: photo)
        
        do {
            try ref.document(dateString).setData(from: articles, completion: { _ in
                
                handler() //fetchData(才會確定有拿到上傳的資料）(會觸發delegate把資料傳回homeVC)
            })
            
        } catch let error {
            print("Error writing article to FireStore: \(error)")
        }
    }
    
    
    func updateData() {
        let db = Firestore.firestore()
        let updateRef = db.collection("users").document("123").collection("articles").document("09ahXKQg5JKLzku5WyPn")
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
        let collectionRef = db.collection("users").document("123").collection("articles")  //db.collection("articles")

        // 使用 collectionRef 讀取集合中的所有文件
        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let documents = querySnapshot?.documents {
                    
                    var emptyArray: [[String:Any]] = []
                    
                    
                    
                    for document in documents {
                        let data = document.data()
//                        print("-------------------------")
//                        print(data)
                        
                
                        
                        // 在此處處理每個文件的資料
                        // 例如，從 data 字典中擷取所需的欄位值
                        if let date = data["date"] as? Timestamp {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let dateString = dateFormatter.string(from: date.dateValue())
                            print("Date: \(dateString)")
                        }
                       
//                        if let mood = data["mood"] as? String {
//                            print("Mood: \(mood)")
//                        }
//                        if let photo = data["photo"] as? String {
//                            print("Photo: \(photo)")
//                        }
//                        if let sleepStart = data["sleepStart"] as? String {
//                            print("SleepStart: \(sleepStart)")
//                        }
//                        if let sleepEnd = data["sleepEnd"] as? String {
//                            print("SleepEnd: \(sleepEnd)")
//                        }
                        emptyArray.append(data)
                    }
                    //delegate //資料全部拿到後再傳
                    self.delegate?.manager(self, didGet: emptyArray)
                }
            }
        }
    }
    
//statisticPage & lookBackPage要用到
    func fetchMonthlyData() {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users").document("123").collection("articles")
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: currentDate))),
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)
        else {
            print("Failed to calculate start and end of month")
            return
        }
        
        let query = collectionRef.whereField("date", isGreaterThanOrEqualTo: startOfMonth).whereField("date", isLessThanOrEqualTo: endOfMonth)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let documents = querySnapshot?.documents {
                    var emptyArray:[[String:Any]] = []
                    
                    for document in documents {
                        let data = document.data()
                        print("-------------------")
                        print(data)
                        
                        emptyArray.append(data)
                    }
                    //delegate//資料全部拿到後再傳
                    self.delegate?.manager(self, didGet: emptyArray)
                }
            }
        }
        
    }

    //listener監聽
    
}
