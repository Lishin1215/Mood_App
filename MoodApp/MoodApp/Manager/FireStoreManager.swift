//
//  FireStoreManager.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/18.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

protocol FireStoreManagerDelegate: AnyObject {

    func manager(_ manager: FireStoreManager, didGet articles: [[String: Any]])
}


class FireStoreManager {
    
    //singleton
    static let shared = FireStoreManager()
    
    //delegate
    var delegate: FireStoreManagerDelegate?
    
    //apple login
    var userId: String = ""
    
    
    
    func setUserId(userId: String) {
        self.userId = userId // 把登入後的credential放入userId
        
    }
    
    
    //確定資料有上傳，才會觸發 handler closure
    func setData(date: Date, mood: String, sleepStart: String, sleepEnd: String, text: String, photo: String, handler: @escaping () -> Void) {
        
        
        let db = Firestore.firestore()
        let ref = db.collection("users").document(userId).collection("articles")  //id會隨user改變
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
    
   //Siri走這條
    func updateData(mood: String, completion: @escaping (()-> Void)) {
        let db = Firestore.firestore()
        let updateRef = db.collection("users").document(userId).collection("articles")
        
        let date = Date() //siri會用到這個function，而siri只能寫入“當日”心情（寫死ok)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        

        updateRef.document(dateString).getDocument { (document, error) in
            if let document = document{
                //判斷是否已“填入” （已填 -> update/ 未填 -> set)
                if document.exists {
                    updateRef.document(dateString).updateData([
                        "mood": mood

                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                            //***確定上傳之後再結束（siri)程式
                            completion()
                        }
                    }
                //未填過
                } else {
                    FireStoreManager.shared.setData(date: Date(), mood: mood, sleepStart: "", sleepEnd: "", text: "", photo: "", handler: {completion()})
                }
            }
            print(error)
        

        }
        
        
    }
    
    //newPage --> 拿全部資料跟selectedDate去對照，看當天是否有填寫過了
    func fetchData() {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users").document(userId).collection("articles")  //db.collection("articles")
        
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
                        
                        
                        emptyArray.append(data)
                    }
                    //delegate //資料全部拿到後再傳
                    self.delegate?.manager(self, didGet: emptyArray)
                }
            }
        }
    }
    
    //statisticPage/ lookBackPage/ homeVC / newPageVC 要用到
    func fetchMonthlyData(dateString: String) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users").document(userId).collection("articles")
        
        let calendar = Calendar.current
        let currentDate = Date()
        var dateComponents = DateComponents()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, yyyy"
        
        //String轉成Date
        if let date = dateFormatter.date(from: dateString) {
            //再轉成dateComponents，去找“當月的1號”
            dateComponents = calendar.dateComponents([.year, .month], from: date)
            dateComponents.day = 1 //設置日期為1號
        } else {
            print("Invalid date string")
        }
        
        //從dateComponent再轉成Date，去fireStore拿資料
        guard let startOfMonth = calendar.date(from: dateComponents),
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
                        //                        print(data)
                        
                        emptyArray.append(data)
                    }
                    //delegate//資料全部拿到後再傳
                    self.delegate?.manager(self, didGet: emptyArray)
                }
            }
        }
        
    }
    
    // newPage要用到
    func fetchMonthlyData(inputDate: Date) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users").document(userId).collection("articles")
        
        let calendar = Calendar.current
        
        //用extension去抓
        let startOfMonth = inputDate.startDateOfMonth
        let endOfMonth = inputDate.endDateOfMonth
        
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
                        //                        print(data)
                        
                        emptyArray.append(data)
                    }
                    //delegate//資料全部拿到後再傳
                    self.delegate?.manager(self, didGet: emptyArray)
                }
            }
        }
    }
    
    
    // homePage要用到
    func fetchMultipleMonth(fromDate: Date, toDate: Date) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users").document(userId).collection("articles")
        
        let calendar = Calendar.current
        
        //用extension去抓
        let startOfMonth = fromDate.startDateOfMonth
        let endOfMonth = toDate.endDateOfMonth
        
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
                        //                        print(data)
                        
                        emptyArray.append(data)
                    }
                    //delegate//資料全部拿到後再傳
                    self.delegate?.manager(self, didGet: emptyArray)
                }
            }
        }
        
    }
    
    
    
    //listener監聽
    
    
    // delete userId
    func deleteData(handler: @escaping () -> Void) {
        let db = Firestore.firestore()
        let ref = db.collection("users").document(userId).collection("articles").getDocuments { snapshop, _ in
            snapshop?.documents.forEach {
                $0.reference.delete()
            }
        }
        let refDoc = db.collection("users").document(userId)
        
        
        refDoc.delete(completion: { (error) in
            if let err = error {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
            handler()
        })
    }
    
}

extension Date {
    
    var startDateOfMonth: Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self)) else {
            fatalError("Unable to get start date from date")
        }
        return date
    }

    var endDateOfMonth: Date {
        guard let date = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startDateOfMonth) else {
            fatalError("Unable to get end date from date")
        }
        return date
    }
}
//    //delete "document" & "subcollections
//    func deleteDocumentAndSubcollections(completion: @escaping (Error?) -> Void) {
//        let db = Firestore.firestore()
//        let documentRef = db.collection("users").document(userId)
//
//        // 刪除文件本身
//        documentRef.delete { error in
//            if let error = error {
//                completion(error)
//                return
//            }
//
//            // 遞迴刪除子集合
//            self.deleteSubcollections(collectionPath: "articles", documentRef: documentRef) { subcollectionError in
//                completion(subcollectionError)
//            }
//        }
//    }
//
//    func deleteSubcollections(collectionPath: String, documentRef: DocumentReference, completion: @escaping (Error?) -> Void) {
//        documentRef.collection(collectionPath).getDocuments { querySnapshot, error in
//            guard let querySnapshot = querySnapshot else {
//                completion(error)
//                return
//            }
//
//            let batch = documentRef.firestore.batch()
//
//            for document in querySnapshot.documents {
//                let documentRef = documentRef.collection(collectionPath).document(document.documentID)
//                batch.deleteDocument(documentRef)
//            }
//
//            batch.commit { batchError in
//                completion(batchError)
//            }
//        }
//    }

