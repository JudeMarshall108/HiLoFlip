//
//  SettingsView.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 11/3/26.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var game: HiLoFlipCardGame
    @AppStorage("player1Name") private var playerOneName = "Player 1"
    @AppStorage("player2Name") private var playerTwoName = "Player 2"
    @AppStorage("showDeckCount") private var showDeckCount = true
    
    var body: some View {
        Form {
            TextField("Player 1", text: $playerOneName)
            TextField("Player 2", text: $playerTwoName)
            Toggle("Show deck count", isOn: $showDeckCount)
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView(game: HiLoFlipCardGame(playerNames: ["Player 1", "Player 2"]))
}
