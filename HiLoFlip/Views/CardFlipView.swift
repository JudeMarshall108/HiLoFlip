//
//  CardFlipView.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 10/13/26.
//

import SwiftUI

struct CardFlipView<Front: View, Back: View>: View, Animatable {
    let front: Front
    let back: Back
    var angle: Double
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    
    var body: some View {
        ZStack {
            front
                .opacity(angle < 90 ? 1 : 0)
            back
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
                .opacity(angle >= 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle(degrees: angle), axis: (x: 0, y: 1, z: 0), perspective: 0.5)
    }
}

#Preview {
    CardFlipView(
        front: Text("FRONT")
            .frame(width: 100, height: 155)
            .background(.yellow),
        back: Text("BACK")
            .frame(width: 100, height: 155)
            .background(.blue),
        angle: 0
    )
}
