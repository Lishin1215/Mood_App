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
                    BarMark(
                        x: .value("Date", item.date),
                        y: .value("Sleep Time", (Double(item.sleepTime) ?? 0 )/3600) //把原本的秒換成“小時”
                    )
                    .foregroundStyle(Color(uiColor: .orangeBrown))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
//            .chartXAxis {
//                AxisMarks(values: .stride(by: .day)) { value in
//                    AxisValueLabel(format: .dateTime.month(), centered: true)
//                }
//            }
    }
}
