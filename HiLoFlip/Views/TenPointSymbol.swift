//
//  TenPointSymbol.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 10/13/26.
//

import SwiftUI

struct TenPointSymbol: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let side = min(rect.width, rect.height)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = side / 2
        let innerRadius = outerRadius * 0.4
        
        path.move(to: CGPoint(x: rect.midX, y: center.y - outerRadius))
        path.addLine(to: CGPoint(
            x: center.x + innerRadius * cos(Angle(degrees: -54).radians),
            y: center.y + innerRadius * sin(Angle(degrees: -54).radians)))
        path.addLine(to: CGPoint(
            x: center.x + outerRadius * cos(Angle(degrees: -18).radians),
            y: center.y + outerRadius * sin(Angle(degrees: -18).radians)))
        path.addLine(to: CGPoint(
            x: center.x + innerRadius * cos(Angle(degrees: 18).radians),
            y: center.y + innerRadius * sin(Angle(degrees: 18).radians)))
        path.addLine(to: CGPoint(
            x: center.x + outerRadius * cos(Angle(degrees: 54).radians),
            y: center.y + outerRadius * sin(Angle(degrees: 54).radians)))
        path.addLine(to: CGPoint(
            x: center.x + innerRadius * cos(Angle(degrees: 90).radians),
            y: center.y + innerRadius * sin(Angle(degrees: 90).radians)))
        path.addLine(to: CGPoint(
            x: center.x + outerRadius * cos(Angle(degrees: 126).radians),
            y: center.y + outerRadius * sin(Angle(degrees: 126).radians)))
        path.addLine(to: CGPoint(
            x: center.x + innerRadius * cos(Angle(degrees: 162).radians),
            y: center.y + innerRadius * sin(Angle(degrees: 162).radians)))
        path.addLine(to: CGPoint(
            x: center.x + outerRadius * cos(Angle(degrees: 198).radians),
            y: center.y + outerRadius * sin(Angle(degrees: 198).radians)))
        path.addLine(to: CGPoint(
            x: center.x + innerRadius * cos(Angle(degrees: 234).radians),
            y: center.y + innerRadius * sin(Angle(degrees: 234).radians)))
        path.closeSubpath()
    
        
        return path
    }
}

#Preview {
    TenPointSymbol()
}
