//
//  LookBackViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/21.
//

import UIKit

class LookBackViewController: UIViewController, FireStoreManagerDelegate, UIScrollViewDelegate {
    
    
    //header
    let headerView = UIView()
    let titleLabel = UILabel()
    
    let dateLabel = UILabel()
    let historyButton = UIButton()
    let containerView = UIView()
    let keepRecordLabel = UILabel()
    
    //接收傳來的資料（delegate)
    private var photoArray: [String] = []
    
    //scrollview
    let scrollView = UIScrollView()
    private var timer = Timer()
    private var counter = 0
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //delegate
        FireStoreManager.shared.delegate = self
        //fetchData （放這裡從tabBar進入才會一直走過）
        FireStoreManager.shared.fetchMonthlyData()
        
//        checkPhotoAmount()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //停止計時
        timer.invalidate()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //header
        headerView.backgroundColor = .pinkOrange
        view.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.14)
        ])
        
        titleLabel.text = "Memoir"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headerView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -30)
        ])
        
        //date (當月）
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, yyyy"
        let dateString = dateFormatter.string(from: date)
        dateLabel.text = dateString
        
        dateLabel.textColor = .darkGray
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        //historyButton (看要不要跟dateLabel寫成一個stackView)
        historyButton.setImage(UIImage(named: "Icons_24px_DropDown"), for: .normal)
        historyButton.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
        view.addSubview(historyButton)
        
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            historyButton.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 5),
            historyButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 26)
        ])
        
        
        //container
        containerView.backgroundColor = .lightPinkOrange
        containerView.layer.cornerRadius = 10
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 25),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        
        //scrollView
        scrollView.delegate = self
        // 以一頁為單位滑動
        scrollView.isPagingEnabled = true
        
        // 是否顯示滑動條
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        //        scrollView.backgroundColor = .gray
        containerView.addSubview(scrollView)
        scrollView.isHidden = true //default先隱藏
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        
        //keepRecord
        keepRecordLabel.text = "Keep recording to unlock more features!"
        keepRecordLabel.font = UIFont.boldSystemFont(ofSize: 15)
        keepRecordLabel.textColor = .darkGray
        containerView.addSubview(keepRecordLabel)
        keepRecordLabel.isHidden = true //default先隱藏
        
        keepRecordLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            keepRecordLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor), keepRecordLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        
    }
    
    
    func isOverTenPhoto() -> Bool { //使用時機：fetch完data，才做判斷
        if photoArray.count >= 10 {
            scrollView.isHidden = false
            keepRecordLabel.isHidden = true
            return true
        } else {
            keepRecordLabel.isHidden = false
            scrollView.isHidden = true
            return false
        }
    }
    
    func startTimer() {
        timer = Timer(timeInterval: 1.5, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common) //要寫這行才能成功call到autoScroll
    }
    
    @objc func autoScroll() {
        if counter < photoArray.count {
            scrollView.setContentOffset(CGPoint(x: scrollView.frame.width * CGFloat(counter), y: 0), animated: true)
            counter += 1
        }else{
            counter = 0 //當counter >= photoArray，讓counter歸零，可以繼續循環圖片（會走回if counter < photoArray這條路）
        }
    }
    
    @objc func historyButtonTapped(_ sender: UIButton) {
        print("oh yeah oh my god!")
    }

    
//conform to protocol
    func manager(_ manager: FireStoreManager, didGet articles: [[String : Any]]) {
        //empty array
        var emptyArray:[String] = []
        
        for article in articles {
            //拿photo
            if let photo = article["photo"] as? String {
//                print("Photo: \(photo)")
                emptyArray.append(photo)
            }
        }
        print(emptyArray)
        
        //filter出空的string
        let filterArray = emptyArray.filter { !$0.isEmpty }
        print(filterArray)
        
        self.photoArray = filterArray
        
        
        //判斷photoArray數量
        if isOverTenPhoto() == true {
            
            //所有圖片加總"寬"度
            scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(photoArray.count), height: scrollView.frame.height) //設了autoConstriant可以拿到frame (scrollView.frame.width)
            //加入ImageView以顯示圖片
            for index in 0 ..< photoArray.count {
                let scrollImageView = UIImageView()
                
                scrollImageView.contentMode = .scaleAspectFill
                scrollImageView.clipsToBounds = true
                scrollView.addSubview(scrollImageView)
                
                scrollImageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    scrollImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                    //for迴圈分別設每一張圖的leading，接起來會是一大張圖的總寬度(contentSize)
                    scrollImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: scrollView.frame.width * CGFloat(index)),
                    scrollImageView.widthAnchor.constraint(equalToConstant: scrollView.frame.width),
                    scrollImageView.heightAnchor.constraint(equalToConstant: scrollView.frame.height)
                ])
                // 獲取圖片的 URL
                let scrollImage = URL(string: photoArray[index])
                // 設置圖片到 imageView 中
                scrollImageView.addImage(with: scrollImage)
            }
            
            //建立完scrollview / contentView/ imageView，可以開始"計時"
            startTimer()
        } else {
            print("Less than Ten Photos, no need timer!")
        }
       
    }

}
