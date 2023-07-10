//
//  StatisticsViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/20.
//

import UIKit
import SwiftUI
import FirebaseFirestore

class StatisticsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FireStoreManagerDelegate, PopUpViewDelegate
{
   
    
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
    
    //swiftUI struct
    private var sleepTimeFlowArray: [SleepTimeFlow] = []
    
    //為避免加入swiftUI圖後重疊，先設置來default
    private var hostView: UIView = UIView()
    private var sleepHostView: UIView = UIView()
    
    //創一個PopUp View加在上面 (delegate)
    let popUpView = PopUpMonthView()
    
    //cell裡面的，放外面是避免reload data時重複新的label(我只要一個就好）
    let bedTime = UILabel()
    let wakeTime = UILabel()
    let sleepTime = UILabel()
    
    //黑屏
    let blackView = UIView(frame: UIScreen.main.bounds)
    
    
    let tableView = UITableView()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //delegate
        FireStoreManager.shared.delegate = self
        popUpView.delegate = self
        //fetchData （放這裡從tabBar進入才會一直走過）
        FireStoreManager.shared.fetchMonthlyData(dateString: dateLabel.text ?? "")
        
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    //header
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.14)
        ])
        
        //share button
        let shareButton = UIButton()
        let shareImage = UIImage(systemName: "square.and.arrow.up")?.withRenderingMode(.alwaysTemplate)
        shareButton.setImage(shareImage, for: .normal)
        shareButton.tintColor = .lightBlack
        
//        let barButton = UIBarButtonItem(customView: shareButton)
//        navigationItem.rightBarButtonItem = barButton
        headerView.addSubview(shareButton)

        
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            shareButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -30)
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
    
    @objc func shareButtonTapped(_ sender: UIButton) {
        print("sha sha sha")
        
        //把cell做成圖片(convert UIView to .png)
        //Mood Flow
        var moodWritePath = URL(string: "")
        let moodIndexPath = IndexPath(row: 0, section: 0)
        
        if let moodCell = self.tableView.cellForRow(at: moodIndexPath) as? MoodFlowCell {
            
            UIGraphicsBeginImageContextWithOptions(moodCell.layer.frame.size, false, 1) //Begin
            //將moodCell渲染到current context
            moodCell.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            if let viewImage = UIGraphicsGetImageFromCurrentImageContext() { //變成image了
                UIGraphicsEndImageContext() //End
                
                
                //創建“資料夾的路徑”
                let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                moodWritePath = documentsDir.appendingPathComponent("mood.png")
                
                do {
                    //把viewImage寫入path
                    if let imageData = viewImage.pngData() {
                        try imageData.write(to: moodWritePath!)
                        print("Saved image to: ", moodWritePath)
                    }
                   
                } catch {
                    print("Could not remove file")
                }
            } else {
                print("Failed to get image from context")
            }
        }
        
        //Sleep Analysis
        var sleepWritePath = URL(string: "")
        let sleepIndexPath = IndexPath(row: 1, section: 0)
        
        if let sleepCell = self.tableView.cellForRow(at: sleepIndexPath) as? SleepAnalysisCell {

            UIGraphicsBeginImageContextWithOptions(sleepCell.layer.frame.size, false, 1) // 1 = scale
            sleepCell.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            if let viewImage = UIGraphicsGetImageFromCurrentImageContext() { //變成image了
                UIGraphicsEndImageContext() //End
                
                
                //創建“資料夾的路徑”
                let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                sleepWritePath = documentsDir.appendingPathComponent("sleep.png")
                
                do {
                    //把viewImage寫入path
                    if let imageData = viewImage.pngData() {
                        try imageData.write(to: sleepWritePath!)
                        print("Saved image to: ", sleepWritePath)
                    }
                   
                } catch {
                    print("Could not remove file")
                }
            } else {
                print("Failed to get image from context")
            }
        }

        
        let activityVC = UIActivityViewController(activityItems: [moodWritePath, sleepWritePath], applicationActivities: nil)

        activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
               // 跳alert
               if error != nil {
                   let controller = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: nil, preferredStyle: .alert)
                   let action = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { _ in
                       //關閉alert的執行動作
                   }
                   controller.addAction(action)
                   self.present(controller, animated: true)
               }
                                                    
               // 如果發送成功，跳出提示視窗顯示成功。
               if completed {
                   let controller = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: nil, preferredStyle: .alert)
                   let action = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { _ in
                       //關閉alert的執行動作
                   }
                   controller.addAction(action)
                   self.present(controller, animated: true)
               }

           }
