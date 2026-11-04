//
//  TokenView.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 9/3/26.
//

import SwiftUI

// This code is the token. I call on it in the body of the GameView
struct TokenView: View {
    let side: TokenSide
    let width: CGFloat
    var body: some View {
        ZStack {
            tokenCircle()
            Text(side.label)
                .bold()
                .foregroundStyle(.white)
                .font(.system(size: width * 0.27))
                .contentTransition(.opacity)
        }
        .frame(width: width, height: width)
    }
    
    func tokenCircle() -> some View {
        ZStack {
            Circle()
                .fill(.black)
            Circle()
                .stroke(Color.white, lineWidth: width / 75)
                .padding(width / 15)
        }
    }
    
}

#Preview {
    TokenView(side: .hi, width: 50)
}
