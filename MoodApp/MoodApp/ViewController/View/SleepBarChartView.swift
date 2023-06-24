//
//  SleepBarChartView.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/23.
//

import SwiftUI
import Charts


//畫圖需要的data structure，資料需要存成這樣
struct SleepTimeFlow {
    var date: Date //x軸
    var sleepTime: String //y軸
}



struct SleepBarChartView: View {

    //畫圖需要的資料，sleepTimeFlowArray的array
    var sleepTimeFlowArray: [SleepTimeFlow] = []

    //***把statisticsVC拿到的sleepTimeFlowArray傳過來
    init(sleepTimeFlowArray: [SleepTimeFlow]) {
        self.sleepTimeFlowArray = sleepTimeFlowArray
    }
    
    
    var body: some View {
        VStack {
            // 繪製 Bar Chart
            VStack {
                ForEach(sleepTimeFlowArray, id: \.date) { item in
                    VStack {
                        Text(String(format: "%.1f", item.sleepTime)) // 顯示睡眠時間
                        Rectangle()
                            .fill(Color.blue)
                            .frame(height: CGFloat((Int(item.sleepTime) ?? 0) * 10)) // 設定柱狀圖高度
                            .cornerRadius(5)
                    }
                }
            }
        }
    }
}
