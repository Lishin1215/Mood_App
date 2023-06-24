//
//  StatisticsViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/20.
//

import UIKit
import SwiftUI
import FirebaseFirestore

class StatisticsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FireStoreManagerDelegate {
   
    

    //header
    let headerView = UIView()
    let dateLabel = UILabel()
    let historyButton = UIButton()
    
    //接收傳來的資料 (delegate)
    private var moodArray:[MoodFlow] = []
    private var sleepStartArray:[String] = []
    private var sleepEndArray:[String] = []
    private var sleepTimeArray: [String] = []
    
    //計算結果
    private var averageBedTime: String?
    private var averageWakeTime: String?
    private var averageSleepTime: String?
    
    //為避免加入swiftUI圖後重疊，先設置來default
    private var hostView: UIView = UIView()
    
    //cell裡面的，放外面是避免reload data時重複新的label(我只要一個就好）
    let bedTime = UILabel()
    let wakeTime = UILabel()
    let sleepTime = UILabel()
    
    let tableView = UITableView()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //delegate
        FireStoreManager.shared.delegate = self
        //fetchData （放這裡從tabBar進入才會一直走過）
        FireStoreManager.shared.fetchMonthlyData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate
//        FireStoreManager.shared.delegate = self

        tableView.dataSource = self
        tableView.delegate = self
        
        //register
        tableView.register(MoodFlowCell.self, forCellReuseIdentifier: MoodFlowCell.reuseIdentifier)
        tableView.register(SleepAnalysisCell.self, forCellReuseIdentifier: SleepAnalysisCell.reuseIdentifier)
        
        //        tableView.separatorStyle = .none
        view.addSubview(tableView)
        headerView.backgroundColor = .pinkOrange
        view.addSubview(headerView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    //header
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.14)
        ])
        
        //當月 (Date())
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, yyyy" // 指定日期格式
        let dateString = dateFormatter.string(from: date)
        dateLabel.text = dateString
        
        dateLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headerView.addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -30)
        ])
        
        //historyButton (看要不要跟dateLabel寫成一個stackView)
        historyButton.setImage(UIImage(named: "Icons_24px_DropDown"), for: .normal)
        historyButton.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
        headerView.addSubview(historyButton)
        
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            historyButton.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 5),
            historyButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -29)
        ])
        
    }
    
    
    
    
    @objc func historyButtonTapped(_ sender: UIButton) {
         print("hihi tapped")
    }

    func calculateAverageTime(timeStrings:[String]) -> String {
        
        //把00:00換成最接近24:00來計算
        var modifiedTimeStrings = timeStrings
        while let index = modifiedTimeStrings.firstIndex(of: "00:00") {
            modifiedTimeStrings[index] = "23:59"
        }
        //把時間string轉換成Date，才能做計算
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        var totalTimeInterval: TimeInterval = 0
        
        for timeString in modifiedTimeStrings {
            if let date = dateFormatter.date(from: timeString) {
                totalTimeInterval += date.timeIntervalSinceReferenceDate
            }
        }
        
        let averageTimeInterval = totalTimeInterval/Double(modifiedTimeStrings.count)
        let averageDate = Date(timeIntervalSinceReferenceDate: averageTimeInterval)
        let averageTimeString = dateFormatter.string(from: averageDate)
        print("$$$ +\(averageTimeString)")
        
        return averageTimeString
    }
    
    func calculateSleepTime(startArray: [String], endArray: [String]) -> [String] {
        // 檢查兩個陣列的元素數量是否相同
        guard startArray.count == endArray.count else {
            print("Start array and end array must have the same number of elements")
            return []
        }
        //把時間string轉換成Date，才能做計算
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        var sleepTimeArray: [String] = []
        
        for index in 0..<startArray.count {
            if let startDate = dateFormatter.date(from: startArray[index]),
               let endDate = dateFormatter.date(from: endArray[index]) {
                let sleepTime = endDate.timeIntervalSince(startDate) //endDate - startDate
//                let sleepTimeDate = Date(timeIntervalSinceReferenceDate: sleepTime)
//                let sleepTimeString = dateFormatter.string(from: sleepTimeDate)
                let sleepTimeString = String(format: "%.2f", sleepTime) //換成string 放到array
                print("&&& +\(sleepTimeString)")
                
                sleepTimeArray.append(sleepTimeString)
            }
        }
        return sleepTimeArray
    }
    
    
    
