//
//  LocalizeUtils.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/7/3.
//

import UIKit

class LocalizeUtils: NSObject {
    
    static let shared = LocalizeUtils()
    
    // 依語系檔裡的 key 取得 value 值
    func localized(withKey key: String, withLocalizationFileName localizationFileName: String) -> String {
        
        //取得Bundle下的多國語系檔
        let path = Bundle.main.path(forResource: localizationFileName, ofType: "lproj") ?? ""
        let bundle = Bundle(path: path) ?? Bundle()
        
        //依key值和Bundle的多國語系檔，取得對應value
        return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
    //第一次開啟App，依使用者OS設定的語系來決定App的語系
    func settingUserLanguageCode() {
        
        //取得使用者iOS設定的語系
        let preferredLanguages: String = Locale.preferredLanguages.first ?? "" // 繁體=zh-Hant-TW
        var currentLanguageCode = "en"  //預設是英文
        if preferredLanguages != "en"{
            // serparate when not "en"
            currentLanguageCode = String(preferredLanguages.split(separator: "-")[1]) // Hant、Hans
        }

        //設定要取得的Bundle的多國語系檔名
        var bundleLocalizeFileName: String?
        if currentLanguageCode == "Hant" { //繁體
            bundleLocalizeFileName = "zh-Hant"

            StorageManager.shared.setLanguage(newLanguage: 1)
        } else { //英文
            bundleLocalizeFileName = "en"
            StorageManager.shared.setLanguage(newLanguage: 0)
        }
        
        //設定多國語系檔檔名
        UserDefaults.standard.set(bundleLocalizeFileName, forKey: "UserLanguage")
    }
}
