//
//  StatisticsViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/20.
//

import UIKit
import SwiftUI
import FirebaseFirestore


class StatisticsViewController: UIViewController, UITableViewDelegate, FireStoreManagerDelegate, PopUpViewDelegate
{
    
    // header
    let headerView = UIView()
    let dateLabel = UILabel()
    let historyButton = UIButton()
    
    // 接收傳來的資料 (delegate)
    private var moodArray: [MoodFlow] = []
    private var sleepStartArray: [String] = []
    private var sleepEndArray: [String] = []
    private var sleepTimeArray: [String] = []
    
    // 計算結果
    var averageBedTime: String?
    var averageWakeTime: String?
    var averageSleepTime: String?
    
    // swiftUI struct
    private var sleepTimeFlowArray: [SleepTimeFlow] = []
    
    // 為避免加入swiftUI圖後重疊，先設置來default
    private var hostView: UIView = UIView()
    private var sleepHostView: UIView = UIView()
    
    // 創一個PopUp View加在上面 (delegate)
    let popUpView = PopUpMonthView()
    
    // cell裡面的，放外面是避免reload data時重複新的label(我只要一個就好）
    let bedTime = UILabel()
    let wakeTime = UILabel()
    let sleepTime = UILabel()
    
    // 黑屏
    let blackView = UIView(frame: UIScreen.main.bounds)
    
    
    let tableView = UITableView()
    
    // dataSource & delegate
    var dataSource = StatisticsTableViewDataSource()
//    let delegate = StatisticsTableViewDelegate()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // delegate
        FireStoreManager.shared.delegate = self
        popUpView.delegate = self
        // fetchData （放這裡從tabBar進入才會一直走過）
        FireStoreManager.shared.fetchMonthlyData(dateString: dateLabel.text ?? "")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate
//        FireStoreManager.shared.delegate = self
        
        // dataSource分開寫（從dataSource.swift指回來）
        self.dataSource.viewController = self

        tableView.dataSource = dataSource
        tableView.delegate = self
        
        // register
        tableView.register(MoodFlowCell.self, forCellReuseIdentifier: MoodFlowCell.reuseIdentifier)
        tableView.register(SleepAnalysisCell.self, forCellReuseIdentifier: SleepAnalysisCell.reuseIdentifier)
        
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
        
