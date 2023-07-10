////
////  LaunchViewController.swift
////  MoodApp
////
////  Created by 簡莉芯 on 2023/7/10.
////
//
//import UIKit
//
//class LaunchViewController: UIViewController {
//
//    let imageView = UIImageView(image: UIImage(systemName: "image 13"))
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        launchScreenAnimation()
//        
//        UIView.animate(withDuration: 3.0,
//                       delay: 0,
//                       options: [.repeat, .autoreverse],
//                       animations: {
//                        self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//        }, completion: nil)
//    }
//    
//
////    private func launchScreenAnimation() {
////        guard let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController() else { return }
////
////        self.view.addSubview(launchScreen.view)
////
////        if let imageView = launchScreen.view.viewWithTag(1) as? UIImageView {
////            UIView.animate(withDuration: 3,
////                           delay: 0,
////                           options: .curveEaseOut,
////                           animations: {
////                            imageView.transform = CGAffineTransform(rotationAngle: .pi)
////                            imageView.transform = .identity
////                            launchScreen.view.alpha = 0
////            }) {(finished) in
////                launchScreen.view.removeFromSuperview()
////            }
////        }
////    }
//
//}
