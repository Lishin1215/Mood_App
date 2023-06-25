//
//  RecordMoodIntentHandler.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/25.
//

import Foundation
import Intents

class RecordMoodIntentHandler: NSObject, RecordMoodIntentHandling {
    func handle(intent: RecordMoodIntent, completion: @escaping (RecordMoodIntentResponse) -> Void) {
        print(intent.moodScore)
    }
    
    func handle(intent: RecordMoodIntent) async -> RecordMoodIntentResponse {
        <#code#>
    }
    
    func resolveMoodScore(for intent: RecordMoodIntent, with completion: @escaping (RecordMoodMoodScoreResolutionResult) -> Void) {
        <#code#>
    }
    
    func resolveMoodScore(for intent: RecordMoodIntent) async -> RecordMoodMoodScoreResolutionResult {
        <#code#>
    }
    
    
}

