//
//  GameView.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 9/3/26.
//

import SwiftUI

// This is the GameView. It calls on both CardView and TokenView. i have a columns constant (for the LazyVgrid), currentCards count, and isTokenHI bool.
struct GameView: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State var currentCards: [Int] = []
    @State var tokenSide: TokenSide = .hi
    
    // In the view body, we are displaying everything. ScrollView contains a ForEach loop to ensure I am displaying the correct number of cards in the LazyVGrid.
    var body: some View {
        ZStack {
            Color("GameViewGreen")
                .ignoresSafeArea()
            VStack {
                HStack {
                    TokenView(side: tokenSide)
                    shuffleButton
                }
                .padding(.horizontal)
                .padding(.top)
                ScrollView {
                    LazyVGrid (columns : columns) {
                        ForEach( currentCards, id: \.self) {
                            number in CardView(number: number)
                        }
                    }
                }
            }
        }
        .onAppear {
            dealNewHand()
        }
    }
    
    // This function is what flips the token and deals out new, shuffled cards
    private func dealNewHand() {
        tokenSide = Bool.random() ? .hi : .lo
        var deck = Array(1...100)
        deck.shuffle()
        currentCards = Array(deck.prefix(7))
    }
    
    // This variable is the button which calls on dealNewHand()
    var shuffleButton : some View {
        Button(action: {
            dealNewHand()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 125, height: 50)
                Text("Shuffle")
                    .foregroundStyle(Color.white)
            }
        }
    }
}

#Preview {
    GameView()
}
