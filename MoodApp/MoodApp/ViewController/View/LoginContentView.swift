//
//  LoginContentView.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/7/5.
//

import SwiftUI

struct LoginContentView: View {
    
//    let images = ["image 8", "image 13", "image 22", "image 25", "image 7"]
    
    @State private var animation: Double = 0.0
    var moodImage: String = "image 13"
    
    
    init(moodImage: String) {
        self.moodImage = moodImage
    }
    
    var body: some View {
        
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            Image(moodImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
                .clipShape(Circle())
                .shadow(radius: 20)
                .rotation3DEffect(.degrees(animation), axis: (x: 0, y: 1, z: 0.2))
                .onTapGesture {
                    withAnimation(.interpolatingSpring(stiffness: 20, damping: 5)) {
                        self.animation += 360
                    }
                }
        }
    }
    
}


    
struct LoginContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginContentView(moodImage: "image 13")
    }
}