    // header
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.14)
        ])
        
        // share button
        let shareButton = UIButton()
        let shareImage = UIImage(systemName: "square.and.arrow.up")?.withRenderingMode(.alwaysTemplate)
        shareButton.setImage(shareImage, for: .normal)
        shareButton.tintColor = .lightBlack
        
        headerView.addSubview(shareButton)

        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            shareButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -30)
        ])
        
        // 當月 (Date())
        let date = Date()
        // 用date extension (dateString)
        let formattedDate = date.formatDateString(format: "MMMM, yyyy") // 指定日期格式
        
        dateLabel.text = formattedDate
        dateLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        headerView.addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -30)
        ])
        
        // historyButton (看要不要跟dateLabel寫成一個stackView)
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
        
        var moodWritePath: URL?
        var sleepWritePath: URL?
        
        let moodIndexPath = IndexPath(row: 0, section: 0)
        if let moodCell = self.tableView.cellForRow(at: moodIndexPath) {
            
            // mood URL
            moodWritePath = captureCellImage(moodCell, fileName: "mood.png")
        }
        
        let sleepIndexPath = IndexPath(row: 1, section: 0)
        if let sleepCell = self.tableView.cellForRow(at: sleepIndexPath) {
            
            // sleep URL
            sleepWritePath = captureCellImage(sleepCell, fileName: "sleep.png")
        }
        
    // 跳出分享畫面
        // I. 要分享的東西
        var activityItems: [Any] = []
        
        if let moodPath = moodWritePath {
            activityItems.append(moodPath)
        }
        if let sleepPath = sleepWritePath {
            activityItems.append(sleepPath)
        }
        
        // II. 產生分享VC
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // III. 分享結果（跳alert)
        activityVC.completionWithItemsHandler = { [weak self] (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            
            if let error = error {
               
                self?.showAlert(title: NSLocalizedString("Error", comment: ""), message: nil)
            }
            
            if completed {
                
                self?.showAlert(title: NSLocalizedString("Success", comment: ""), message: nil)
            }
        }
        // 分享VC跳出
        self.present(activityVC, animated: true, completion: nil)
    }
    

    
    
    // 把cell做成圖片(convert UIView to .png) -> 產生URL路徑
    func captureCellImage(_ cell: UITableViewCell, fileName: String) -> URL? {
        
        // Begin
        UIGraphicsBeginImageContextWithOptions(cell.layer.frame.size, false, 1)
        // 將cell渲染到current context
        cell.layer.render(in: UIGraphicsGetCurrentContext()!)
        // 有、無從context拿到image
        guard let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        else {
            print("failed to get image from context")
            return nil // 跳出
        }
        // End
        UIGraphicsEndImageContext()
        
        // 創建“資料夾的路徑”
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imagePath = documentsDir.appendingPathComponent(fileName) // image的url路徑
        
        // 把imageData寫入imagePath
        do {
            if let imageData = viewImage.pngData() {
                try imageData.write(to: imagePath)
                print("Save image to :", imagePath)
                
                return imagePath // URL
            }
        } catch {
            print("Could not write image data")
        }
        
        return nil
    }
    
    
    
    @objc func historyButtonTapped(_ sender: UIButton) {
        
        // 跳出黑屏
        blackView.backgroundColor = .black
        blackView.alpha = 0 // 淡入的動畫效果
        view.addSubview(blackView)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0) {
            self.blackView.alpha = 0.5
        }
        // tabbar 收起來
        tabBarController?.tabBar.isHidden = true
        
        // 跳出畫面
        showPopUpMonthView()
        
        // 此時先把closure傳到popUpView
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
    
    
    // 定義一個closure (關黑幕、popUpView) --> 跟view連結
    @objc func setDismissClosure(popView: PopUpMonthView) {
        
        popView.dismissClosure = {
            // 關黑幕、popUpView
            self.popUpView.removeFromSuperview()
            self.blackView.removeFromSuperview()
            
            // tabBar 放回來
            self.tabBarController?.tabBar.isHidden = false
        }
    }

    // Bed & Wake
    func calculateAverageTime(timeStrings:[String]) -> String {
        
        // 把時間string轉換成Date，才能做計算
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        var totalTimeInterval: TimeInterval = 0
        let calendar = Calendar.current // 對date進行“時間操作”
        
        for timeString in timeStrings {
            if var date = dateFormatter.date(from: timeString) {
                // 抓出hour
                let hour = Int(timeString.split(separator: ":")[0]) ?? 0 // [0] --> 因為timeString切開會變成array (ex. 22:00 --> ["22","00"])
                
                // 以 ”12:00 am" 為基準 （ 小於 --> 加 1 天 ）
                if hour < 12 { // 用calendar去加一天
                    date = calendar.date(byAdding: .day, value: +1, to: date) ?? Date()
                }
                totalTimeInterval += date.timeIntervalSinceReferenceDate
            }
        }
        
        let averageTimeInterval = totalTimeInterval/Double(timeStrings.count)
        // 換回Date
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
        // 把時間string轉換成Date，才能做計算
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        var sleepTimeArray: [String] = []
        
        // 先換成Date
        for index in 0..<startArray.count {
            if let startDate = dateFormatter.date(from: startArray[index]),
               var endDate = dateFormatter.date(from: endArray[index]) {
                
                // 因為Date會自動幫時間加上一個預設的日期（ex.2001/02/08)，所以直接相減會是“負的” or (startTime晚於endTime)
                // 所以增加判斷，如果startTime > EndTime --> EndTime要加上一天
                if endDate < startDate {
                    endDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate) ?? Date() //unwrapped
                }
                // 時間相減前要確認好date
                let sleepTime = endDate.timeIntervalSince(startDate) // endDate - startDate

                let sleepTimeString = String(sleepTime) // 換成string 放到array
                print("&&& +\(sleepTimeString)")
                
                sleepTimeArray.append(sleepTimeString)
            }
        }
        return sleepTimeArray
    }
    
    
    func sleepTimeAverage(timeStrings: [String]) -> String {
        
        // 算出來是“秒“
        let totalSeconds = timeStrings.compactMap { Double($0)}.reduce(0, +) // string換成double(因為double是optional，所以用compactMap)，再累加
        let averageSeconds = totalSeconds / Double(timeStrings.count)
        
        let hours = Int(averageSeconds / 3600) // 先拿到“小時”，暫時不管小數點
        let minutes = Int((averageSeconds/60).truncatingRemainder(dividingBy: 60)) // 先除以60變分鐘，再除以60變小時，然後去拿最後除以小時剩下的餘數（ex.1 --> 1分鐘）
        
        // 變成“2位數”整數(ex. Int 5 --> "05" )
        let formattedTime = String(format: "%02d:%02d", hours, minutes)
        
        return formattedTime
    }
    
    
    