//        activityVC.popoverPresentationController?.sourceView = view
//        activityVC.popoverPresentationController?.sourceRect = view.frame

           self.present(activityVC, animated: true, completion: nil)
    }
    
    
    @objc func historyButtonTapped(_ sender: UIButton) {
        
        //跳出黑屏
        blackView.backgroundColor = .black
        blackView.alpha = 0 //淡入的動畫效果
        view.addSubview(blackView)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0) {
            self.blackView.alpha = 0.5
        }
        //tabbar 收起來
        tabBarController?.tabBar.isHidden = true
        
        //跳出畫面
        showPopUpMonthView()
        
        //此時先把closure傳到popUpView
        setDismissClosure(popView: popUpView)
    }
    
    
    func showPopUpMonthView() {
        
        view.addSubview(popUpView)
        
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            popUpView.centerXAnchor.constraint(equalTo: blackView.centerXAnchor),
            popUpView.centerYAnchor.constraint(equalTo: blackView.centerYAnchor),
            popUpView.heightAnchor.constraint(equalToConstant: 200),
            popUpView.leadingAnchor.constraint(equalTo: blackView.leadingAnchor, constant: 30),
            popUpView.trailingAnchor.constraint(equalTo: blackView.trailingAnchor, constant: -30)
        ])
        
    }
    
    
    //定義一個closure (關黑幕、popUpView) --> 跟view連結
    @objc func setDismissClosure(popView: PopUpMonthView) {
        
        popView.dismissClosure = {
            //關黑幕、popUpView
            self.popUpView.removeFromSuperview()
            self.blackView.removeFromSuperview()
            
            //tabBar 放回來
            self.tabBarController?.tabBar.isHidden = false
        }
    }

    func calculateAverageTime(timeStrings:[String]) -> String {
        
//        //把00:00換成最接近24:00來計算
//        var modifiedTimeStrings = timeStrings
//        while let index = modifiedTimeStrings.firstIndex(of: "00:00") {
//            modifiedTimeStrings[index] = "23:59"
//        }
        
        
        //把時間string轉換成Date，才能做計算
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        var totalTimeInterval: TimeInterval = 0
        let calendar = Calendar.current // 對date進行“時間操作”
        
        for timeString in timeStrings {
            if var date = dateFormatter.date(from: timeString) {
                //抓出hour
                let hour = Int(timeString.split(separator: ":")[0]) ?? 0 //[0] --> 因為timeString切開會變成array (ex. 22:00 --> ["22","00"])
                
                //以 ”12:00 pm" 為基準 （ 小於 --> 加 1 天 ）
                if hour < 12 { //用calendar去加一天
                    date = calendar.date(byAdding: .day, value: +1, to: date) ?? Date()
                }
                totalTimeInterval += date.timeIntervalSinceReferenceDate
            }
        }
        
        let averageTimeInterval = totalTimeInterval/Double(timeStrings.count)
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
               var endDate = dateFormatter.date(from: endArray[index]) {
                
                //因為Date會自動幫時間加上一個預設的日期（ex.2001/02/08)，所以直接相減會是“負的” or (startTime晚於endTime)
                //所以增加判斷，如果startTime > EndTime --> EndTime要加上一天
                if endDate < startDate {
                    endDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate) ?? Date() //unwrapped
                }
                //時間相減前要確認好date
                let sleepTime = endDate.timeIntervalSince(startDate) //endDate - startDate

                let sleepTimeString = String(sleepTime) //換成string 放到array
                print("&&& +\(sleepTimeString)")
                
                sleepTimeArray.append(sleepTimeString)
            }
        }
        return sleepTimeArray
    }
    
    func sleepTimeAverage(timeStrings: [String]) -> String {
        let totalSeconds = timeStrings.compactMap { Double($0)}.reduce(0, +) //string換成double(因為double是optional，所以用compactMap)，在累加
        let averageSeconds = totalSeconds / Double(timeStrings.count)
        
        let hours = Int(averageSeconds / 3600) //先拿到“小時”，暫時不管小數點
        let minutes = Int((averageSeconds/60).truncatingRemainder(dividingBy: 60)) //先除以60變分鐘，再除以60變小時，然後去拿最後除以小時剩下的餘數（ex.1 --> 1分鐘）
        
        //變成“2位數”整數(ex. Int 5 --> "05" )
        let formattedTime = String(format: "%02d:%02d", hours, minutes)
        return formattedTime
    }
    
    
    
