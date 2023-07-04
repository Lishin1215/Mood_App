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
        completion(RecordMoodIntentResponse.success(result: "Successfully"))
        
        do {
            try Auth.auth().useUserAccessGroup("Janet.MoodApp.auth")
        } catch let error as NSError {
            print("Error changing user access group: %@", error)
        }
        
        
        if let currentUser = Auth.auth().currentUser{
            print("already log in")
            let uid = currentUser.uid
            print(uid)
            //把登入後的credential(uid)放入userId
            FireStoreManager.shared.setUserId(userId: uid)
        }
        
        FireStoreManager.shared.setData(date: Date(), mood: String(Int(intent.MoodScore ?? 5)), sleepStart: "", sleepEnd: "", text: "", photo: "", handler: {})
        
        //update data (只改mood)
//        FireStoreManager.shared.updateData(mood: String(Int(intent.MoodScore ?? 0)))
    }
    
  
    func resolveMoodScore(for intent: RecordMoodIntent, with completion: @escaping (RecordMoodMoodScoreResolutionResult) -> Void) {
        let moodScore = Int(intent.MoodScore ?? 5)
        print(moodScore)
        if(0...4).contains(moodScore) {
            completion(RecordMoodMoodScoreResolutionResult.success(with: moodScore))
        } else {
            completion(RecordMoodMoodScoreResolutionResult.needsValue()) //要求users再輸入
        }
    }
    
   
}