// conform to protocol（後進）
    func manager(_ manager: FireStoreManager, didGet articles: [[String : Any]]) {
        
        // empty array
        var moodFlowEmptyArray:[MoodFlow] = []
        var startEmptyArray:[String] = []
        var endEmptyArray:[String] = []
        var sleepDateArray: [Date] = []
        
        for article in articles {
            // 拿date & mood --> moodFlow
            if let timeStamp = article["date"] as? Timestamp {
                let date = timeStamp.dateValue() //型別:Date
                
                if let mood = article["mood"] as? String {
                    
                    // 以moodflow的資料結構，放入empty array中
                    let moodflow = MoodFlow(date: date, mood: mood)
                    moodFlowEmptyArray.append(moodflow)
                }
            }
            // 拿sleepStart，且直接"filter"出空的string
            if let sleepStart = article["sleepStart"] as? String, !sleepStart.isEmpty {
                
                startEmptyArray.append(sleepStart)
                
                // 只有真正有紀錄sleepStart的"date"
                if let timeStamp = article["date"] as? Timestamp {
                    let date = timeStamp.dateValue()
                    sleepDateArray.append(date)
                }
            }
            // 拿sleepEnd
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
        
        // moodCell
        // 判斷array是否為空的 （空的 -> container要黑屏)
        if self.moodArray.isEmpty {
            setMoodFlowEmptyState()
        } else { // 放入圖表
            // I. 處理完資料後，call "moodContent swiftUI"，把畫圖資料傳過來
            let moodFlowSwiftUI = MoodContentView(moodArray: self.moodArray)
            
            let indexPath  = IndexPath(row: 0, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? MoodFlowCell {
                self.addSwiftUIView(hostView: self.hostView, rootView: moodFlowSwiftUI, containerView: cell.containerView, noRecordLabel: cell.noRecord, type: "mood")
            }
        }
        
        // sleepAnalysisCell
        // 如果sleep沒有任何資料 （container要黑屏)
        if self.sleepStartArray.isEmpty {
            setSleepAnalysisEmptyState()
        } else {
            // II. 計算平均時間
            calculateAndDisplaySleepAnalysis(sleepDateArray)
            
            // III. 把sleepDateArray和sleepTimeArray結合
            // 處理完資料後，call "sleepBarChart swiftUI"，把畫圖資料傳過來
            let sleepBarSwiftUI = SleepBarChartView(sleepTimeFlowArray: self.sleepTimeFlowArray)
            
            let sleepIndexPath = IndexPath(row: 1, section: 0)
            if let sleepCell = tableView.cellForRow(at: sleepIndexPath) as? SleepAnalysisCell{
                self.addSwiftUIView(hostView: self.sleepHostView, rootView: sleepBarSwiftUI, containerView: sleepCell.containerView2, noRecordLabel: sleepCell.noRecord2, type: "sleep")
            }
        }
        
    }

   
    private func setMoodFlowEmptyState() {
        self.hostView.removeFromSuperview()
        let indexPath = IndexPath(row: 0, section: 0)

        if let cell = tableView.cellForRow(at: indexPath) as? MoodFlowCell {

            cell.containerView.backgroundColor = .lightLightGray
            cell.containerView.alpha = 0.5
            // 叫出no record label
            cell.noRecord.isHidden = false
        }
    }
    

    
    private func setSleepAnalysisEmptyState() {
        // 先default，避免重疊
       self.sleepHostView.removeFromSuperview()

        let indexPath = IndexPath(row: 1, section: 0)

        if let cell = tableView.cellForRow(at: indexPath) as? SleepAnalysisCell {

        // I.
            cell.containerView.backgroundColor = .lightLightGray
            cell.containerView.alpha = 0.5
            // 叫出no record label
            cell.noRecord.isHidden = false

            // 清空sleepTimeLabel
            bedTime.text = ""
            wakeTime.text = ""
            sleepTime.text = ""

        // II.
            cell.containerView2.backgroundColor = .lightLightGray
            cell.containerView2.alpha = 0.5
            // 叫出no record2
            cell.noRecord2.isHidden = false
        }
    }
    
    private func calculateAndDisplaySleepAnalysis(_ sleepDateArray: [Date]) {
        
        self.averageBedTime = calculateAverageTime(timeStrings: sleepStartArray)
        self.averageWakeTime = calculateAverageTime(timeStrings: sleepEndArray)
        let sleepTimeArray = calculateSleepTime(startArray: sleepStartArray, endArray: sleepEndArray)
        self.sleepTimeArray = sleepTimeArray
//        print("??? \(sleepTimeArray)")
        
        averageSleepTime = sleepTimeAverage(timeStrings: sleepTimeArray)
        
        // 處理完資料後 reload tableView，更新label
        self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)//讓處理好的資料被放進去

        
        // III. 把sleepDateArray和sleepTimeArray結合(為了做bar chart）
        let sleepTimeFlowArray = zip(sleepDateArray, sleepTimeArray).map { SleepTimeFlow(date: $0, sleepTime: $1)
        }
        self.sleepTimeFlowArray = sleepTimeFlowArray
        print("@@ + \(self.sleepTimeFlowArray)")
        
        // default 背景顏色
        let indexPath = IndexPath(row: 1, section: 0)
        if let sleepCell = tableView.cellForRow(at: indexPath) as? SleepAnalysisCell {
            sleepCell.containerView.backgroundColor = .white
            sleepCell.containerView.alpha = 1
            sleepCell.noRecord.isHidden = true
        }
        
    }

    
    // swiftUI圖表結合UIKit
    // line chart/ bar chart
private func addSwiftUIView<T: View>(hostView: UIView, rootView: T, containerView: UIView, noRecordLabel: UILabel, type: String) {
        // swiftUI提供結合UIKit(hostController
        let host = UIHostingController(rootView: rootView)
        
        // **取得UIHostingController的view，再把他addSubview到對應的cell上
        if let hostView = host.view {
            
            // default 背景顏色
            containerView.backgroundColor = .white
            containerView.alpha = 1
            noRecordLabel.isHidden = true
            
            // 給外面的hostView值 （ & 判斷是哪hostview)
            if type == "mood"{
                // 在外面設一個空的hostView, 在addSubview前先default，避免重疊
                self.hostView.removeFromSuperview()
                self.hostView = hostView
            } else {
                self.sleepHostView.removeFromSuperview()
                self.sleepHostView = hostView
            }
            
            containerView.addSubview(hostView)
            
            hostView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35),
                hostView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                hostView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                hostView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)
            ])
            
    }
}
    

// Conform to Protocol(先進）
    func didReceiveDate(year: String, month: String) {
        
    // II. 收到點擊時間後 -> 改header的label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, yyyy"
        
        // 把拿到的year month組合，變成Date
        if let date = dateFormatter.date(from: "\(month) \(year)") {
            // 換成string
            let fullDateString = dateFormatter.string(from: date)
            
            // 改header label
            dateLabel.text = fullDateString
            
            // III. 依照header label去 fetchMonthData
            FireStoreManager.shared.fetchMonthlyData(dateString: dateLabel.text ?? "")
            
            // IV. default cell (先把之前的label移掉）
//            let indexPath = IndexPath(row: 1, section: 0)
//
//            if let cell = tableView.cellForRow(at: indexPath) as? SleepAnalysisCell {
//
//            //叫不到 sleepLabel/ hrsLabel
//
//            }
            
        } else {
            print("Invalid month or year string")
        }
    }
    
    
// MARK: UITableView Delegate
// height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        } else {
            return 550
        }
    }

}
