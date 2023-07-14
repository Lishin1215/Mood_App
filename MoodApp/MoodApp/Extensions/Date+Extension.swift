//
//  Date+Extension.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/7/14.
//

import UIKit

extension Date {
    
    func formatDateString(format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: self)
        
        return dateString
    }
}
