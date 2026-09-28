//
//  HiLoFlipCardGame.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 9/28/26.
//

import Foundation

@Observable
class HiLoFlipCardGame {
    private var game: HiLoGame
    var players: [HiLoGame.Player] { game.players }
    var isTokenHi: Bool { game.isTokenHi }
    
    init(playerNames: [String]) {
        game = HiLoGame(playerNames: playerNames)
    }
    
    func resetGame() {
        game.resetGame()
    }
    
    func hand(for player: HiLoGame.Player) -> [HiLoGame.Card] {
        player.hand
    }
}
