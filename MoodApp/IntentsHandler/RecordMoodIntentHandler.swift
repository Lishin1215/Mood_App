//
//  RecordMoodIntentHandler.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/25.
//

import Foundation
import Intents
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

class RecordMoodIntentHandler: NSObject, RecordMoodIntentHandling {
    
    override init() {
        super.init()
        FirebaseApp.configure()
        
        
    }
    
    
    
    
    //正確接收到intent後執行
    func handle(intent: RecordMoodIntent, completion: @escaping (RecordMoodIntentResponse) -> Void) {
        print(intent.MoodScore)
//        completion(RecordMoodIntentResponse.success(result: "Successfully"))
        
        
        if let keyChainGroup = Bundle.main.infoDictionary?["KeyChainGroup"] as? String {
            
            do {
                try Auth.auth().useUserAccessGroup(keyChainGroup)
                
            } catch let error as NSError {
                print("Error changing user access group: %@", error)
            }
        } else {
            print("KeyChainGroup is nil")
        }
        
        
        
        if let currentUser = Auth.auth().currentUser{
            print("already log in")
            let uid = currentUser.uid
            print(uid)
            //把登入後的credential(uid)放入userId
            FireStoreManager.shared.setUserId(userId: uid)
        }
        

        // update data (只改mood)（直接從update裡判斷是否已填過當日資料）
        // 減1 --> 讓mood index維持在 0-4
        FireStoreManager.shared.updateData(mood: String(Int(intent.MoodScore ?? 1)-1)) {
            
            //***確定上傳之後再結束（siri)程式
            completion(RecordMoodIntentResponse.success(result: "Successfully"))
        }
    }
    
  // 判斷使用者說出的數字
    func resolveMoodScore(for intent: RecordMoodIntent, with completion: @escaping (RecordMoodMoodScoreResolutionResult) -> Void) {
        let moodScore = Int(intent.MoodScore ?? 1)
        print(moodScore)
        if(1...5).contains(moodScore) {
            completion(RecordMoodMoodScoreResolutionResult.success(with: moodScore))
        } else {
            completion(RecordMoodMoodScoreResolutionResult.needsValue()) //要求users再輸入
        }
    }
    
   
}