//conform to protocol
    func manager(_ manager: FireStoreManager, didGet articles: [[String : Any]]) {
        //empty array
        var moodFlowEmptyArray:[MoodFlow] = []
        var startEmptyArray:[String] = []
        var endEmptyArray:[String] = []
        
        for article in articles {
            //拿date & mood --> moodFlow
            if let timeStamp = article["date"] as? Timestamp {
                let date = timeStamp.dateValue() //型別:Date
                
                if let mood = article["mood"] as? String {
    
                    //以moodflow的資料結構，放入empty array中
                    let moodflow = MoodFlow(date: date, mood: mood)
                    moodFlowEmptyArray.append(moodflow)
                }
            }
            //拿sleepStart
            if let sleepStart = article["sleepStart"] as? String {
//                print("SleepStart: \(sleepStart)")
                
                startEmptyArray.append(sleepStart)
            }
            //拿sleepEnd
            if let sleepEnd = article["sleepEnd"] as? String {
//                print("SleepEnd: \(sleepEnd)")
                
                endEmptyArray.append(sleepEnd)
            }
        }
        print(startEmptyArray)
        print(endEmptyArray)
        
        //filter出空的string
        let filterStartArray = startEmptyArray.filter { !$0.isEmpty }
        print(filterStartArray)
        let filterEndArray = endEmptyArray.filter { !$0.isEmpty }
        print(filterEndArray)
        
        self.moodArray = moodFlowEmptyArray
        self.sleepStartArray = filterStartArray
        self.sleepEndArray = filterEndArray
        
        print(self.moodArray)
 
    
        //處理完資料後，call "moodContent swiftUI"，把畫圖資料傳過來
        let moodFlowSwiftUI = MoodContentView(moodArray: self.moodArray)
        //swiftUI提供結合UIKit(hostController
        let host = UIHostingController(rootView: moodFlowSwiftUI)
        //找到要放swiftUI的cell的indexPath
        let indexPath = IndexPath(row: 0, section: 0)
        
        //在外面設一個空的hostView, 在addSubview前先default，避免重疊
        self.hostView.removeFromSuperview()
        
        //**取得UIHostingController的view，再把他addSubview到對應的cell上
        if let hostView = host.view,
           let cell = tableView.cellForRow(at: indexPath) as? MoodFlowCell {
            self.hostView = hostView //給外面的hostView值
            cell.addSubview(hostView)
            
            //設定swiftUI constraints
            hostView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostView.topAnchor.constraint(equalTo: cell.containerView.topAnchor, constant: 16),
                hostView.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 16),
                hostView.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -16),
                hostView.bottomAnchor.constraint(equalTo: cell.containerView.bottomAnchor, constant: -5)
            ])
            
        }
        
        // 計算平均時間
        averageBedTime = calculateAverageTime(timeStrings: sleepStartArray)
        averageWakeTime = calculateAverageTime(timeStrings: sleepEndArray)
        
        let sleepTimeArray = calculateSleepTime(startArray: sleepStartArray, endArray: sleepEndArray)
        self.sleepTimeArray = sleepTimeArray
        
        averageSleepTime = calculateAverageTime(timeStrings: sleepTimeArray)
        
        //處理完資料後 reload tableView，更新label
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)//讓處理好的資料被放進去
        }
    }
    
    
//height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        } else {
            return 550
        }
    }
    
    
   
//MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MoodFlowCell.reuseIdentifier, for: indexPath) as?
                    MoodFlowCell
            else {fatalError("Could not create Cell")}
            
            
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SleepAnalysisCell.reuseIdentifier, for: indexPath) as? SleepAnalysisCell
            else {fatalError("Could not create Cell")}
            
            //Average label
            let bedTimeLabel = UILabel()
            let wakeTimeLabel = UILabel()
            let sleepTimelabel = UILabel()
            
            bedTimeLabel.text = "Average\nBedtime"
            bedTimeLabel.numberOfLines = 2
            bedTimeLabel.textAlignment = .center
            wakeTimeLabel.text = "Average\nWaking Time"
            wakeTimeLabel.numberOfLines = 2
            wakeTimeLabel.textAlignment = .center
            sleepTimelabel.text = "Average\nSleep"
            sleepTimelabel.numberOfLines = 2
            sleepTimelabel.textAlignment = .center
            bedTimeLabel.font = UIFont.systemFont(ofSize: 13)
            wakeTimeLabel.font = UIFont.systemFont(ofSize: 13)
            sleepTimelabel.font = UIFont.systemFont(ofSize: 13)
            bedTimeLabel.textColor = .lightGray
            wakeTimeLabel.textColor = .lightGray
            sleepTimelabel.textColor = .lightGray
            cell.containerView.addSubview(bedTimeLabel)
            cell.containerView.addSubview(wakeTimeLabel)
            cell.containerView.addSubview(sleepTimelabel)
            
            bedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
            wakeTimeLabel.translatesAutoresizingMaskIntoConstraints = false
            sleepTimelabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                bedTimeLabel.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 35),
                bedTimeLabel.bottomAnchor.constraint(equalTo: cell.containerView.bottomAnchor, constant: -30),
            ])
            NSLayoutConstraint.activate([
                wakeTimeLabel.centerXAnchor.constraint(equalTo: cell.containerView.centerXAnchor),
                wakeTimeLabel.bottomAnchor.constraint(equalTo: cell.containerView.bottomAnchor, constant: -30)
            ])
            NSLayoutConstraint.activate([
                sleepTimelabel.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -35),
                sleepTimelabel.bottomAnchor.constraint(equalTo: cell.containerView.bottomAnchor, constant: -30)
            ])
            
//            //TimeLabel
//            let bedTime = UILabel()
//            let wakeTime = UILabel()
//            let sleepTime = UILabel()
            
            //預設先拿掉TimeLabel，以免拿到資料後，更新會重複add (default)
            bedTime.removeFromSuperview()
            wakeTime.removeFromSuperview()
            sleepTime.removeFromSuperview()
            
            bedTime.text = averageBedTime ?? "00:00"
            wakeTime.text = averageWakeTime ?? "00:00"
            sleepTime.text = averageSleepTime ?? "00:00"
            bedTime.font = UIFont.boldSystemFont(ofSize: 18)
            wakeTime.font = UIFont.boldSystemFont(ofSize: 18)
            sleepTime.font = UIFont.boldSystemFont(ofSize: 18)
            bedTime.textColor = .darkGray
            wakeTime.textColor = .darkGray
            sleepTime.textColor = .darkGray
            cell.containerView.addSubview(bedTime)
            cell.containerView.addSubview(wakeTime)
            cell.containerView.addSubview(sleepTime)
            
            bedTime.translatesAutoresizingMaskIntoConstraints = false
            wakeTime.translatesAutoresizingMaskIntoConstraints = false
            sleepTime.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                bedTime.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 35),
                bedTime.centerYAnchor.constraint(equalTo: cell.containerView.centerYAnchor)
            ])
            NSLayoutConstraint.activate([
                wakeTime.centerXAnchor.constraint(equalTo: cell.containerView.centerXAnchor),
                wakeTime.centerYAnchor.constraint(equalTo: cell.containerView.centerYAnchor)
            ])
            NSLayoutConstraint.activate([
                sleepTime.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -35),
                sleepTime.centerYAnchor.constraint(equalTo: cell.containerView.centerYAnchor)
            ])
            
            
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SleepAnalysisCell.reuseIdentifier, for: indexPath) as? SleepAnalysisCell
            else {fatalError("Could not create Cell")}
            
            
            return cell
        }
    }

}
