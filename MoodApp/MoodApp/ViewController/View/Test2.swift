////
////  Test2.swift
////  MoodApp
////
////  Created by 簡莉芯 on 2023/7/10.
////
//
//import SwiftUI
//
//struct TestContentView: View {
//    let images = ["image1", "image2", "image3", "image4", "image5"]
//    let radius: CGFloat = 100
//    
//    @State private var rotationAngles: [Double] = Array(repeating: 0.0, count: 5)
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                Circle()
//                    .foregroundColor(.blue)
//                    .frame(width: radius * 2, height: radius * 2)
//                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
//                
//                ForEach(0..<images.count) { index in
//                    RotatingImage(imageName: images[index], angle: angle(at: index), radius: radius)
//                        .onTapGesture {
//                            // 在 RotatingImage 视图中实现旋转动画
//                            withAnimation(.interpolatingSpring(stiffness: 20, damping: 5)) {
//                                rotationAngles[index] += 360
//                            }
//                        }
//                }
//            }
//        }
//    }
//    
//    private func angle(at index: Int) -> CGFloat {
//        let totalAngle = 360.0
//        return CGFloat(totalAngle / Double(images.count) * Double(index))
//    }
//}
//
//struct RotatingImage: View {
//    let imageName: String
//    let angle: CGFloat
//    let radius: CGFloat
//    
//    @State private var rotationAngle: Double = 0.0
//    
//    var body: some View {
//        let xAxis = radius * cos(angle) + radius
//        let yAxis = radius * sin(angle) + radius
//        
//        return Image(imageName)
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .frame(width: 50, height: 50)
//            .position(x: xAxis, y: yAxis)
//            .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: 1, z: 0.2))
//    }
//}
//
//struct TestContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestContentView()
//    }
//}
