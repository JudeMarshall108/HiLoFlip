//
//  HiLoFlipCardGame.swift
//  HiLoFlip
//
//  Created by Jude Burdick on 9/28/26.
//

import Foundation

@Observable
class HiLoFlipCardGame {
    private var game: HiLoGame {
        didSet {
            saveGame()
        }
    }
    var players: [HiLoGame.Player] { game.players }
    var isTokenHi: Bool { game.isTokenHi }
    var currentPlayerIndex: Int { game.currentPlayerIndex }
    var topDiscard: HiLoGame.Card? { game.discardPile.last }
    var deckCount: Int { game.deck.count }
    var winnerIndex: Int? { game.winnerIndex }
    var isRoundOver: Bool { game.isRoundOver }
    var leaderboard: LeaderboardService = LocalLeaderboardService()
    private static let saveURL = URL.documentsDirectory
        .appending(path: "savedGame.json")
    
    var playerOneName: String {
        get {
            game.players[0].name
        }
        set {
            game.renamePlayer(at: 0, to: newValue)
        }
    }
    
    var playerTwoName: String {
        get {
            game.players[1].name
        }
        set {
            game.renamePlayer(at: 1, to: newValue)
        }
    }
    
    var canTossToken: Bool { game.canTossToken }
    var recoveryStep: HiLoGame.RecoveryStep { game.recoveryStep }
    
    func tossToken() { game.tossToken() }
    
    init(playerNames: [String]) {
        if let data = try? Data(contentsOf: Self.saveURL),
           let savedGame = try? JSONDecoder().decode(HiLoGame.self, from: data) {
            game = savedGame
        } else {
            var newGame = HiLoGame(playerNames: playerNames)
            newGame.resetGame()
            game = newGame
        }
        saveGame()
    }
    
    var canDrawCard: Bool {
        game.canDrawCard
    }

    func drawRequiredCard() {
        game.drawRequiredCard()
    }
    
    func resetGame() {
        game.resetGame()
    }
    
    var canResetDiscardPile: Bool {
        game.canResetDiscardPile
    }

    func resetDiscardPile() {
        game.resetDiscardPile()
    }
    
    func hand(for player: HiLoGame.Player) -> [HiLoGame.Card] {
        player.hand
    }
    
    func switchTurns() {
        game.switchTurns()
    }
    
    func play(_ card: HiLoGame.Card) -> Bool {
        guard game.play(card) else { return false }
        if game.isRoundOver {
            for player in game.players {
                let entry = LeaderboardEntry(playerName: player.name,
                                             score: player.score,
                                             createdAt: Date().ISO8601Format())
                leaderboard.record(entry)
            }
        }
        return true
    }
    
    private func saveGame() {
        _ = try? JSONEncoder().encode(game).write(to: Self.saveURL)
    }
}
