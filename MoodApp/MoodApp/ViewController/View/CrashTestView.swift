//
//  CrashTestView.swift
//  MoodApp
//
//  Created by 簡莉芯 on 2023/7/5.
//

import SwiftUI

struct ContentView: View {
    func buttonTap() {
        fatalError()
    }
    var body: some View {
        Button(action: buttonTap, label: {
            Text("Crash 吧，App")
                .font(.system(size: 50))
        })
    }
}
