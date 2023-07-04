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
    //x軸所需
    var startOfMonth: Date = Date()
    var endOfMonth: Date = Date()
    var monthLabelArray:[Date] = []

    
    //用來將date轉換成"xx/xx"的形式
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }()
    
    
    //***把statisticsVC拿到的sleepTimeFlowArray傳過來
    init(sleepTimeFlowArray: [SleepTimeFlow]) {
        self.sleepTimeFlowArray = sleepTimeFlowArray
        
        startOfMonth = sleepTimeFlowArray[0].date.startDateOfMonth
        endOfMonth = sleepTimeFlowArray[0].date.endDateOfMonth
        
        monthLabelArray = Array(stride(from: startOfMonth, to: endOfMonth, by: 3600 * 24 * 5))
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
                
                //加一條 6hrs 的虛線 （月初到月底）
                RuleMark(
                    xStart: .value("Start", startOfMonth),
                    xEnd: .value("End", endOfMonth),
                    y: .value("Value", 6)
                )
                .lineStyle(StrokeStyle(lineWidth: 2, dash: [2]))
            }
        
        
            // y軸
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        
            // x軸
            .chartXAxis {
                
                //利用monthLabelArray作為x軸label
                AxisMarks(values: monthLabelArray) { value in
                    
                    //並把date轉換成"xx/xx"的形式
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
