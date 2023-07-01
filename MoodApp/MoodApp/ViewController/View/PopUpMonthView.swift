//
//  PopUpMonthView.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/30.
//

import UIKit

class PopUpMonthView: UIView, UICollectionViewDataSource {
    
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    let monthInput = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    //closure接收來自statisticsVC命令
    var dismissClosure: (() -> Void)?

    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        //圓弧四角
        layer.cornerRadius = 10
        clipsToBounds = true
        self.backgroundColor = .white.withAlphaComponent(1.0)
        
        //Create a layout for the collection view
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout //把layout跟collection view 連結
        layout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 60)
        
        //delegate
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //register
        collectionView.register(PopUpCell.self, forCellWithReuseIdentifier: PopUpCell.reuseIdentifier)
        collectionView.register(PopUpHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PopUpHeader")
        
        
        collectionView.backgroundColor = .white
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func monthButtonTapped (_ sender: UIButton) {
        print("呵呵")
        
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
        
        //取得點擊的月份年份
        
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
    
    //add Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PopUpHeader", for: indexPath) as? PopUpHeaderView else { fatalError("Unable to dequeue header view")}
            
            //加在view上，才可在整個view上滑動，非只有headerView
            addSubview(headerView.yearPicker)
            headerView.yearPicker.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                headerView.yearPicker.centerYAnchor.constraint(equalTo: centerYAnchor),
                headerView.yearPicker.leadingAnchor.constraint(equalTo: leadingAnchor),
                headerView.yearPicker.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
            
            
            return headerView
        } else {
            fatalError("Cannot create popUpHeaderView")
        }
       
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
