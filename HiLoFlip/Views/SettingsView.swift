//
//  SettingsView.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 11/3/26.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var game: HiLoFlipCardGame
    
    var body: some View {
        Form {
            TextField("Player 1", text: $game.playerOneName)
            TextField("Player 2", text: $game.playerTwoName)
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView(game: HiLoFlipCardGame(playerNames: ["Player 1", "Player 2"]))
}
