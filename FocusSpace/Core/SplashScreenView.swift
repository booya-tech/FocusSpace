//
//  SplashScreenView.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 10/5/25.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            Image("splash-screen")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
        }
    }
}

#Preview {
    SplashScreenView()
}
