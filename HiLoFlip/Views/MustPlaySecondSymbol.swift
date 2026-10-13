//
//  MustPlaySecondSymbol.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 10/13/26.
//

import SwiftUI

struct MustPlaySecondSymbol: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        var cutout = Path()
        let side = min(rect.width, rect.height)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let cardSize = CGSize(width: side * 0.4, height: side * 0.6)
        let offset = CGSize(width: side * 0.05, height: side * 0.05)
        let gap = side * 0.02
        
        let backCard = CGRect(
            x: center.x - (cardSize.width / 2) - offset.width,
            y: center.y - (cardSize.height / 2) - offset.height,
            width: cardSize.width,
            height: cardSize.height
        )
        
        let frontCard = CGRect(
            x: center.x - (cardSize.width / 2) + offset.width,
            y: center.y - (cardSize.height / 2) + offset.height,
            width: cardSize.width,
            height: cardSize.height
        )
        
        path.addRoundedRect(in: backCard, cornerSize: CGSize(width: side * 0.05, height: side * 0.05))
        cutout.addRoundedRect(in: frontCard.insetBy(dx: -gap, dy: -gap), cornerSize: CGSize(width: (side * 0.05) + gap, height: (side * 0.05) + gap))
        path = path.subtracting(cutout)
        path.addRoundedRect(in: frontCard, cornerSize: CGSize(width: side * 0.05, height: side * 0.05))
    
        return path
    }
}

#Preview {
    MustPlaySecondSymbol()
}
