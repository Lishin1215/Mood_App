//
//  StatisticsViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/20.
//

import UIKit

class StatisticsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FireStoreManagerDelegate {
   
    

    //header
    let headerView = UIView()
    let dateLabel = UILabel()
    let historyButton = UIButton()
    
    //接收傳來的資料 (delegate)
    private var moodArray:[String] = []
    private var sleepStartArray:[String] = []
    private var sleepEndArray:[String] = []
    
    
    
    let tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate
        FireStoreManager.shared.delegate = self
        FireStoreManager.shared.fetchMonthlyData()

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

    
//conform to protocol
    func manager(_ manager: FireStoreManager, didGet articles: [[String : Any]]) {
        //empty array
        var moodEmptyArray:[String] = []
        var startEmptyArray:[String] = []
        var endEmptyArray:[String] = []
        
        for article in articles {
            //拿mood
            if let mood = article["mood"] as? String {
//                print("Mood: \(mood)")
                
                moodEmptyArray.append(mood)
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
        
        self.moodArray = moodEmptyArray
        self.sleepStartArray = startEmptyArray
        self.sleepEndArray = endEmptyArray
        
        print(self.moodArray)
        print(self.sleepEndArray)
        print(self.sleepStartArray)
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
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SleepAnalysisCell.reuseIdentifier, for: indexPath) as? SleepAnalysisCell
            else {fatalError("Could not create Cell")}
            
            
            return cell
        }
    }

}
