//
//  PopUpHeaderView.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/30.
//

import UIKit

class PopUpHeaderView: UICollectionReusableView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    let yearPicker = UIPickerView()
    let yearButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        //delegate
        yearPicker.delegate = self
        yearPicker.dataSource = self
        
        yearPicker.backgroundColor = .white
//        addSubview(yearPicker)
       
        
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @objc func yearButtonTapped(_ sender: UIButton) {
        yearPicker.isHidden = false
    }
    
    
    
// MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        10
    }
    
// MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let year = currentYear - row
        
        return "\(year)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //default隱藏
        yearPicker.isHidden = true
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let selectedYear = currentYear - row
        
        yearButton.setTitle("\(selectedYear)", for: .normal)
        
        print("Selected Year: \(selectedYear)")
    }
}
