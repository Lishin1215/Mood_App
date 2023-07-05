//
//  LoginPageViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/26.
//

import UIKit
import AuthenticationServices // Sign in with Apple 的主體框架
import CryptoKit // 用來產生隨機字串 (Nonce) 的
import FirebaseAuth // 用來與 Firebase Auth 進行串接用的

protocol LoginVCDelegate: AnyObject {
    func didReceiveAuthCode(authCode: String)
}


class LoginPageViewController: UIViewController {

    
    fileprivate var currentNonce: String?
    
    //delegate
    weak var delegate: LoginVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let authorizationAppleIDButton = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
        authorizationAppleIDButton.cornerRadius = 8
        authorizationAppleIDButton.addTarget(self, action: #selector(pressSignInWithAppleButton), for: UIControl.Event.touchUpInside)
        view.addSubview(authorizationAppleIDButton)
        
        authorizationAppleIDButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorizationAppleIDButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authorizationAppleIDButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            authorizationAppleIDButton.heightAnchor.constraint(equalToConstant: 45),
            authorizationAppleIDButton.widthAnchor.constraint(equalToConstant: 310)
        ])
    }
    
    
//    // 淺色模式就顯示黑色的按鈕，深色模式就顯示白色的按鈕
//    func chooseAppleButtonStyle() -> ASAuthorizationAppleIDButton.Style {
//        return (UITraitCollection.current.userInterfaceStyle == .light) ?.black: .white
//    }
    
    
    // 點擊 Sign In with Apple 按鈕後，請求授權
    @objc func pressSignInWithAppleButton() {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        
        // ***Generate nonce for validation after authentication successful
        self.currentNonce = randomNonceString()
        
        //*** Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
        request.nonce = sha256(currentNonce!)
        
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self //告知 ASAuthorizationController 該呈現在哪個 Window 上
        
        controller.performRequests()
    }
    
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }

    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    

    
    //傳資料到homePage
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        //確認傳遞要項無誤
        if segue.identifier == "loginSegue" {
//            if let dateComponents = sender as? DateComponents,
              if let segueVC = segue.destination as? TabBarViewController {
                //將任意點到的product資料，傳給newPageVC
//                segueVC.dateComponents = dateComponents

            }
        }
    }
}


extension LoginPageViewController: ASAuthorizationControllerDelegate {
    
    // 授權成功
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            //I
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            //II
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            //III
            guard let appleAuthCode = appleIDCredential.authorizationCode else {
                print("Unable to fetch authorization code")
                return
              }
            // authCodeString是revoke帳號需要的憑證（跟uid不同），在SettingViewController刪除帳號時用到
            guard let authCodeString = String(data: appleAuthCode, encoding: .utf8) else {
                print("Unable to serialize auth code string from data: \(appleAuthCode.debugDescription)")
                return
              }
            //用delegate傳到settingsVC (點選“刪帳號”時要使用)
            print("@@@ +\(authCodeString)")
            self.delegate?.didReceiveAuthCode(authCode: authCodeString)
            
            
            //Initialize a "Firebase credential", including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
            
            
            //Sign in with Firebase
            firebaseSignInWithApple(credential: credential)
        }
    }
    
    // 授權失敗
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        switch (error) {
        case ASAuthorizationError.canceled:
            break
        case ASAuthorizationError.failed:
            break
        case ASAuthorizationError.invalidResponse:
            break
        case ASAuthorizationError.notHandled:
            break
        case ASAuthorizationError.unknown:
            break
        default:
            break
        }
        
        print("didCompleteWithError: \(error.localizedDescription)")
    }
}


//告知 ASAuthorizationController 該呈現在哪個 Window 上
extension LoginPageViewController: ASAuthorizationControllerPresentationContextProviding {
    // - Parameter controller: _
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (self.view?.window)!
    }
    
}

//透過Credential與Firebase Auth進行串接
extension LoginPageViewController {

//sign in
    func firebaseSignInWithApple(credential: AuthCredential) {
        
        
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            if (error != nil) { //有錯誤
                print(error?.localizedDescription)
                return
            }
            // 在登入同時，偵測系統預設語言，存到CoreData
            LocalizeUtils.shared.settingUserLanguageCode()
            // User is signed in to Firebase with Apple.
            // fireStore setData
            if let user = authResult?.user {
                let uid = user.uid
                print("用戶的UID: \(uid)")
                //*** uid直接存到fireStore manager裡
                FireStoreManager.shared.setUserId(userId: uid)
                
                // 到homePage (tabBar入口）
                self?.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "tabBarVC") as? TabBarViewController {
//                self.navigationController?.pushViewController(tabBarVC, animated: true)
//            }


            print("success")
        }
    }
    
}