//conform to protocol
    func manager(_ manager: FireStoreManager, didGet articles: [[String : Any]]) {
        //empty array
        var moodFlowEmptyArray:[MoodFlow] = []
        var startEmptyArray:[String] = []
        var endEmptyArray:[String] = []
        var sleepDateArray: [Date] = []
        
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
            //拿sleepStart，且直接"filter"出空的string
            if let sleepStart = article["sleepStart"] as? String, !sleepStart.isEmpty {

                startEmptyArray.append(sleepStart)
                
                //只有真正有紀錄sleepStart的"date"
                if let timeStamp = article["date"] as? Timestamp {
                    let date = timeStamp.dateValue()
                    sleepDateArray.append(date)
                }
            }
            //拿sleepEnd
            if let sleepEnd = article["sleepEnd"] as? String, !sleepEnd.isEmpty {
//                print("SleepEnd: \(sleepEnd)")
                
                endEmptyArray.append(sleepEnd)
            }
        }
        print(startEmptyArray)
        print(endEmptyArray)
        print(sleepDateArray)
        
        self.moodArray = moodFlowEmptyArray
        self.sleepStartArray = startEmptyArray
        self.sleepEndArray = endEmptyArray
        
        print(self.moodArray)
        
    // 判斷array是否為空的 （空的 -> container要黑屏)
        if self.moodArray.count == 0 {
            
            //先default，避免重疊
           self.hostView.removeFromSuperview()
            
            let indexPath = IndexPath(row: 0, section: 0)
            
            if let cell = tableView.cellForRow(at: indexPath) as? MoodFlowCell {
                
                cell.containerView.backgroundColor = .lightLightGray
                cell.containerView.alpha = 0.5
                //叫出no record label
                cell.noRecord.isHidden = false
            }

        } else { //放入圖表
            //I. 處理完資料後，call "moodContent swiftUI"，把畫圖資料傳過來
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
                
                //default 背景顏色
                cell.containerView.backgroundColor = .white
                cell.containerView.alpha = 1
                //隱藏 no record
                cell.noRecord.isHidden = true
                
                //給外面的hostView值
                self.hostView = hostView
                cell.addSubview(hostView)
                
                //設定swiftUI constraints
                hostView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    hostView.topAnchor.constraint(equalTo: cell.containerView.topAnchor, constant: 35),
                    hostView.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 16),
                    hostView.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -16),
                    hostView.bottomAnchor.constraint(equalTo: cell.containerView.bottomAnchor, constant: -5)
                ])
            }
        }
 
        
    //如果sleep沒有任何資料 （container要黑屏)
        if self.sleepStartArray.count == 0 {
            
            //先default，避免重疊
           self.sleepHostView.removeFromSuperview()
            
            let indexPath = IndexPath(row: 1, section: 0)
            
            if let cell = tableView.cellForRow(at: indexPath) as? SleepAnalysisCell {
                
            //I.
                cell.containerView.backgroundColor = .lightLightGray
                cell.containerView.alpha = 0.5
                //叫出no record label
                cell.noRecord.isHidden = false
                
                //清空sleepTimeLabel
                bedTime.text = ""
                wakeTime.text = ""
                sleepTime.text = ""
                
            //II.
                cell.containerView2.backgroundColor = .lightLightGray
                cell.containerView2.alpha = 0.5
                //叫出no record2
                cell.noRecord2.isHidden = false
            }
        } else { //有資料
        // II. 計算平均時間
            averageBedTime = calculateAverageTime(timeStrings: sleepStartArray)
            averageWakeTime = calculateAverageTime(timeStrings: sleepEndArray)
            
            let sleepTimeArray = calculateSleepTime(startArray: sleepStartArray, endArray: sleepEndArray)
            self.sleepTimeArray = sleepTimeArray
            print("??? \(sleepTimeArray)")
            
            averageSleepTime = sleepTimeAverage(timeStrings: sleepTimeArray)
            
            //處理完資料後 reload tableView，更新label
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)//讓處理好的資料被放進去
            
            
                //III. 把sleepDateArray和sleepTimeArray結合
                let sleepTimeFlowArray = zip(sleepDateArray, sleepTimeArray).map { SleepTimeFlow(date: $0, sleepTime: $1)
                }
                print("@@ + \(sleepTimeFlowArray)")
                self.sleepTimeFlowArray = sleepTimeFlowArray
                
                //處理完資料後，call "sleepBarChart swiftUI"，把畫圖資料傳過來
                let sleepBarSwiftUI = SleepBarChartView(sleepTimeFlowArray: self.sleepTimeFlowArray)
                let sleepHost = UIHostingController(rootView: sleepBarSwiftUI)
                
                let sleepIndexPath = IndexPath(row: 1, section: 0)
                self.sleepHostView.removeFromSuperview()
                
                if let sleepHostView = sleepHost.view,
                   let sleepCell = self.tableView.cellForRow(at: sleepIndexPath) as? SleepAnalysisCell {
                    
                    //default 背景顏色
                    sleepCell.containerView.backgroundColor = .white
                    sleepCell.containerView.alpha = 1
                    sleepCell.containerView2.backgroundColor = .white
                    sleepCell.containerView2.alpha = 1
                    //隱藏 no record
                    sleepCell.noRecord.isHidden = true
                    sleepCell.noRecord2.isHidden = true
                    
                    //給外面的sleepHostView值
                    self.sleepHostView = sleepHostView
                    sleepCell.addSubview(sleepHostView)
                    
                    sleepHostView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        sleepHostView.topAnchor.constraint(equalTo: sleepCell.containerView2.topAnchor, constant: 55),
                        sleepHostView.leadingAnchor.constraint(equalTo: sleepCell.containerView2.leadingAnchor, constant: 16),
                        sleepHostView.trailingAnchor.constraint(equalTo: sleepCell.containerView2.trailingAnchor, constant: -16),
                        sleepHostView.bottomAnchor.constraint(equalTo: sleepCell.containerView2.bottomAnchor, constant: -5)
                    ])
                }
            }
        }
    }
    

