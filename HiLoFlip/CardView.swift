//
//  CardView.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 9/3/26.
//

import SwiftUI

struct CardView: View {
    var card: HiLoGame.Card
    var body: some View {
        if card.isFaceUp {
            faceUpView
        } else {
            faceDownView
        }
    }
    
    // This is the View for the back of the card
    private func cardBack() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 100, height: 155)
                .foregroundStyle(.black)
            cardBackCircleBottom()
            cardBackCircleTop()
        }
        .padding(10)
    }
    
    // this function and the next are the "HI" and "LO" circles on the back of the card
    private func cardBackCircleBottom() -> some View {
        ZStack {
            Circle()
                .stroke(Color.white, lineWidth: 1)
                .frame(width: 50)
                .offset(x: 18, y: 35)
            Text("LO")
                .foregroundStyle(Color.white)
                .bold()
                .font(.system(size: 20))
                .offset(x: 18, y: 35)
        }
    }
    private func cardBackCircleTop() -> some View {
        ZStack {
            Circle()
                .stroke(Color.white, lineWidth: 1)
                .frame(width: 50)
                .offset(x: -18, y: -35)
            Text("HI")
                .foregroundStyle(Color.white)
                .bold()
                .font(.system(size: 20))
                .offset(x: -18, y: -35)
        }
    }
    
    //This is the View of the front of the card with the number and corner symbols
    private func cardFront() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(colorForIndex(card.value))
                .frame(width: 100, height: 155)
            cardFrontNumber()
            cardFrontCorner()
                .offset(x: 28, y: 54)
            cardFrontCorner()
                .offset(x: -28, y: -54)
        }
    }
    
    // This is the function that makes the colors change with the number of the card
    func colorForIndex(_ index: Int) -> Color {
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
    
    // This function displays the corner symbol of the specialty cards, using what is contained in the SpecialSymbols enum.
    func cornerSymbol(for number: Int) -> some View {
        Group {
            if let symbol = symbol(for: number) {
                ZStack {
                    Circle()
                        .fill(.white)
                    Image(systemName: symbol.sfSymbolName)
                        .foregroundStyle(.black)
                }
            }
        }
    }
    
    func cardFrontCorner() -> some View {
        ZStack {
            cornerSymbol(for: card.value)
                .frame(width: 28)
        }
    }
    
    func cardFrontNumber() -> some View {
        ZStack {
            Circle()
                .frame(width: 60)
                .foregroundStyle(.black)
            Text(String(card.value))
                .foregroundStyle(Color.white)
                .bold()
                .font(.system(size: 35))
        }
    }
    
    // These two variables define what is face up view and what is face down view (seeing card front vs. card back)
    var faceUpView: some View { cardFront() }
    
    var faceDownView: some View { cardBack() }
    
}

#Preview {
    CardView(card: HiLoGame.Card(value: 40))
}
