//
//  HomeView.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 11/3/26.
//

import SwiftUI

struct HomeView: View {
    @State private var game = HiLoFlipCardGame(
        playerNames: ["Player 1", "Player 2"]
    )
    @State private var showGame = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("HiLo Flip")
                    .font(.largeTitle)
                    .fontDesign(.monospaced)
                newGameButton()
                settingsButton()
                instructionsButton()
            }
            .navigationDestination(isPresented: $showGame) {
                GameView(game: game)
            }
        }
    }
    
    private func newGameButton() -> some View {
        Button("New Game") {
            game.resetGame()
            showGame = true
        }
        .buttonStyle(.borderedProminent)
    }
    
    private func settingsButton() -> some View {
        NavigationLink {
            SettingsView(game: game)
        } label: { Text("Settings") }.buttonStyle(.bordered)
    }
    
    private func instructionsButton() -> some View {
        NavigationLink {
            InstructionsView()
        } label: { Text("Instructions") }.buttonStyle(.bordered)
    }
    
}

#Preview {
    HomeView()
}
