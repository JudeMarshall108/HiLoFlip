//
//  SkipSymbol.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 10/13/26.
//

import SwiftUI

struct SkipSymbol: Shape {
    
    func path(in rect: CGRect) -> Path {
        let side = min(rect.width, rect.height)
        let square = CGRect(x: rect.midX - side / 2, y: rect.midY - side / 2,
                            width: side, height: side)
        var path = Path()
        path.addEllipse(in: square)
        path.addPath(slash(in: square))
        let outline = path.strokedPath(StrokeStyle(lineWidth: side * 0.15, lineCap: .round))
        return scaled(outline, around: CGPoint(x: rect.midX, y: rect.midY))
    }
    
    private func slash(in square: CGRect) -> Path {
        let radius = square.width / 2
        let angle = Angle(degrees: 45).radians
        var path = Path()
        path.move(to: CGPoint(x: square.midX - radius * cos(angle),
                             y: square.midY - radius * sin(angle)))
        path.addLine(to: CGPoint(x: square.midX + radius * cos(angle),
                                y: square.midY + radius * sin(angle)))
        return path
    }
    
    private func scaled(_ path: Path, around center: CGPoint) -> Path {
        path.applying(
            CGAffineTransform(scaleX: 0.5, y: 0.5)
                .translatedBy(x: center.x, y: center.y)
        )
    }
    
}

#Preview {
    SkipSymbol()
}
