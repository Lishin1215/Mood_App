//
//  AppDelegate.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/14.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import IQKeyboardManagerSwift
import UserNotifications

//@main
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        //自己產生一個window
//        window = UIWindow(frame: UIScreen.main.bounds)
        
    //IQKeyboard
        IQKeyboardManager.shared.enable = true
        
    //firebase
        FirebaseApp.configure()
        
    //local notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(granted, error) in
            if granted {
                print("允許")
            } else {
                print("不允許")
            }
        })
        //代理UNUserNotificationCenterDelegate，這麼做可讓 App 在“前景”狀態下收到通知
        UNUserNotificationCenter.current().delegate = self
          
        
        // 使用keyChain與siri共用資料（因為在intent handler拿不到uid，所以要在moodApp裡寫這段，讓moodApp跟intent handler可以一起加入keychain，共用資料）
        if let keyChainGroup = Bundle.main.infoDictionary?["KeyChainGroup"] as? String {
            print(keyChainGroup)
            do {
                try Auth.auth().useUserAccessGroup(keyChainGroup)
                
            } catch let error as NSError {
                print("Error changing user access group: %@", error)
            }
        } else {
            print("KeyChainGroup is nil")
        }
        return true
        
    }
      
    
//local notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping(UNNotificationPresentationOptions) -> Void) {
            
            print("在前景收到通知...")
            completionHandler([.badge, .sound, .alert])
        }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

