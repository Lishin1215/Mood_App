//
//  LookBackTestViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/7/6.
//

import UIKit
import AVFoundation


class LookBackTestViewController: UIViewController {

    //header
    let headerView = UIView()
    let titleLabel = UILabel()
    
    let dateLabel = UILabel()
    let historyButton = UIButton()
    let containerView = UIView()
    let keepRecordLabel = UILabel()
    
    //接收傳來的資料（delegate)
    private var photoArray: [String] = []
    
    //黑屏
    let blackView = UIView(frame: UIScreen.main.bounds)
    
    //創一個PopUp View加在上面 (delegate)
    let popUpView = PopUpMonthView()
    
    
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
        
        titleLabel.text = NSLocalizedString("memoir", comment: "")
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
        
        //keepRecord
        keepRecordLabel.text = NSLocalizedString("keepRecord", comment: "")
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
        if photoArray.count >= 5 {
//            scrollView.isHidden = false
            keepRecordLabel.isHidden = true
            return true
        } else {
            keepRecordLabel.isHidden = false
//            scrollView.isHidden = true
            return false
        }
    }
    
    
    @objc func historyButtonTapped(_ sender: UIButton) {
        
        //跳出黑屏
        blackView.backgroundColor = .black
        blackView.alpha = 0
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

    func createImageArray(from photoArray: [String]) -> [UIImage] {
        var images: [UIImage] = []
        
        for photoURLString in photoArray {
                
            if let photoURL = URL(string: photoURLString),
               let imageData = try? Data(contentsOf: photoURL),
               let image = UIImage(data: imageData) {
                
                images.append(image)
            }
        }
        return images
    }
    
    
    func createVideoFromImages(photoArray: [UIImage], outputURL: URL, completion: @escaping(Bool) -> Void) {
        
        guard let firstImage = photoArray.first else {
            completion(false)
            return
        }
        
        let size = firstImage.size
        
        let settings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoCodecKey: size.width,
            AVVideoCodecKey: size.height
        ]
        
        guard let videoWriter = try? AVAssetWriter(outputURL: outputURL, fileType: AVFileType.mp4) else {
            completion(false)
            return
        }
        
        let videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: settings)
        
        let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: nil)
        
        if videoWriter.canAdd(videoWriterInput) {
            //add the input to the asset writer
            videoWriter.add(videoWriterInput)
        } else {
            completion(false)
            return
        }
        //begin the session
        videoWriter.startWriting()
        videoWriter.startSession(atSourceTime: CMTime.zero)
        
        //determine how many frames we need to generate
        let frameDuration = CMTimeMake(value: 1, timescale: 30)
        
        for(index, image) in photoArray.enumerated() {
            if videoWriterInput.isReadyForMoreMediaData {
                
                let presentationTime = CMTimeMultiply(frameDuration, multiplier: Int32(index))
                
                if let pixelBuffer = image.pixelBuffer(width: Int(size.width), height: Int(size.height)) {
                    pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
                }
            }
        }
        //close everything
        videoWriterInput.markAsFinished()
        
        videoWriter.finishWriting {
            completion(videoWriter.status == .completed)
        }
        

    }

    
    
    
   

}


extension LookBackTestViewController: FireStoreManagerDelegate {
    
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
            
          
        } else {
            print("Less than Ten Photos!")
        }
    }
    
    
}

extension LookBackTestViewController: PopUpViewDelegate {
    
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
}
