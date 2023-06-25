//
//  RecordMoodIntentHandler.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/25.
//

import Foundation
import Intents

class RecordMoodIntentHandler: NSObject, RecordMoodIntentHandling {
    
    //正確接收到intent後執行
    func handle(intent: RecordMoodIntent, completion: @escaping (RecordMoodIntentResponse) -> Void) {
        print(intent.MoodScore)
        completion(RecordMoodIntentResponse.success(result: "Successfully"))
    }
    
  
    func resolveMoodScore(for intent: RecordMoodIntent, with completion: @escaping (RecordMoodMoodScoreResolutionResult) -> Void) {
        let moodScore = Int(intent.MoodScore ?? 5)
        if(0...4).contains(moodScore) {
            completion(RecordMoodMoodScoreResolutionResult.success(with: moodScore))
        } else {
            completion(RecordMoodMoodScoreResolutionResult.needsValue()) //要求users再輸入
        }
    }
    
   
}

