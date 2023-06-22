//
//  moodContentView.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/22.
//

import SwiftUI
import Charts


//畫圖需要的data structure，資料需要存成這樣
struct MoodFlow {
    var date: Date //x軸
    var mood: String //y軸
}



struct moodContentView: View {
    
    //畫圖需要的資料，moodFlow的array
    var moodFlowArray: [MoodFlow] = []

    //把statisticsVC拿到的moodArray傳過來
    init(moodArray: [MoodFlow]) {
        moodFlowArray = moodArray
        
        // 將Array以日期排序，不然畫出來的圖會怪怪的（是按放的順序連線）
//        moodFlowArray = moodFlowArray.sorted(by: { $0.date < $1.date })
    }
    
    
    //swiftUI的骨幹，在這裡畫圖
    var body: some View {
        Chart {
          //for 過moodFlowArray，把日期和mood分別作為一個點的x值與y值
            ForEach(moodFlowArray, id: \.date) { item in
                LineMark(
                    x: .value("Date", item.date),
                    //mood要轉換成Int，系統才會幫忙排序心情
                    y: .value("Mood", Int(item.mood))
                )
                .symbol(.circle) //點的圖案類型
            }
        }
    }
}
