//
//  CardView.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 9/3/26.
//

import SwiftUI

struct CardView: View {
    let card: HiLoGame.Card
    let width: CGFloat
    
    private var size: CGSize {
        CGSize(width: width, height: width * 1.55)
    }
    
    var body: some View {
        CardFlipView(
            front: cardFront(),
            back: cardBack(),
            angle: card.isFaceUp ? 0 : 180
        )
        .frame(width: size.width, height: size.height)
        .animation(.easeInOut(duration: 0.5), value: card.isFaceUp)
    }
    
    // This is the View for the back of the card
    private func cardBack() -> some View {
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
        
    //This is the View of the front of the card with the number and corner symbols
    private func cardFront() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: width * 0.2)
                .fill(colorForIndex(card.value))
                .frame(width: size.width, height: size.height)
            cardFrontNumber()
            cardFrontCorner()
                .offset(x: -width * 0.28, y: -size.height * 0.35)
            cardFrontCorner()
                .rotationEffect(.degrees(180))
                .offset(x: width * 0.28, y: size.height * 0.35)
        }
    }
    
    // This is the function that makes the colors change with the number of the card
    private func colorForIndex(_ index: Int) -> Color {
        let hue = Double(index) / 100.0
        return Color(hue: hue, saturation: 0.8,
                     brightness: 1)
    }
    
    // This is a function that switches through the numbers and displays the proper corner symbol (nil for cards not ending in 0, 1, or 2)
    func symbol(for number: Int) -> SpecialSymbol? {
        switch number % 10 {
        case 0: return .tenPoint
        case 1: return .skip
        case 2: return .mustPlaySecond
        default: return nil
        }
    }
    
    @ViewBuilder
    private func symbolShape(for symbol: SpecialSymbol) -> some View {
        switch symbol {
        case .tenPoint: TenPointSymbol().scaleEffect(0.8)
        case .skip: SkipSymbol()
        case .mustPlaySecond: MustPlaySecondSymbol()
        }
    }
    
    // This function displays the corner symbol of the specialty cards, using what is contained in the SpecialSymbols enum.
    @ViewBuilder
    private func cornerSymbol(for number: Int) -> some View {
        if let symbol = symbol(for: number) {
            ZStack {
                Circle()
                    .fill(.white)
                symbolShape(for: symbol)
                    .foregroundStyle(.black)
            }
            .frame(width: width * 0.28, height: width * 0.28)
        }
    }
    
    func cardFrontCorner() -> some View {
            cornerSymbol(for: card.value)
    }
    
    private func cardFrontNumber() -> some View {
        ZStack {
            Circle()
                .foregroundStyle(.black)
            Text("\(card.value)")
                .foregroundStyle(.white)
                .bold()
                .font(.system(size: width * 0.38))
                .fontDesign(.serif)
                .minimumScaleFactor(0.5)
        }
        .frame(width: width * 0.6, height: width * 0.6)
    }
}

#Preview {
    VStack {
        HStack {
            CardView(card: HiLoGame.Card(value: 20), width: 80)
            CardView(card: HiLoGame.Card(value: 41), width: 100)
        }
        HStack {
            CardView(card: HiLoGame.Card(value: 62), width: 120)
            CardView(card: HiLoGame.Card(value: 83), width: 140)
        }
    }
}
