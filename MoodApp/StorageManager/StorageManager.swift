//
//  StorageManager.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/27.
//

import UIKit
import CoreData

class StorageManager {
    
    // 單例設計模式 Singleton Design Pattern (永遠只有一個instance)
    static let shared = StorageManager()
    private init() {}
    
    //1. Core Data stack 持久化存儲區
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PersonalInfoModel") //YourDataModelName
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // 2.Core Data Managed Object Context
    //可以用來查詢 Core Data 中的資料並對其進行修改，然後將這些修改寫回到資料庫中
    //應用程序和 Core Data 資料庫之間的"中介層"
    lazy var managedObjectContext: NSManagedObjectContext = {
            return persistentContainer.viewContext
        }()

 //-----------------------------------
    
    
    // 取得密碼
    func fetchPassword() -> String? {
        
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<PersonalInfo> = PersonalInfo.fetchRequest() //拿到的會是"整個[PersonalInfo]"
        
        
        do {
            let personalInfo = try context.fetch(fetchRequest) // [PersonalInfo]
            return personalInfo.first?.passcode // personalInfo.first --> [PersonalInfo]的first(第0項） --> PesonalInfo
        } catch {
            print("Error fetching passcode: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
    func setPassword(newPasscode: String?) {
        
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<PersonalInfo> = PersonalInfo.fetchRequest()
        
        //setPassword有兩種情況 (1. 已經有密碼（改密碼)  2. 還沒有密碼
        //情況1. 把現有的passcode拿下來並取代 --> context.fetch(fetchRequest).first
        //情況2. fetch不到東西（nil)（因為沒密碼），就"新增"一個 PersonalInfo 放資料 --> PersonalInfo(context: context)
        do {
            let personalInfo = try context.fetch(fetchRequest).first ?? PersonalInfo(context: context)
            
            personalInfo.passcode = newPasscode
            print(newPasscode)
            
            //最後存到coreData
            try context.save()
            
        } catch {
            print("Error setting passcode: \(error.localizedDescription)")
        }
    }
    
    
    // 取得reminderTime
    func fetchReminderTime() -> Date? {
        
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<PersonalInfo> = PersonalInfo.fetchRequest() //拿到的會是"整個[PersonalInfo]"
        
        
        do {
            let personalInfo = try context.fetch(fetchRequest) // [PersonalInfo]
            return personalInfo.first?.reminderTime  // personalInfo.first --> [PersonalInfo]的first(第0項） --> PesonalInfo
        } catch {
            print("Error fetching reminderTime: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
    func setReminderTime(newReminderTime: Date?) {
        
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<PersonalInfo> = PersonalInfo.fetchRequest()
        
        //setPassword有兩種情況 (1. 已經有密碼（改密碼)  2. 還沒有密碼
        //情況1. 把現有的passcode拿下來並取代 --> context.fetch(fetchRequest).first
        //情況2. fetch不到東西（nil)（因為沒密碼），就"新增"一個 PersonalInfo 放資料 --> PersonalInfo(context: context)
        do {
            let personalInfo = try context.fetch(fetchRequest).first ?? PersonalInfo(context: context)
            
            personalInfo.reminderTime = newReminderTime
            print(newReminderTime)
            
            //最後存到coreData
            try context.save()
            
        } catch {
            print("Error setting reminderTime: \(error.localizedDescription)")
        }
    }
    
    
//    func deletePassword() {
//
//            let context = persistentContainer.viewContext
//
//            let fetchRequest: NSFetchRequest<PersonalInfo> = PersonalInfo.fetchRequest()
//
//            do {
//                let personalInfo = try context.fetch(fetchRequest).first ?? PersonalInfo(context: context)
//
//                context.delete(personalInfo)
//
//                //最後保存變更
//                try context.save()
//
//            } catch {
//                print("Error setting passcode: (error.localizedDescription)")
//            }
//        }
    
}
