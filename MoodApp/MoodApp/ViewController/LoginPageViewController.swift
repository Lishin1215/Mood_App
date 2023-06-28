//
//  LoginPageViewController.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/6/26.
//

import UIKit
import AuthenticationServices // Sign in with Apple 的主體框架

class LoginPageViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let authorizationAppleIDButton = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
        authorizationAppleIDButton.cornerRadius = 8
        authorizationAppleIDButton.addTarget(self, action: #selector(pressSignInWithAppleButton), for: UIControl.Event.touchUpInside)
        view.addSubview(authorizationAppleIDButton)
        
        authorizationAppleIDButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorizationAppleIDButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authorizationAppleIDButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
    
    
//    // 淺色模式就顯示黑色的按鈕，深色模式就顯示白色的按鈕
//    func chooseAppleButtonStyle() -> ASAuthorizationAppleIDButton.Style {
//        return (UITraitCollection.current.userInterfaceStyle == .light) ?.black: .white
//    }
    
    
    // 點擊 Sign In with Apple 按鈕後，請求授權
    @objc func pressSignInWithAppleButton() {
        let authorizationAppleIDRequest: ASAuthorizationAppleIDRequest = ASAuthorizationAppleIDProvider().createRequest()
        authorizationAppleIDRequest.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [authorizationAppleIDRequest])
        
        controller.delegate = self
        controller.presentationContextProvider = self //告知 ASAuthorizationController 該呈現在哪個 Window 上
        
        controller.performRequests()
    }
    

}

extension LoginPageViewController: ASAuthorizationControllerDelegate {
    
    // 授權成功
    // - Parameters:
    //   - controller: _
    //   - authorization: _
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("user: \(appleIDCredential.user)") // Apple 唯一識別碼，該值在同一個開發者帳號下所有的 App 都會是一樣的
            print("fullName: \(String(describing: appleIDCredential.fullName))")
            print("Email: \(String(describing: appleIDCredential.email))")
            print("realUserStatus: \(String(describing: appleIDCredential.realUserStatus))")
            print("Authorization Code: \(String(describing: appleIDCredential.authorizationCode))")
            print("Identity Token: \(String(describing: appleIDCredential.identityToken))")
        }
    }
    
    // 授權失敗
    // - Parameters:
    //   - controller: _
    //   - error: _
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
