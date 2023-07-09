//
//  FaceDetectionManager.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/7/9.
//

import UIKit
import AVFoundation
import Vision

class FaceDetectionManager: NSObject {
    
    static let shared = FaceDetectionManager()
    
    // 配置和控制相機
    private var captureSession: AVCaptureSession?
//    private var videoPreview: AVCaptureVideoPreviewLayer? //用來顯示鏡頭畫面
    //儲存偵測到臉後的function
    private var faceDetectionRequest: VNRequest?
    
    //建立另一個thread (才能在使用app時，同時進行臉部偵測）
    private let videoOutputQueue = DispatchQueue(label: "videoOutputQueue", qos: .background)
    
//    private override init() {}
    
    
    func startCamera() {
        
        videoOutputQueue.async { //非同步，個做個的事
            //初始化 AVCaptureSession
            self.captureSession = AVCaptureSession()
            self.captureSession?.sessionPreset = .photo //解析度
        //I. 先設定 臉部辨識 要用到的相機
        //配置相機輸入
            guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
                else { return }
            
            guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
            self.captureSession?.addInput(input)
            
        //配置相機輸出
            let videoOutput = AVCaptureVideoDataOutput()
            // delegate --> 建立 videoOutput 和 faceDetectionManager 的通道
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .background))
            self.captureSession?.addOutput(videoOutput)
            
        // 創建臉部偵測的請求
            // 在這邊先設定好拿到資料後，要執行的“人臉辨識請求” （VNDetectFaceRectanglesRequest）
            // 收到相機資料後才會perform faceDetectionRequest
            self.faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaceDetection)
            
        //II. 開始擷取
            self.captureSession?.startRunning()
        }
    }
    
    
    func stopCamera() {
        print("camera stop")
        
        self.captureSession?.stopRunning()
    }
    
}


extension FaceDetectionManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    //III. 執行start running後，把在videoOutput接受到的影像，傳來faceDetectionManager處理
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // 在背景佇列中執行臉部偵測
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        do {
            //執行先前設定好的“人臉辨識請求”
            try imageRequestHandler.perform([self.faceDetectionRequest!])
        } catch {
            print("臉部偵測錯誤: \(error)")
        }
    }
    
}


extension FaceDetectionManager {
    
    //IV. 執行辨識完後，處理結果
    private func handleFaceDetection(request: VNRequest, error: Error?) {
        
        guard let observations = request.results as? [VNFaceObservation] else { return }
        print(observations.count)
        
        //偵測到臉部數量
        if observations.count >= 2 {
            // 超過兩個人臉，顯示警告
            DispatchQueue.main.async { //回到main thread (寫UI)
                let controller = UIAlertController(title: "警告", message: "偵測到超過兩個人臉！", preferredStyle: .alert)
                let action = UIAlertAction(title: "確定", style: .default)
                
                controller.addAction(action)
                //找rootVC(自己找到所位於的畫面VC)，跳alert
                if let currentViewController = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController ?? UIApplication.shared.keyWindow?.rootViewController {
                    currentViewController.present(controller, animated: true)
                }
                
            }
        }
    }
}

