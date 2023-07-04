//
//  MoodContentView.swift
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



struct MoodContentView: View {
    
//畫圖需要的資料，moodFlow的array
    var moodFlowArray: [MoodFlow] = []
    //x軸日期標點
    var startOfMonth: Date = Date() //月的第一天，作為x軸的頭
    var endOfMonth: Date = Date() //月的最後一天
    var monthLabelArray: [Date] = []
    
//用來將date轉換成"xx/xx"的形式
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }()
    

//***把statisticsVC拿到的moodArray傳過來
    init(moodArray: [MoodFlow]) {
        moodFlowArray = moodArray
        
        // 將Array以日期排序，不然畫出來的圖會怪怪的（是按放的順序連線）
//        moodFlowArray = moodFlowArray.sorted(by: { $0.date < $1.date })
        
        // 從moodFlowArray的Date中，去確認圖表要用到哪個月份
        startOfMonth = moodFlowArray[0].date.startDateOfMonth //該月第一天
        endOfMonth = moodFlowArray[0].date.endDateOfMonth //該月最後一天
        
        //從startOfMonth到endOfMonth為止，產生一個間隔為5天的array (3600秒 * 24小時 * 5天）
        monthLabelArray = Array(stride(from: startOfMonth, to: endOfMonth, by: 3600 * 24 * 5))
        
    
    }
    
    
    //swiftUI的骨幹，在這裡畫圖
    var body: some View {
        Chart {
          //for 過moodFlowArray，把日期和mood分別作為一個點的x值與y值
            //id -> 識別和區分的“資料點” （要放入不會重複的東西(ex.date))
            ForEach(moodFlowArray, id: \.date) { item in
                LineMark(
                    x: .value("Date", item.date),
                    //mood要轉換成Int，系統才會幫忙排序心情
                    y: .value("Mood", Int(item.mood) ?? 0)
                )
                .symbol(.circle) //點的圖案類型
                .foregroundStyle(Color(uiColor: .orangeBrown))
            }
        }
        // y軸
        .chartYAxis {
            AxisMarks(position: .leading, values: [0,1,2,3,4]) //讓y軸固定5個值
        }
        .chartYScale(domain: 0...4) //限制y軸範圍
        
        // x軸
        .chartXAxis {
            
            //利用monthLabelArray作為x軸label，並把date轉換成"xx/xx"的形式
            AxisMarks(values: monthLabelArray) { value in
                
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        VStack(alignment: .leading) {
                            Text(date, formatter: dateFormatter)
                        }
                    }
                }
                
                AxisGridLine() //網格線
                AxisTick() //標點
            }
        }
        
    }
}
