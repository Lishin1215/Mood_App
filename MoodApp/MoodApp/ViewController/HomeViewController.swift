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
    let moodImages = ["image 8", "image 13", "image 25", "image 7", "image 22"]
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
        
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 顯示 navigationBar
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //delegate
        FireStoreManager.shared.delegate = self
        
        //先fetchdata，更新編輯過的date
        FireStoreManager.shared.fetchData()
        
        
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
            calendarView.heightAnchor.constraint(equalToConstant: 420)
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
}

extension HomeViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        if let date = dateComponents {
            self.selectDate = date
        }
        print(self.selectDate)
        
        //perform segue
        performSegue(withIdentifier: "newPageSegue", sender: dateComponents)
    }
}




