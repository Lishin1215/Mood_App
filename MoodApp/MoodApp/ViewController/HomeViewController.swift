//
//  ViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/14.
//

import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController, FireStoreManagerDelegate {
    
    
   
    let calendarView = UICalendarView()
    let gregorianCalendar = Calendar(identifier: .gregorian)
    var selectDate: DateComponents?
    
    
    //改變calendar icon
    let moodImages = ["image 22", "image 7", "image 25", "image 13", "image 8"]
    private var dateArray: [DateComponents] = [] {
        didSet {
            print("******", dateArray.map { ($0.month!, $0.day!) })
        }
    }
    private var dateMoodDict: [DateComponents: String] = [:]
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 隱藏 navigationBar
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        //delegate (不用特別寫fetch，因為newPage的addDayButton裡會fetch)(從其他tab進來時也不用fetch最新資料，維持跟上一次一樣就好）
        FireStoreManager.shared.delegate = self

    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 顯示 navigationBar
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //delegate (“第一次”進畫面走這邊，因為viewDidLoad先發生）
        FireStoreManager.shared.delegate = self
        //fetch (當下月份的資料）
        FireStoreManager.shared.fetchMonthlyData(inputDate: Date())
        
        
        calendarView.delegate = self
        
        calendarView.calendar = gregorianCalendar
        view.addSubview(calendarView)
        calendarView.backgroundColor = .white
        
        //add constraints
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            calendarView.heightAnchor.constraint(equalToConstant: 450)
        ])
        
        //單選模式
        let singleDateSelection = UICalendarSelectionSingleDate(delegate: self)
        singleDateSelection.selectedDate = selectDate
        calendarView.selectionBehavior = singleDateSelection
    
    }
    
    //傳資料到newPage
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        //確認傳遞要項無誤
        if segue.identifier == "newPageSegue" {
            if let dateComponents = sender as? DateComponents,
               let segueVC = segue.destination as? NewPageViewController {
                //將任意點到的product資料，傳給newPageVC
                segueVC.dateComponents = dateComponents

            }
        }
    }
    
   
//conform to protocol
    func manager(_ manager: FireStoreManager, didGet articles: [[String: Any]]) {
        // empty array
        var emptyArray:[DateComponents] = []
        // convert each data into date
        for article in articles {
            //拿date
            if let timeStamp = article["date"] as? Timestamp {
                let date = timeStamp.dateValue()
                
                let calendar = Calendar.current
                let dateComponents = calendar.dateComponents([.calendar, .era, .year, .month, .day], from: date)
                emptyArray.append(dateComponents)
                
                //拿mood
                if let mood = article["mood"] as? String {
                    dateMoodDict[dateComponents] = moodImages[Int(mood) ?? 0]
                }
                
            }
        }
    
        self.dateArray = emptyArray

        calendarView.reloadDecorations(forDateComponents: dateArray, animated: true)
    }

}

//MARK: Extension
extension HomeViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        
        let font = UIFont.systemFont(ofSize: 10)
        let configuration = UIImage.SymbolConfiguration(font: font)
        
        //假如dateComponents出現在dateArray中，代表dateComponents這個日期是需要放心情圖片
        //若dateComponents"沒有"出現在dateArray，代表使用者還沒在這個日期上紀錄過心情，因此跳到下面的else
        if dateArray.contains(dateComponents){
            
            //藉由日期去dict中拿到對應心情圖案的string
            let correspondMoodString = dateMoodDict[dateComponents] ?? ""
            if let changedImage = UIImage(named: correspondMoodString)?.withRenderingMode(.alwaysOriginal){
                let scaledSize = CGSize(width: 18, height: changedImage.size.height * 18 / changedImage.size.width)
                let renderer = UIGraphicsImageRenderer(size: scaledSize)
                let scaledImage = renderer.image { _ in
                    changedImage.draw(in: CGRect(origin: .zero, size: scaledSize))
                }
                return .image(scaledImage)
            } else {
                return nil
            }
        } else {
            //全部放灰色
            if let originalImage = UIImage(named: "Ellipse 4")?.withRenderingMode(.alwaysOriginal){
                let scaledSize = CGSize(width: 18, height: originalImage.size.height * 18 / originalImage.size.width)
                let renderer = UIGraphicsImageRenderer(size: scaledSize)
                let scaledImage = renderer.image { _ in
                    originalImage.draw(in: CGRect(origin: .zero, size: scaledSize))
                }
                return .image(scaledImage)
            }else {
                return nil
            }
        }
    }
    
    //抓“切換月份前的顯示月份” (”切換月份“時執行）
    func calendarView(_ calendarView: UICalendarView, didChangeVisibleDateComponentsFrom previousDateComponents: DateComponents) {
        
        
        //component換成Date
        let calendar = Calendar.current
        
        //一次抓三個月，因為不知道使用者會“往前or往後”切換  --> 所以前後都抓
        if let previousDate = calendar.date(from: previousDateComponents) {
            if let beforeDate = calendar.date(byAdding: .month, value: -1, to: previousDate),
               let afterDate = calendar.date(byAdding: .month, value: +1, to: previousDate) {
                
                FireStoreManager.shared.fetchMultipleMonth(fromDate: beforeDate, toDate: afterDate)
            }
                
        }
    }
}

extension HomeViewController: UICalendarSelectionSingleDateDelegate {
    
    //點擊日期進入newPage
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if let date = dateComponents {
            self.selectDate = date
        }
        print(self.selectDate)
        
        //perform segue
        performSegue(withIdentifier: "newPageSegue", sender: dateComponents)
    }
    
    //不能點選未來時間
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        
        guard let date = dateComponents?.date else {
                return false
            }
            
            let now = Date()
            let calendar = Calendar.current
            
            // 檢查日期是否在當前日期之後
            if calendar.compare(date, to: now, toGranularity: .day) == .orderedDescending { //orderedDescending -->當前之後
                // 日期在當前日期之後，禁止選擇
                return false
            }
            
            // 允許選擇其他日期
            return true
    }
}





