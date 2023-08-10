//
//  SceneDelegate.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/14.
//

import UIKit
import Intents
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // 建立捷徑讓siri可以呼叫app
    private func donateIntent() {
        let intent = RecordMoodIntent() // 系統自動會有
        intent.suggestedInvocationPhrase = "Record Mood"  // 呼叫捷徑“要說的話” //siri要調成英文版
        
        let interaction = INInteraction(intent: intent, response: nil) // 建立互動
        interaction.donate { (error) in // 在iphone上建立捷徑
            if error != nil {
                if let error = error as? NSError {
                    print("Donate failed")
                } else {
                    print("Successfully donated interation")
                }
            }
        }
        
    }

    
//第一次打開app執行
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        
    // 避免已經login但coreData被刪除的情況
        if StorageManager.shared.fetchLanguage() == nil {

            // 偵測系統預設語言，存到CoreData
            LocalizeUtils.shared.settingUserLanguageCode()
        }
        
        
    // signin with apple
        // 目前有user（已登入） -> HomeVC
        
        if let currentUser = Auth.auth().currentUser {
            print("already log in")
            
//            do {
//                try Auth.auth().useUserAccessGroup("Janet.MoodApp.auth")
//            } catch let error as NSError {
//                print("Error changing user access group: %@", error)
//            }
            
            let uid = currentUser.uid
            print(uid)
            // 把登入後的credential(uid)放入userId
            FireStoreManager.shared.setUserId(userId: uid)
            
    // user == nil (未登入） -> LoginVC
        } else {
            print("not log in yet")

            // 跳login Page
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginPageViewController {
                    
                    self.window?.rootViewController = loginVC
                    self.window?.makeKeyAndVisible()
                }
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    
    //＊＊＊設定打開時需要輸入密碼
    func sceneWillEnterForeground(_ scene: UIScene) {
        
        if StorageManager.shared.fetchPassword() != nil {

            //先拿畫面的storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let passwordVC = storyboard.instantiateViewController(withIdentifier: "PasswordVC") as? PasswordViewController {
                self.window?.rootViewController = passwordVC
                self.window?.makeKeyAndVisible()
            }

        }
            
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

