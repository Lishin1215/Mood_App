//
//  LoginContentView.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/7/5.
//

import SwiftUI

struct LoginContentViewTest: View {
    
    let images = ["image 8", "image 13", "image 22", "image 25", "image 7"]
    let radius: CGFloat = 140
    
    @State private var animation: Double = 0.0
   
    var body: some View {
        
        GeometryReader { geometry in
            content(with: geometry)
        }
    }
    
    private func content(with geometry: GeometryProxy) -> some View {
        ZStack {
            
            Circle()
                .foregroundColor(.blue)
                .frame(width: radius * 2, height: radius * 2)
                .position(x: geometry.size.width/2 , y: geometry.size.height/2)
            
            ForEach(0..<images.count) { index in
                
                let angle = 2 * CGFloat.pi * CGFloat(index) / CGFloat(images.count)
                let xAxis = radius * cos(angle) + geometry.size.width / 2
                let yAxis = radius * sin(angle) + geometry.size.height / 2
                
                Image(images[index])
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .frame(width: 60, height: 60)
                   .position(x: xAxis, y: yAxis)
                
                }
            }
        }
        
//       private func angle(at index: Int) -> Double {
//            let totalAngle = 360.0
//            return totalAngle/Double(images.count) * Double(index)
//        }

    }

//struct RotatingImage: View {
//
//    let imageName: String
//    let angle: Double
//    let size: CGSize
//
//    var body: some View {
//        let xAxis = size.width/2 + cos(angle) * size.width/2 * 0.8
//        let yAxis = size.width/2 + sin(angle) * size.width/2 * 0.8
//
//        return Image(imageName)
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .frame(width: size.width * 0.2, height: size.width * 0.2)
//            .position(x: xAxis, y: yAxis)
//    }
//}
    
struct LoginContentViewTest_Previews: PreviewProvider {
    static var previews: some View {
        LoginContentViewTest()
    }
}

