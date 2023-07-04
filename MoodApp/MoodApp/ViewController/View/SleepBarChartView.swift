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
            Chart {
                ForEach(sleepTimeFlowArray, id: \.date) { item in
                    
                    //把sleepTime換成“小時”計算
                    let sleepTimeHours = (Double(item.sleepTime) ?? 0)/3600
                    //大、小於6小時判斷
                    let barColor: Color = sleepTimeHours > 6 ? Color(uiColor: .grassGreen): Color(uiColor: .orangeBrown)
                    
                    BarMark(
                        x: .value("Date", item.date),
                        y: .value("Sleep Time", sleepTimeHours) //把原本的秒換成“小時”
                    )
                    .foregroundStyle(barColor)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }

    }
}
