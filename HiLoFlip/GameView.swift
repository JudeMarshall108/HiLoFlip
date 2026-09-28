//
//  GameView.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 9/3/26.
//

import SwiftUI


struct GameView: View {
    var game = HiLoFlipCardGame(playerNames: ["Player 1", "Player 2"])
    
    var body: some View {
        ZStack {
            Color("GameViewGreen")
                .ignoresSafeArea()
            VStack {
                cardGrid(0)
                topBar()
                cardGrid(1)
            }
        }
    }
    
    // This variable is the button which calls on dealNewHand()
    var shuffleButton : some View {
        Button(action: {
            game.resetGame()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 125, height: 50)
                Text("Shuffle")
                    .foregroundStyle(Color.white)
            }
        }
    }
    
    func topBar() -> some View {
        HStack {
            TokenView(side: game.isTokenHi ? .hi : .lo)
            shuffleButton
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    func cardGrid(_ playerIndex: Int) -> some View {
        ScrollView {
            LazyVGrid (columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ]) {
                ForEach( game.hand(for: game.players[playerIndex]), id: \.value) {
                    card in CardView(card: card)
                }
            }
        }
    }
    
}

#Preview {
    GameView()
}
