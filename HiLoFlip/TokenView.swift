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
    var body: some View {
        ZStack {
            tokenCircle()
            Text(side.label)
                .bold()
                .foregroundStyle(Color.white)
                .font(.system(size: 40))
        }
    }
    
    func tokenCircle() -> some View {
        ZStack {
            Circle()
                .fill(.black)
                .frame(width: 150, height: 150)
            Circle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: 130, height: 130)
        }
    }
    
}

#Preview {
    TokenView(side: .hi)
}