//Conform to Protocol
    func didReceiveDate(year: String, month: String) {
        
    //II. 收到點擊時間後 -> 改header的label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, yyyy"
        
        //把拿到的year month組合，變成Date
        if let date = dateFormatter.date(from: "\(month) \(year)") {
            //換成string
            let fullDateString = dateFormatter.string(from: date)
            
            //改header label
            dateLabel.text = fullDateString
            
            //III. 依照header label去 fetchMonthData
            FireStoreManager.shared.fetchMonthlyData(dateString: dateLabel.text ?? "")
            
        } else {
            print("Invalid month or year string")
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
        } else  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SleepAnalysisCell.reuseIdentifier, for: indexPath) as? SleepAnalysisCell
            else {fatalError("Could not create Cell")}
            
            //sleepLabel
            let sleepLabel = UILabel()
            sleepLabel.removeFromSuperview()
            sleepLabel.text = NSLocalizedString("sleepLabel", comment: "")
            sleepLabel.textColor = .orangeBrown
            sleepLabel.font = UIFont.systemFont(ofSize: 16)
            cell.containerView.addSubview(sleepLabel)
            
            sleepLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                sleepLabel.topAnchor.constraint(equalTo: cell.containerView.topAnchor, constant: 22),
                sleepLabel.leadingAnchor.constraint(equalTo: cell.containerView.leadingAnchor, constant: 22)
            ])
            
            //hrs
            let hrsLabel = UILabel()
            hrsLabel.removeFromSuperview()
            hrsLabel.text = NSLocalizedString("hrs", comment: "")
            hrsLabel.textColor = .lightGray
            hrsLabel.font = UIFont.systemFont(ofSize: 13)
            cell.containerView.addSubview(hrsLabel)
            
            hrsLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hrsLabel.trailingAnchor.constraint(equalTo: cell.containerView.trailingAnchor, constant: -50),
                hrsLabel.topAnchor.constraint(equalTo: cell.containerView.topAnchor, constant: 45)
            ])
            
            //Average label
            let bedTimeLabel = UILabel()
            let wakeTimeLabel = UILabel()
            let sleepTimelabel = UILabel()
            
            bedTimeLabel.text = NSLocalizedString("averageBed", comment: "")
            bedTimeLabel.numberOfLines = 2
            bedTimeLabel.textAlignment = .center
            wakeTimeLabel.text = NSLocalizedString("averageWake", comment: "")
            wakeTimeLabel.numberOfLines = 2
            wakeTimeLabel.textAlignment = .center
            sleepTimelabel.text = NSLocalizedString("averageSleep", comment: "")
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
        }
    }

}
