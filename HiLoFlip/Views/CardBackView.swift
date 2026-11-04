//
//  CardBackView.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 11/3/26.
//

import SwiftUI

struct CardBackView: View {
    let width: CGFloat
    
    private var size: CGSize {
        CGSize(width: width, height: width * 1.55)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: width * 0.2)
                .fill(.black)
                .frame(width: size.width, height: size.height)
            backCircle("LO")
                .offset(x: -width * 0.18, y: -size.height * 0.23)
            backCircle("HI")
                .offset(x: width * 0.18, y: size.height * 0.23)
        }
    }
        private func backCircle(_ title: String) -> some View {
            ZStack {
                Circle()
                    .stroke(.white, lineWidth: width * 0.01)
                Text(title)
                    .foregroundStyle(.white)
                    .bold()
                    .font(.system(size: width * 0.2))
            }
            .frame(width: width * 0.5, height: width * 0.5)
        }
    }

#Preview {
    CardBackView(width: 80)
}
