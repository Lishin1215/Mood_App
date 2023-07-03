//
//  PopUpMonthView.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/30.
//

import UIKit


protocol PopUpViewDelegate: AnyObject {
    
    func didReceiveDate(year: String, month: String)
}


class PopUpMonthView: UIView, UICollectionViewDataSource {
    
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    let yearPicker = UIPickerView()
    let yearButton = UIButton()
    let historyButton = UIButton()
    
    let monthInput = [NSLocalizedString("1", comment: ""),
                      NSLocalizedString("2", comment: ""),
                      NSLocalizedString("3", comment: ""),
                      NSLocalizedString("4", comment: ""),
                      NSLocalizedString("5", comment: ""),
                      NSLocalizedString("6", comment: ""),
                      NSLocalizedString("7", comment: ""),
                      NSLocalizedString("8", comment: ""),
                      NSLocalizedString("9", comment: ""),
                      NSLocalizedString("10", comment: ""),
                      NSLocalizedString("11", comment: ""),
                      NSLocalizedString("12", comment: "")]
    
    // 點擊後傳出
    var selectedYearString: String = ""
    
    //closure接收來自statisticsVC命令
    var dismissClosure: (() -> Void)?
    
    //delegate
    var delegate: PopUpViewDelegate?

    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        //圓弧四角
        layer.cornerRadius = 10
        clipsToBounds = true
        self.backgroundColor = .white.withAlphaComponent(1.0)
        
        //Create a layout for the collection view
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout //把layout跟collection view 連結
        
        //delegate
        collectionView.delegate = self
        collectionView.dataSource = self
        
        yearPicker.delegate = self
        yearPicker.dataSource = self
        
        //register
        collectionView.register(PopUpCell.self, forCellWithReuseIdentifier: PopUpCell.reuseIdentifier)

        
        collectionView.backgroundColor = .white
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        
        //pickerView
        yearPicker.backgroundColor = .white
        addSubview(yearPicker)
        
        yearPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yearPicker.centerYAnchor.constraint(equalTo: centerYAnchor),
            yearPicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            yearPicker.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        //yearButton
        let currentYear = Calendar.current.component(.year, from: Date())
        yearButton.setTitle("\(currentYear)", for: .normal)
        yearButton.setTitleColor(.black, for: .normal)
        yearButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        addSubview(yearButton)
        yearButton.addTarget(self, action: #selector(yearButtonTapped), for: .touchUpInside)
        
        yearButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yearButton.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            yearButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18)
        ])
        
        //historyButton
        historyButton.setImage(UIImage(named: "Icons_24px_DropDown"), for: .normal)
        historyButton.addTarget(self, action: #selector(yearButtonTapped), for: .touchUpInside)
        addSubview(historyButton)
        
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            historyButton.leadingAnchor.constraint(equalTo: yearButton.trailingAnchor, constant: 5),
            historyButton.topAnchor.constraint(equalTo: topAnchor, constant: 20)
        ])
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @objc func yearButtonTapped(_ sender: UIButton) {
        yearPicker.isHidden = false
    }
    
    
    @objc func monthButtonTapped (_ sender: UIButton) {
        
        //default all button color (一次default一個月）
        for monthIndex in 0...12{
            let indexPath = IndexPath(row: monthIndex, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? PopUpCell {
                cell.monthButton.backgroundColor = .lightGray
                cell.monthButton.setTitleColor(.black, for: .normal)
            }
        }
        
        // 執行closure （收掉popUpView 跟 黑屏）
        self.dismissClosure?()
        
        //button變green
        sender.backgroundColor = .grassGreen
        sender.setTitleColor(.white, for: .normal)
        
        //取得點擊的月份年份 (I. delegate傳到statisticVC / lookBackVC)
        self.delegate?.didReceiveDate(year: self.selectedYearString, month: sender.currentTitle ?? "")
    }
    
    
    
//MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopUpCell.reuseIdentifier, for: indexPath) as? PopUpCell else {
            fatalError("Cell cannot be created")
        }
        
        cell.monthButton.setTitle(monthInput[indexPath.row], for: .normal)
        cell.monthButton.addTarget(self, action: #selector(monthButtonTapped), for: .touchUpInside)
        
        return cell
    }
    
}




extension PopUpMonthView: UICollectionViewDelegateFlowLayout {
    
    //customize the object --> 算出一個item的寬度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 65, height: 30)
    }
    
    //設定垂直間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        18
    }
    
    //設定左右間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    //specify the “space” between each item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        let maxWidth:CGFloat = collectionView.frame.width
        let totalItemWidth:CGFloat = 65 * 4
        let interItemSpacing:CGFloat = (maxWidth - totalItemWidth - 40)/3
        
        return interItemSpacing
    }
}



extension PopUpMonthView: UIPickerViewDataSource {
    // MARK: - UIPickerViewDataSource
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            10
        }
}

extension PopUpMonthView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let year = currentYear - row
        
        //year傳出去
        self.selectedYearString = String(year)
        
        return "\(year)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //default隱藏
        yearPicker.isHidden = true
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let selectedYear = currentYear - row
        
        //selectedYear傳出去
        self.selectedYearString = String(selectedYear)
        
        yearButton.setTitle("\(selectedYear)", for: .normal)
        
        print("Selected Year: \(selectedYear)")
    }
}
